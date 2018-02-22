import numpy as np
import math
import pandas as pd
import subprocess
import sys
import time

sys_arg = np.array(sys.argv) #input_file, total number of nodes, batch size

input_file = sys_arg[1]
start = int(sys_arg[2])
nodes = int(sys_arg[3])
batch_size = int(sys_arg[4])

cl = 0.05

for i in range(math.ceil((nodes-start)/batch_size)):
    start_point = int(i*batch_size) + start

    if start_point+batch_size > nodes:
        batch_size = int(nodes - start_point)

    string_to_write = 'python generate_file.py ' + input_file + ' ' + str(start_point) + ' ' + str(batch_size)

    f = open("/homea/jhpc52/jhpc5202/job/beck_gen_base.j", "r")
    contents = f.readlines()
    f.close()

    contents.insert(14, 'cd ~/projects/beagle/tests/thesis/beck/ra64\n')
    contents.insert(15, string_to_write)

    file_to_write = "/homea/jhpc52/jhpc5202/job/beck_gen.j"
    f = open(file_to_write, "w")
    contents = "".join(contents)
    f.write(contents)
    f.close()

    time.sleep(0.5)

    cmd = "sbatch ~/job/beck_gen.j"
    returned_value = subprocess.call(cmd, shell=True)
