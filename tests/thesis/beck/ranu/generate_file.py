import numpy as np
import pandas as pd
import subprocess
import sys

sys_arg = np.array(sys.argv) #input_ifile, input_csv, start_point, number to compute

input_ifile = sys_arg[1]
input_data = pd.read_csv(sys_arg[2])
start_point = int(sys_arg[3])
cubes_to_compute = int(sys_arg[4])

ra_full = input_data['Ra'][start_point:start_point + cubes_to_compute]

for ra in ra_full:
    f = open(input_ifile + '.i', "r")
    contents = f.readlines()
    f.close()

    endtime = np.around(700/(ra*ra) - 1.5, 1) #The + 3.5 is only for some nodes of long2 test

    write_content = []
    for row in contents:
        row = row.replace('#CHANGE_HERE!', str(ra))
        row = row.replace('#CHANGE_ENDTIME', str(endtime))
        write_content.append(row)

    file_to_write = input_ifile + '_ra_' + str(ra) + '.i'
    f = open(file_to_write, "w")

    write_content = "".join(write_content)
    f.write(write_content)
    f.close()

    cmd = "srun -n 48 $BEAGLE_DIR/beagle-opt -i " + file_to_write
    returned_value = subprocess.call(cmd, shell=True)
