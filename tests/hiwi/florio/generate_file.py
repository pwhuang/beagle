import numpy as np
import subprocess
import sys
from itertools import product

sys_arg = np.array(sys.argv) #file_to_read

file_to_read = sys_arg[1]

Ra = 6.5

theta = np.linspace(0,np.pi/2,17)
theta_round = np.array(np.around(theta, decimals=2), dtype=str)

h1 = 1.189
h2 = 1.189

denom01 = 1.0/(1/h2**2 + 1)
denom11 = 1.0/(1/h1**2 + 1/h2**2 + 1)

for t_count, t in enumerate(theta):
    for NS_str in ['4e-2', '8e-2', '12e-2', '16e-2']:
        NS = float(NS_str)
        a = np.sqrt(4*2**0.5*NS/(np.pi**2*(2**0.5 + 1)))
        b = np.sqrt(8*2**0.5*NS/(np.pi**2*(2**0.5 + 2)))
        A01 = a*np.cos(t)
        A11 = b*np.sin(t)
        T_init_out = "value = '" + str(A01) + '*sin(pi*y)*cos(pi*z/' + str(h2) + ') + ' + str(A11) + '*sin(pi*y)*cos(pi*x/' + str(h1) + ')*cos(pi*z/' + str(h2) + ')' + '+ 1-y ' + "'" + '\n'
        u_init_out = "value = '" + str(-A11*Ra/h1*denom11) + '*cos(pi*y)*sin(pi*x/' + str(h1) + ')*cos(pi*z/' + str(h2) + ')' + "'" + '\n'
        v_init_out = "value = '" + str(A01*Ra*1.0/h2**2*denom01) + '*sin(pi*y)*cos(pi*z/' + str(h2) + ') + ' + str(A11*Ra*(1.0/h1**2 + 1.0/h2**2)*denom11) + '*sin(pi*y)*cos(pi*x/' + str(h1) + ')*cos(pi*z/' + str(h2) + ')' + "'" + '\n'
        w_init_out = "value = '" + str(-A01*Ra*1.0/h2*denom01) + '*cos(pi*y)*sin(pi*z/' + str(h2) + ') + ' + str(-A11*Ra*1.0/h2**2*denom11) + '*cos(pi*y)*cos(pi*x/' + str(h1) + ')*sin(pi*z/' + str(h2) + ')' + "'" + '\n'

        f = open(file_to_read + '.i', "r")
        contents = f.readlines()
        f.close()

        contents.insert(60, T_init_out)
        contents.insert(66, u_init_out)
        contents.insert(72, v_init_out)
        contents.insert(78, w_init_out)

        file_to_write = file_to_read + '_NS_' + NS_str + '_theta_' + str(np.around(t, decimals=2)) + '.i'

        f = open(file_to_write, "w")
        contents = "".join(contents)
        f.write(contents)
        f.close()
        print('File write complete!    ' + file_to_write)

        cmd = "mpirun -n 6 $BEAGLE_DIR/beagle-opt -i " + file_to_write
        returned_value = subprocess.call(cmd, shell=True)
