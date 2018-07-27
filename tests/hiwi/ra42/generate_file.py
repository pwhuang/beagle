import numpy as np
import pandas as pd
import subprocess
import sys
from itertools import product
import sympy as sp
import scipy.optimize as scp

def Beck_cell_predict(h_1, h_2, max_cell, Ra):
    pairs = []
    for p in product(range(0,max_cell+1), repeat=2):
        pairs.append(p)

    pairs.pop(0)
    pairs = np.array(pairs)

    #minimizing the objective_function
    obj_func = []
    for m, n in pairs:
        b = np.sqrt(m**2/h_1**2 + n**2/h_2**2)
        Ra_c = np.pi**2*(b+1.0/b)**2
        obj_func.append(Ra_c)

    obj_func = np.array(obj_func)
    sorted_index = np.argsort(obj_func, axis=0)
    obj_func = np.sort(obj_func, axis=0)

    pair_list = []
    for i in range(len(obj_func)):
        if obj_func[i]<Ra:
            pair_list.append(pairs[sorted_index][i])
        #print(pairs[sorted_index][i], obj_func[i])

    return pair_list

x = sp.Symbol('x', real=True)
y = sp.Symbol('y', real=True)
z = sp.Symbol('z', real=True)
h1,h2 = sp.symbols('h1 h2', real=True, nonzero=True)
m,n = sp.symbols('m n', real=True)
T_n = sp.Symbol('T_n', real = True)
T_f = T_n*sp.sin(sp.pi*y)*sp.cos(m*sp.pi*x/h1)*sp.cos(n*sp.pi*z/h2) + 1-y

EP = sp.integrate(sp.integrate(sp.integrate(sp.diff(T_f,x)**2 + sp.diff(T_f,y)**2 + sp.diff(T_f,z)**2, (x,0,h1)), (y,0,1)), (z,0,h2))/(h1*h2)

def amplitude_predict(m_val, n_val, h1_val, h2_val, Ra, T0):
    entropy_bound = 9.0/256*Ra
    #b = np.sqrt(m_val**2/h1_val**2 + n_val**2/h2_val**2)
    #Rac = np.pi**2*(b+1.0/b)**2
    #entropy_bound = 7.0/256*Ra*((Ra-Rac)/(Ra-4*np.pi**2))**0.15
    #entropy_bound = 1.0/256*Ra*5**((Ra-Rac)/(Ra-4*np.pi**2))
    if entropy_bound < 1.0:
        return [0,0,0,0]
    #Find an amplitude of temperature that is the closest to the amplitude bound
    while(EP.evalf(subs = {h1: h1_val, h2: h2_val, m: m_val, n: n_val, T_n: T0}) > entropy_bound):
        T0 -= 0.02

    denom = 1.0/(m_val**2/h1_val**2+n_val**2/h2_val**2+1)
    u0 = -T0*Ra**0.5*m_val/h1_val*denom
    v0 = T0*Ra**0.5*(m_val**2/h1_val**2+n_val**2/h2_val**2)*denom
    w0 = -T0*Ra**0.5*n_val/h2_val*denom

    return [u0,v0,w0,T0]

sys_arg = np.array(sys.argv) #input_csv, start_point, number of boxes to compute, Ra, output_csv

input_data = pd.read_csv(sys_arg[1])
start_point = int(sys_arg[2])
cubes_to_compute = int(sys_arg[3])
Ra = float(sys_arg[4])

nx_s = np.array(input_data['h1'], dtype=int)
nz_s = np.array(input_data['h2'], dtype=int)

nx = nx_s[start_point:start_point+cubes_to_compute]
nz = nz_s[start_point:start_point+cubes_to_compute]

nodes = np.array([nx, nz]).T

cl = 0.05
a0 = 1.5 #The coefficient of temperature initial condition

file_names = []

for node in nodes:
    xmax = str(node[0]*cl)
    zmax = str(node[1]*cl)

    string_to_write = 'xmax = ' + xmax + '\n' + 'zmax = ' + zmax + '\n' + 'nx = ' + str(node[0]) + '\n' + 'nz = ' + str(node[1]) + '\n'

    h1_val = node[0]*cl
    h2_val = node[1]*cl

    pair_list = Beck_cell_predict(h1_val, h2_val, 4, Ra)

    for pair in pair_list:
        m_val = pair[0]
        n_val = pair[1]

        amp = amplitude_predict(m_val, n_val, h1_val, h2_val, Ra, 2.0)

        T_init = 'value =' + "'" + str(amp[3]) + '*sin(pi*y)*cos(' + str(m_val) + '*pi*x/' + str(h1_val) + ')*cos(' + str(n_val) + '*pi*z/' + str(h2_val) + ') + 1.0-y' + "'" + '\n'
        u_init = 'value =' + "'" + str(amp[0]) + '*cos(pi*y)*sin(' + str(m_val) + '*pi*x/' + str(h1_val) + ')*cos(' + str(n_val) + '*pi*z/' + str(h2_val) + ')' + "'" + '\n'
        v_init = 'value =' + "'" + str(amp[1]) + '*sin(pi*y)*cos(' + str(m_val) + '*pi*x/' + str(h1_val) + ')*cos(' + str(n_val) + '*pi*z/' + str(h2_val) + ')' + "'" + '\n'
        w_init = 'value =' + "'" + str(amp[2]) + '*cos(pi*y)*cos(' + str(m_val) + '*pi*x/' + str(h1_val) + ')*sin(' + str(n_val) + '*pi*z/' + str(h2_val) + ')' + "'" + '\n'

        f = open("voa_beck_base.i", "r")
        contents = f.readlines()
        f.close()

        contents.insert(4, string_to_write)
        contents.insert(56, T_init)
        contents.insert(62, u_init)
        contents.insert(68, v_init)
        contents.insert(74, w_init)

        file_to_write = "voa_beck_gen" + str(node[0]) + '_' + str(node[1]) + '_' + str(m_val) + str(n_val) + '.i'
        f = open(file_to_write, "w")
        contents = "".join(contents)
        f.write(contents)
        f.close()
        file_names.append(file_to_write)
        print('File write complete!    ' + file_to_write)

        #pd.DataFrame(data=file_names, columns = ['file_name']).to_csv(output_csv_name, index=False)
        cmd = "srun -n 48 $BEAGLE_DIR/beagle-opt -i " + file_to_write
        returned_value = subprocess.call(cmd, shell=True)
