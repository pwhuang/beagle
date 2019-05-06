import numpy as np
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
m = sp.symbols('m', real=True)
n = sp.symbols('n', real=True)
A = sp.symbols('A', real=True)

T = A*sp.sin(sp.pi*y)*sp.cos(m*sp.pi*x/h1)*sp.cos(n*sp.pi*z/h2)

Tx = sp.diff(T,x)
Ty = sp.diff(T,y)
Tz = sp.diff(T,z)

EP = sp.integrate(Tx**2 + Ty**2 + Tz**2 + 1, (x, 0, h1), (y, 0, 1), (z, 0, h2))/(h1*h2)

def amplitude_predict(EP, m_val, n_val, h1_val, h2_val, ra):
    A_val = 0.5
    entropy_production = float(EP.subs([(A, A_val), (m,m_val), (n,n_val), (h1,h1_val), (h2,h2_val)]).evalf())

    while (entropy_production > 9.0/256*ra):
        A_val = A_val - 0.02
        entropy_production = float(EP.subs([(m,m_val), (n,n_val), (h1,h1_val), (h2,h2_val), (A, A_val)]).evalf())
        #print(entropy_production)

    return A_val

sys_arg = np.array(sys.argv) #input_ifile, h1_val, h2_val

input_ifile = sys_arg[1]
h1_val = float(sys_arg[2])
h2_val = float(sys_arg[3])
ra_start = float(sys_arg[4])
ra_end = float(sys_arg[5])

ra_full = np.array(np.round(np.arange(ra_start,ra_end,0.1), 1), dtype=str)

print(ra_full)

for ra_str in ra_full:
    f = open(input_ifile + '.i', "r")
    contents = f.readlines()
    f.close()

    ra = float(ra_str)
    #ANOTHER LOOP HERE FOR THE POSSIBLE CELLS
    pair_list = Beck_cell_predict(h1_val, h2_val, 4, ra**2)[:3] #Only pick 3 of them from the first one

    for pair in pair_list:
        write_content = []
        m_val = pair[0]
        n_val = pair[1]

        #The maximum amplitude should be 0.5 for a particular mode
        EP = sp.integrate(Tx**2 + Ty**2 + Tz**2 + 1, (x, 0, h1), (y, 0, 1), (z, 0, h2))/(h1*h2)
        A_val = amplitude_predict(EP, m_val, n_val, h1_val, h2_val, ra**2)
        denom = 1.0/(m_val**2/h1_val**2 + n_val**2/h2_val**2 + 1)

        T_init = 'value =' + "'" + str(A_val) + '*sin(pi*y)*cos(' + str(m_val) + '*pi*x/' + str(h1_val) + ')*cos(' + str(n_val) + '*pi*z/' + str(h2_val) + ') + 1.0-y' + "'" + '\n'
        u_init = 'value =' + "'-" + str(A_val*m_val*ra/h1_val*denom) + '*cos(pi*y)*sin(' + str(m_val) + '*pi*x/' + str(h1_val) + ')*cos(' + str(n_val) + '*pi*z/' + str(h2_val) + ')' + "'" + '\n'
        v_init = 'value =' + "'" + str(A_val*ra*(m_val**2/h1_val**2 + n_val**2/h2_val**2)*denom) + '*sin(pi*y)*cos(' + str(m_val) + '*pi*x/' + str(h1_val) + ')*cos(' + str(n_val) + '*pi*z/' + str(h2_val) + ')' + "'" + '\n'
        w_init = 'value =' + "'-" + str(A_val*n_val*ra/h2_val*denom) + '*cos(pi*y)*cos(' + str(m_val) + '*pi*x/' + str(h1_val) + ')*sin(' + str(n_val) + '*pi*z/' + str(h2_val) + ')' + "'" + '\n'


        #if m_val == 0:
        #    amp_func = "'" + 'sin(pi*y)*cos(' + str(n_val) + '*pi*z/' + str(h2_val) + ')*4/' + str(h1_val*h2_val) + "'"
        #elif n_val == 0:
        #    amp_func = "'" + 'sin(pi*y)*cos(' + str(m_val) + '*pi*x/' + str(h1_val) + ')*4/' + str(h1_val*h2_val) + "'"
        #else:
        #    amp_func = "'" + 'sin(pi*y)*cos(' + str(m_val) + '*pi*x/' + str(h1_val) + ')*cos(' + str(n_val) + '*pi*z/' + str(h2_val) + ')*8/' + str(h1_val*h2_val) + "'"


        for row in contents:
            row = row.replace('#CHANGE_HERE!', str(ra), 2)
            row = row.replace('#INSERT_T_INIT', T_init)
            row = row.replace('#INSERT_U_INIT', u_init)
            row = row.replace('#INSERT_V_INIT', v_init)
            row = row.replace('#INSERT_W_INIT', w_init)
            #row = row.replace('#INSERT_AMPLITUDE_FUNCTION', amp_func)
            write_content.append(row)

        file_to_write = input_ifile + '_ra_' + ra_str + '_' + str(m_val) + str(n_val) + '.i'
        print(file_to_write, ' generated!')
        f = open(file_to_write, "w")

        output_content = "".join(write_content)
        f.write(output_content)
        f.close()

        cmd = "mpirun -n 1 $BEAGLE_DIR/beagle-opt -i " + file_to_write
        returned_value = subprocess.call(cmd, shell=True)
