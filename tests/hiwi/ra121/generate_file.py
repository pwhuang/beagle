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
u_n, v_n, w_n = sp.symbols('u_n v_n w_n', real=True)
R = sp.symbols('R', real=True)

T = sp.sin(sp.pi*y)*sp.cos(m*sp.pi*x/h1)*sp.cos(n*sp.pi*z/h2)
u = sp.sin(m*sp.pi*x/h1)*sp.cos(n*sp.pi*z/h2)*sp.cos(sp.pi*y)
v = sp.cos(m*sp.pi*x/h1)*sp.cos(n*sp.pi*z/h2)*sp.sin(sp.pi*y)
w = sp.cos(m*sp.pi*x/h1)*sp.sin(n*sp.pi*z/h2)*sp.cos(sp.pi*y)

lp1 = sp.integrate(sp.integrate(sp.integrate(sp.diff(u,x)**2 + sp.diff(u,y)**2 + sp.diff(u,z)**2, (x,0,h1)), (y,0,1)), (z,0,h2))
lp1 = sp.simplify(lp1)

uT_couple = sp.integrate(sp.integrate(sp.integrate(sp.diff(T, x)*sp.diff(u, y), (x,0,h1)), (y,0,1)), (z,0,h2))
uT_couple = sp.simplify(uT_couple)

lp2 = sp.integrate(sp.integrate(sp.integrate(sp.diff(v,x)**2 + sp.diff(v,y)**2 + sp.diff(v,z)**2, (x,0,h1)), (y,0,1)), (z,0,h2))
lp2 = sp.simplify(lp2)

vT_couple = -sp.integrate(sp.integrate(sp.integrate(sp.diff(v,x)*sp.diff(T,x) + sp.diff(v,z)*sp.diff(T,z), (x,0,h1)), (y,0,1)), (z,0,h2))
vT_couple = sp.simplify(vT_couple)

lp3 = sp.integrate(sp.integrate(sp.integrate(sp.diff(w,x)**2 + sp.diff(w,y)**2 + sp.diff(w,z)**2, (x,0,h1)), (y,0,1)), (z,0,h2))
lp3 = sp.simplify(lp3)

wT_couple = sp.integrate(sp.integrate(sp.integrate(sp.diff(w,y)*sp.diff(T,z), (x,0,h1)), (y,0,1)), (z,0,h2))
wT_couple = sp.simplify(wT_couple)

lp4 = sp.integrate(sp.integrate(sp.integrate((sp.diff(T,x)**2 + sp.diff(T,y)**2 + sp.diff(T,z)**2 + (sp.diff(u,x)*sp.diff(T,x) + sp.diff(u,y)*sp.diff(T,y) + sp.diff(u,z)*sp.diff(T,z))), (x,0,h1)), (y,0,1)),(z,0,h2))
lp4 = sp.simplify(lp4)

Tv_couple = sp.integrate(sp.integrate(sp.integrate((T+u)*v, (x,0,h1)), (y,0,1)), (z,0,h2))
Tv_couple = sp.simplify(Tv_couple)

NL = sp.integrate(sp.integrate(sp.integrate((u_n*u*sp.diff(v,x) + v_n*v*sp.diff(v,y) + w_n*w*sp.diff(v,z))*(T+u), (x,0,h1)), (y,0,1)), (z,0,h2))
NL = sp.simplify(NL)

Trans = sp.integrate(sp.integrate(sp.integrate((u+T)*T, (x,0,h1)),(y,0,1)),(z,0,h2))
Trans = sp.simplify(Trans)

T_n = sp.Symbol('T_n', real = True)
T_f = T_n*sp.sin(sp.pi*y)*sp.cos(m*sp.pi*x/h1)*sp.cos(n*sp.pi*z/h2) + 1-y
EP = sp.integrate(sp.integrate(sp.integrate(sp.diff(T_f,x)**2 + sp.diff(T_f,y)**2 + sp.diff(T_f,z)**2, (x,0,h1)), (y,0,1)), (z,0,h2))/(h1*h2)

def construct_A_mat(x_vec, dt, h1_val, h2_val, m_val, n_val, Ra_sqrt):
    if n_val==0:
        A_mat = np.zeros([3,3])
        b_vec = np.array([0,0,0])

        A_mat[0,0] = lp1.evalf(subs = {h1: h1_val, h2: h2_val, m: m_val, n: n_val})
        A_mat[0,2] = Ra_sqrt*uT_couple.evalf(subs = {h1: h1_val, h2: h2_val, m: m_val, n: n_val})

        A_mat[1,1] = lp2.evalf(subs = {h1: h1_val, h2: h2_val, m: m_val, n: n_val})
        A_mat[1,2] = Ra_sqrt*vT_couple.evalf(subs = {h1: h1_val, h2: h2_val, m: m_val, n: n_val})

        A_mat[2,2] = lp4.evalf(subs = {h1: h1_val, h2: h2_val, m: m_val, n: n_val})
        A_mat[2,2]+= Ra_sqrt*NL.evalf(subs = {h1: h1_val, h2: h2_val, m: m_val, n: n_val, u_n: x_vec[0], v_n: x_vec[1], w_n: x_vec[2]})
        A_mat[2,2]+= 1.0/dt*Trans.evalf(subs = {h1: h1_val, h2: h2_val, m: m_val, n: n_val})

        A_mat[2,1] = -Ra_sqrt*Tv_couple.evalf(subs = {h1: h1_val, h2: h2_val, m: m_val, n: n_val})

    elif m_val==0:
        A_mat = np.zeros([3,3])
        b_vec = np.array([0,0,0])

        A_mat[0,0] = lp2.evalf(subs = {h1: h1_val, h2: h2_val, m: m_val, n: n_val})
        A_mat[0,2] = Ra_sqrt*vT_couple.evalf(subs = {h1: h1_val, h2: h2_val, m: m_val, n: n_val})

        A_mat[1,1] = lp3.evalf(subs = {h1: h1_val, h2: h2_val, m: m_val, n: n_val})
        A_mat[1,2] = Ra_sqrt*wT_couple.evalf(subs = {h1: h1_val, h2: h2_val, m: m_val, n: n_val})

        A_mat[2,2] = lp4.evalf(subs = {h1: h1_val, h2: h2_val, m: m_val, n: n_val})
        A_mat[2,2]+= Ra_sqrt*NL.evalf(subs = {h1: h1_val, h2: h2_val, m: m_val, n: n_val, u_n: x_vec[0], v_n: x_vec[1], w_n: x_vec[2]})
        A_mat[2,2]+= 1.0/dt*Trans.evalf(subs = {h1: h1_val, h2: h2_val, m: m_val, n: n_val})

        A_mat[2,0] = -Ra_sqrt*Tv_couple.evalf(subs = {h1: h1_val, h2: h2_val, m: m_val, n: n_val})
    else:
        A_mat = np.zeros([4,4])
        b_vec = np.array([0,0,0,0])

        A_mat[0,0] = lp1.evalf(subs = {h1: h1_val, h2: h2_val, m: m_val, n: n_val})
        A_mat[0,3] = Ra_sqrt*uT_couple.evalf(subs = {h1: h1_val, h2: h2_val, m: m_val, n: n_val})

        A_mat[1,1] = lp2.evalf(subs = {h1: h1_val, h2: h2_val, m: m_val, n: n_val})
        A_mat[1,3] = Ra_sqrt*vT_couple.evalf(subs = {h1: h1_val, h2: h2_val, m: m_val, n: n_val})

        A_mat[2,2] = lp3.evalf(subs = {h1: h1_val, h2: h2_val, m: m_val, n: n_val})
        A_mat[2,3] = Ra_sqrt*wT_couple.evalf(subs = {h1: h1_val, h2: h2_val, m: m_val, n: n_val})

        A_mat[3,3] = lp4.evalf(subs = {h1: h1_val, h2: h2_val, m: m_val, n: n_val})
        A_mat[3,3]+= Ra_sqrt*NL.evalf(subs = {h1: h1_val, h2: h2_val, m: m_val, n: n_val, u_n: x_vec[0], v_n: x_vec[1], w_n: x_vec[2]})
        A_mat[3,3]+= 1.0/dt*Trans.evalf(subs = {h1: h1_val, h2: h2_val, m: m_val, n: n_val})

        A_mat[3,1] = -Ra_sqrt*Tv_couple.evalf(subs = {h1: h1_val, h2: h2_val, m: m_val, n: n_val})

    #b_vec[-1] = -x_vec[-1]*Ra_sqrt*NL.evalf(subs = {h1: h1_val, h2: h2_val, m: m_val, n: n_val, u_n: x_vec[0], v_n: x_vec[1], w_n: x_vec[2]})
    b_vec[-1] = 1.0/dt*Trans.evalf(subs = {h1: h1_val, h2: h2_val, m: m_val, n: n_val})*x_vec[-1]
    return A_mat, b_vec

def solve_amplitude(m_val, n_val, h1_val, h2_val, Ra_sq):
    def F(x):
        A_mat, b_vec = construct_A_mat(x, 1e-4, h1_val, h2_val, m_val, n_val, Ra_sq)
        return np.dot(A_mat, x) - b_vec

    if m_val==0 or n_val==0:
        input_vec = np.array([0,0,1.0])
    else:
        input_vec = np.array([0,0,0,1.0])

    candidate = []
    for i in np.linspace(0.1,2,19):
        #try:
        sol_vec = scp.root(F, i*input_vec, method='broyden1', tol=1e-14)
        #except:
        #    print('Exception occured!')
        #    continue
        if(EP.evalf(subs = {h1: h1_val, h2: h2_val, m: m_val, n: n_val, T_n: sol_vec.x[-1]}) < 9.0/256.0*Ra_sq*Ra_sq):
            candidate.append(sol_vec.x)
        print(sol_vec.x)

    if len(candidate) == 0:
        return [0,0,0,0]

    candidate = np.array(candidate)
    #amplitudes to return
    amp = candidate[np.argmax(np.abs(candidate[:,-1]))]

    if m_val==0:
        amp = np.array([0.0, amp[0], amp[1], amp[2]])
    elif n_val==0:
        amp = np.array([amp[0], amp[1], 0.0, amp[2]])

    return amp

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

    pair_list = Beck_cell_predict(h1_val, h2_val, 8, Ra)

    for pair in pair_list:
        m_val = pair[0]
        n_val = pair[1]

        amp = solve_amplitude(m_val, n_val, h1_val, h2_val, Ra**0.5)

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
