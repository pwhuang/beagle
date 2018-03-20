import numpy as np
import pandas as pd
import subprocess
import sys

sys_arg = np.array(sys.argv) #input_csv, start_point, number of cubes to compute

input_data = pd.read_csv(sys_arg[1])
start_point = int(sys_arg[2])
cubes_to_compute = int(sys_arg[3])

nx_s = np.array(input_data['h1'], dtype=int)
nz_s = np.array(input_data['h2'], dtype=int)

nx = nx_s[start_point:start_point+cubes_to_compute]
nz = nz_s[start_point:start_point+cubes_to_compute]

nodes = np.array([nx, nz]).T

cl = 0.05

for node in nodes:
    x = node[0]
    z = node[1]

    xmax = str(x*cl)
    zmax = str(z*cl)

    string_to_write = "file='voa_beck_gen" + str(x) + '_' + str(z) + '_out.e' "'\n"

    f = open("voa_beck_restart.i", "r")
    contents = f.readlines()
    f.close()

    contents.insert(2, string_to_write)

    file_to_write = "voa_beck_gen_restart" + str(x) + '_' + str(z) + '.i'
    f = open(file_to_write, "w")
    contents = "".join(contents)
    f.write(contents)
    f.close()

    cmd = "srun -n 48 $BEAGLE_DIR/beagle-opt -i " + file_to_write
    returned_value = subprocess.call(cmd, shell=True)
