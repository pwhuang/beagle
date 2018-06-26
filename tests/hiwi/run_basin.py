import numpy as np
import pandas as pd
import subprocess
import sys

sys_arg = np.array(sys.argv) #the seed for the cubes to compute

seed = int(sys_arg[1])

a1 = [0,0.125,0.25]
a2 = [0,0.125,0.25]
a3 = [0,0.125,0.25]
a4 = [0,0.125,0.25]

x = '012'
label = []

for i in product(x,x,x,x):
    label.append(i[0]+i[1]+i[2]+i[3])

for c, i in enumerate(product(a1, a2, a3, a4)):
    string_to_write = "value = '" + str(i[0]) + '*sin(3.14*y)*cos(3.14*z) + '
    string_to_write += str(i[1]) + '*sin(3.14*y)*cos(3.14*x/1.5)*cos(3.14*z) + '
    string_to_write += str(i[2]) + '*sin(3.14*y)*cos(2*3.14*x/1.5) + '
    string_to_write += str(i[3]) + '*sin(3.14*y)*cos(3.14*x/1.5)'
    string_to_write += "'\n"

    f = open("voa_basin.i", "r")
    contents = f.readlines()
    f.close()

    contents.insert(62, string_to_write)

    file_to_write = "voa_basin_" + label[c] + '.i'
    f = open(file_to_write, "w")
    contents = "".join(contents)
    f.write(contents)
    f.close()

    cmd = "srun -n 48 $BEAGLE_DIR/beagle-opt -i " + file_to_write
    returned_value = subprocess.call(cmd, shell=True)
