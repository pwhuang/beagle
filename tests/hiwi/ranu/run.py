import numpy as np
import math
import pandas as pd
import subprocess
import sys
import time

sys_arg = np.array(sys.argv) #input_ifile, input_csv, start, total number of nodes, batch size

input_ifile = sys_arg[1]
input_csv = sys_arg[2]
start = int(sys_arg[3])
nodes = int(sys_arg[4])
batch_size = int(sys_arg[5])
h1_val = float(sys_arg[6])
h2_val = float(sys_arg[7])

cl = 0.05

for i in range(math.ceil((nodes-start)/batch_size)):
    start_point = int(i*batch_size) + start

    if start_point+batch_size > nodes:
        batch_size = int(nodes - start_point)

    string_to_write = 'python generate_file.py ' + input_ifile + ' ' + input_csv + ' ' + str(start_point) + ' ' + str(batch_size) + ' ' + str(h1_val) + ' ' + str(h2_val)

    f = open("/homea/jhpc52/jhpc5202/job/beck_gen_base.j", "r")
    contents = f.readlines()
    f.close()

    contents.insert(14, 'cd ~/projects/beagle/tests/hiwi/ranu\n')
    contents.insert(15, string_to_write)

    file_to_write = "/homea/jhpc52/jhpc5202/job/beck_gen.j"
    f = open(file_to_write, "w")
    contents = "".join(contents)
    f.write(contents)
    f.close()

    time.sleep(0.5)

    cmd = "sbatch ~/job/beck_gen.j"
    returned_value = subprocess.call(cmd, shell=True)
