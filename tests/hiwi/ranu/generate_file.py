import numpy as np
import pandas as pd
import subprocess
import sys
import sympy as sp
from itertools import product

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
    if entropy_bound < 1.0:
        return [0,0,0,0]
    #Find an amplitude of temperature that is the closest to the amplitude bound
    while(EP.evalf(subs = {h1: h1_val, h2: h2_val, m: m_val, n: n_val, T_n: T0}) > entropy_bound):
        T0 -= 0.1

    denom = 1.0/(m_val**2/h1_val**2+n_val**2/h2_val**2+1)
    u0 = -T0*Ra**0.5*m_val/h1_val*denom
    v0 = T0*Ra**0.5*(m_val**2/h1_val**2+n_val**2/h2_val**2)*denom
    w0 = -T0*Ra**0.5*n_val/h2_val*denom

    return [u0,v0,w0,T0]

sys_arg = np.array(sys.argv) #input_ifile, input_csv, start_point, number to compute, h1_val, h2_val

input_ifile = sys_arg[1]
input_data = pd.read_csv(sys_arg[2])
start_point = int(sys_arg[3])
cubes_to_compute = int(sys_arg[4])
h1_val = float(sys_arg[5])
h2_val = float(sys_arg[6])

ra_full = input_data['Ra'][start_point:start_point + cubes_to_compute]

for ra in ra_full:
    f = open(input_ifile + '.i', "r")
    contents = f.readlines()
    f.close()

    #ANOTHER LOOP HERE FOR THE POSSIBLE CELLS
    pair_list = Beck_cell_predict(h1_val, h2_val, 4, ra**2)
    #ONLY PICK THE FIRST 4 POSSIBLE PAIRS
    pair_list = pair_list[:4]

    for pair in pair_list:
        write_content = []
        m_val = pair[0]
        n_val = pair[1]

        amp = amplitude_predict(m_val, n_val, h1_val, h2_val, ra**2, 4.0)

        T_init = 'value =' + "'" + str(amp[3]) + '*sin(pi*y)*cos(' + str(m_val) + '*pi*x/' + str(h1_val) + ')*cos(' + str(n_val) + '*pi*z/' + str(h2_val) + ') + 1.0-y' + "'" + '\n'
        u_init = 'value =' + "'" + str(amp[0]) + '*cos(pi*y)*sin(' + str(m_val) + '*pi*x/' + str(h1_val) + ')*cos(' + str(n_val) + '*pi*z/' + str(h2_val) + ')' + "'" + '\n'
        v_init = 'value =' + "'" + str(amp[1]) + '*sin(pi*y)*cos(' + str(m_val) + '*pi*x/' + str(h1_val) + ')*cos(' + str(n_val) + '*pi*z/' + str(h2_val) + ')' + "'" + '\n'
        w_init = 'value =' + "'" + str(amp[2]) + '*cos(pi*y)*cos(' + str(m_val) + '*pi*x/' + str(h1_val) + ')*sin(' + str(n_val) + '*pi*z/' + str(h2_val) + ')' + "'" + '\n'

        for row in contents:
            row = row.replace('#CHANGE_HERE!', str(ra))
            row = row.replace('#INSERT_T_INIT', T_init)
            row = row.replace('#INSERT_U_INIT', u_init)
            row = row.replace('#INSERT_V_INIT', v_init)
            row = row.replace('#INSERT_W_INIT', w_init)
            write_content.append(row)

        file_to_write = input_ifile + '_ra_' + str(ra) + '_' + str(m_val) + str(n_val) + '.i'
        f = open(file_to_write, "w")

        output_content = "".join(write_content)
        f.write(output_content)
        f.close()

        cmd = "srun -n 48 $BEAGLE_DIR/beagle-opt -i " + file_to_write
        returned_value = subprocess.call(cmd, shell=True)
