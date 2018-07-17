import numpy as np
import pandas as pd
import subprocess
import sys
from itertools import product

sys_arg = np.array(sys.argv) #a0, Ra

a0_i = int(sys_arg[1])
Ra = float(sys_arg[2])

pairs = np.array([[0,1], [2,0], [1,0]])
m = pairs.T[0]
n = pairs.T[1]

h1 = 1.414
h2 = 0.707

a0 = np.linspace(0,0.12,7)
A1 = np.linspace(0,0.12,7)
A2 = np.linspace(0,0.12,7)

x = '0123456'
label = []

for i in product(x,x):
    label.append(str(a0_i)+i[0]+i[1])

counter = 0

#for c, i in enumerate(product(a0, a1, a2)):
for a1 in A1:
    #Reinitialize
    denom = 1.0/(m[0]**2/h1**2+n[0]**2/h2**2+1)
    T_init = 'value =' + "'" + str(a0[a0_i]) + '*sin(3.14*y)*cos(' + str(m[0]) + '*3.14*x/' + str(h1) + ')*cos(' + str(n[0]) + '*3.14*z/' + str(h2) + ') + 1.0-y + '
    u_init = 'value =' + "'" + str(-a0[a0_i]*Ra**0.5*m[0]/h1*denom) + '*cos(3.14*y)*sin(' + str(m[0]) + '*3.14*x/' + str(h1) + ')*cos(' + str(n[0]) + '*3.14*z/' + str(h2) + ') + '
    v_init = 'value =' + "'" + str( a0[a0_i]*Ra**0.5*(m[0]**2/h1**2-n[0]**2/h2**2)*denom) + '*sin(3.14*y)*cos(' + str(m[0]) + '*3.14*x/' + str(h1) + ')*cos(' + str(n[0]) + '*3.14*z/' + str(h2) + ') + '
    w_init = 'value =' + "'" + str(-a0[a0_i]*Ra**0.5*n[0]/h2*denom) + '*cos(3.14*y)*cos(' + str(m[0]) + '*3.14*x/' + str(h1) + ')*sin(' + str(n[0]) + '*3.14*z/' + str(h2) + ') + '

    denom = 1.0/(m[1]**2/h1**2+n[1]**2/h2**2+1)
    T_init += str(a1) + '*sin(3.14*y)*cos(' + str(m[1]) + '*3.14*x/' + str(h1) + ')*cos(' + str(n[1]) + '*3.14*z/' + str(h2) + ') + '
    u_init += str(-a1*Ra**0.5*m[1]/h1*denom) + '*cos(3.14*y)*sin(' + str(m[1]) + '*3.14*x/' + str(h1) + ')*cos(' + str(n[1]) + '*3.14*z/' + str(h2) + ') + '
    v_init += str( a1*Ra**0.5*(m[1]**2/h1**2-n[1]**2/h2**2)*denom) + '*sin(3.14*y)*cos(' + str(m[1]) + '*3.14*x/' + str(h1) + ')*cos(' + str(n[1]) + '*3.14*z/' + str(h2) + ') + '
    w_init += str(-a1*Ra**0.5*n[1]/h2*denom) + '*cos(3.14*y)*cos(' + str(m[1]) + '*3.14*x/' + str(h1) + ')*sin(' + str(n[1]) + '*3.14*z/' + str(h2) + ') + '
    for a2 in A2:
        denom = 1.0/(m[2]**2/h1**2+n[2]**2/h2**2+1)
        T_init_out = T_init + str(a2) + '*sin(3.14*y)*cos(' + str(m[2]) + '*3.14*x/' + str(h1) + ')*cos(' + str(n[2]) + '*3.14*z/' + str(h2) + ')' + "'" + '\n'
        u_init_out = u_init + str(-a2*Ra**0.5*m[2]/h1*denom) + '*cos(3.14*y)*sin(' + str(m[2]) + '*3.14*x/' + str(h1) + ')*cos(' + str(n[2]) + '*3.14*z/' + str(h2) + ')' + "'" + '\n'
        v_init_out = v_init + str( a2*Ra**0.5*(m[2]**2/h1**2-n[2]**2/h2**2)*denom) + '*sin(3.14*y)*cos(' + str(m[2]) + '*3.14*x/' + str(h1) + ')*cos(' + str(n[2]) + '*3.14*z/' + str(h2) + ')' + "'" + '\n'
        w_init_out = w_init + str(-a2*Ra**0.5*n[2]/h2*denom) + '*cos(3.14*y)*cos(' + str(m[2]) + '*3.14*x/' + str(h1) + ')*sin(' + str(n[2]) + '*3.14*z/' + str(h2) + ')' + "'" + '\n'

        f = open("voa_florio_ex1.i", "r")
        contents = f.readlines()
        f.close()

        contents.insert(60, T_init_out)
        contents.insert(66, u_init_out)
        contents.insert(72, v_init_out)
        contents.insert(78, w_init_out)

        file_to_write = "voa_florio_ex1_" + label[counter] + '.i'
        counter += 1
        f = open(file_to_write, "w")
        contents = "".join(contents)
        f.write(contents)
        f.close()
        print('File write complete!    ' + file_to_write)

        cmd = "srun -n 48 $BEAGLE_DIR/beagle-opt -i " + file_to_write
        returned_value = subprocess.call(cmd, shell=True)
