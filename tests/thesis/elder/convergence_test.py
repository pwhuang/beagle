import numpy as np
import subprocess
import sys

sys_arg = np.array(sys.argv) #nx, nz

file_name = sys_arg[1]
mesh_type = sys_arg[2]

if mesh_type=='quad':
    string_to_write = [
    "file = '../../mesh/elder_cl2-4_quad.msh'",
    "file = '../../mesh/elder_cl2-5_quad.msh'",
    "file = '../../mesh/elder_cl2-6_quad.msh'",
    "file = '../../mesh/elder_cl2-7_quad.msh'"
    ]
else:
    string_to_write = [
    "file = '../../mesh/elder_cl2-4.msh'",
    "file = '../../mesh/elder_cl2-5.msh'",
    "file = '../../mesh/elder_cl2-6.msh'",
    "file = '../../mesh/elder_cl2-7.msh'"
    ]

file_to_write = file_name + '_conv.i'

for string in string_to_write:
    f = open(file_name + '.i', "r")
    contents = f.readlines()
    f.close()

    contents.insert(1, string + '\n')

    f = open(file_to_write, "w")
    written_contents = "".join(contents)
    f.write(written_contents)
    f.close()

    cmd = "mpirun -n 48 $BEAGLE_DIR/beagle-opt -i " + file_to_write
    returned_value = subprocess.call(cmd, shell=True)
