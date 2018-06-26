import numpy as np
import pandas as pd
import subprocess
import sys
from itertools import product

sys_arg = np.array(sys.argv)

a1 = [0,0.125,0.25]
a2 = [0,0.125,0.25]
a3 = [0,0.125,0.25]
a4 = [0,0.125,0.25]

x = '0'
label = []

for i in product(x,x,x,x):
    label.append(i[0]+i[1]+i[2]+i[3])

for c, i in enumerate(product(a1, a2, a3, a4)):
    #Write to the MOOSE input file
    string_to_write = "value = '" + str(i[0]) + '*sin(3.14*y)*cos(3.14*z) + '
    string_to_write += str(i[1]) + '*sin(3.14*y)*cos(3.14*x/1.5)*cos(3.14*z) + '
    string_to_write += str(i[2]) + '*sin(3.14*y)*cos(2*3.14*x/1.5) + '
    string_to_write += str(i[3]) + '*sin(3.14*y)*cos(3.14*x/1.5)'
    string_to_write += "'\n"

    f = open("~/projects/beagle/tests/hiwi/voa_basin.i", "r")
    contents = f.readlines()
    f.close()

    contents.insert(62, string_to_write)

    file_to_write = "~/projects/beagle/tests/hiwi/voa_basin_" + label[c] + '.i'
    f = open(file_to_write, "w")
    contents = "".join(contents)
    f.write(contents)
    f.close()

    #Write to the batch file
    f = open("/homea/jhpc52/jhpc5202/job/beck_gen_base.j", "r")
    contents = f.readlines()
    f.close()

    contents.insert(14, 'cd ~/projects/beagle/tests/hiwi\n')
    contents.insert(15, 'srun -n 48 $BEAGLE_DIR/beagle-opt -i' + file_to_write)

    file_to_write = "/homea/jhpc52/jhpc5202/job/beck_gen.j"
    f = open(file_to_write, "w")
    contents = "".join(contents)
    f.write(contents)
    f.close()

    cmd = 'sbatch /homea/jhpc52/jhpc5202/job/beck_gen.j'
    returned_value = subprocess.call(cmd, shell=True)
    time.sleep(0.5)
