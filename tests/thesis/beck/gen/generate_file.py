import numpy as np
import subprocess
import sys

sys_arg = np.array(sys.argv) #nx, nz

nx_s = sys_arg[1]
nz_s = sys_arg[2]

nx = int(nx_s)
nz = int(nz_s)
cl = 0.05

xmax = str(nx*cl)
zmax = str(nz*cl)

string_to_write = 'xmax = ' + xmax + '\n' + 'zmax = ' + zmax + '\n' + 'nx = ' + nx_s + '\n' + 'nz = ' + nz_s + '\n'


f = open("voa_beck_base.i", "r")
contents = f.readlines()
f.close()

contents.insert(4, string_to_write)

file_to_write = "voa_beck_gen" + nx_s + '_' + nz_s + '.i'
f = open(file_to_write, "w")
contents = "".join(contents)
f.write(contents)
f.close()

cmd = "mpirun -n 48 $BEAGLE_DIR/beagle-opt -i " + file_to_write
returned_value = subprocess.call(cmd, shell=True)
