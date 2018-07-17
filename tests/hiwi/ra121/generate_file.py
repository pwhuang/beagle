import numpy as np
import pandas as pd
import subprocess
import sys
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
a0 = 0.5 #The coefficient of temperature initial condition

file_names = []

for node in nodes:
    x = node[0]
    z = node[1]

    xmax = str(x*cl)
    zmax = str(z*cl)

    string_to_write = 'xmax = ' + xmax + '\n' + 'zmax = ' + zmax + '\n' + 'nx = ' + str(x) + '\n' + 'nz = ' + str(z) + '\n'

    h1 = x*cl
    h2 = z*cl

    pair_list = Beck_cell_predict(h1, h2, 3, Ra)

    for pair in pair_list:
        m = pair[0]
        n = pair[1]

        denom = 1.0/(m**2/h1**2+n**2/h2**2+1)

        T_init = 'value =' + "'" + str(a0) + '*sin(3.14*y)*cos(' + str(m) + '*3.14*x/' + str(h1) + ')*cos(' + str(n) + '*3.14*z/' + str(h2) + ') + 1.0-y' + "'" + '\n'
        u_init = 'value =' + "'" + str(-a0*Ra**0.5*m/h1*denom) + '*cos(3.14*y)*sin(' + str(m) + '*3.14*x/' + str(h1) + ')*cos(' + str(n) + '*3.14*z/' + str(h2) + ')' + "'" + '\n'
        v_init = 'value =' + "'" + str( a0*Ra**0.5*(m**2/h1**2-n**2/h2**2)*denom) + '*sin(3.14*y)*cos(' + str(m) + '*3.14*x/' + str(h1) + ')*cos(' + str(n) + '*3.14*z/' + str(h2) + ')' + "'" + '\n'
        w_init = 'value =' + "'" + str(-a0*Ra**0.5*n/h2*denom) + '*cos(3.14*y)*cos(' + str(m) + '*3.14*x/' + str(h1) + ')*sin(' + str(n) + '*3.14*z/' + str(h2) + ')' + "'" + '\n'

        f = open("voa_beck_base.i", "r")
        contents = f.readlines()
        f.close()

        contents.insert(4, string_to_write)
        contents.insert(56, T_init)
        contents.insert(62, u_init)
        contents.insert(68, v_init)
        contents.insert(74, w_init)


        file_to_write = "voa_beck_gen" + str(x) + '_' + str(z) + '_' + str(m) + str(n) + '.i'
        f = open(file_to_write, "w")
        contents = "".join(contents)
        f.write(contents)
        f.close()
        file_names.append(file_to_write)
        print('File write complete!    ' + file_to_write)

    #pd.DataFrame(data=file_names, columns = ['file_name']).to_csv(output_csv_name, index=False)
        cmd = "srun -n 48 $BEAGLE_DIR/beagle-opt -i " + file_to_write
        returned_value = subprocess.call(cmd, shell=True)
