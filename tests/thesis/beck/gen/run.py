import numpy as np
import pandas as pd
import subprocess
import sys
import time

sys_arg = np.array(sys.argv) #input_file, total number of nodes, batch size

input_file = sys_arg[1]
nodes = int(sys_arg[2])
batch_size = int(sys_arg[3])

cl = 0.05


for i in range(np.ceil([nodes/batch_size])[0]):
    start_point = int(i*batch_size)

    if start_point+batch_size > nodes:
        batch_size = int(nodes - start_point)

    string_to_write = 'python generate_file.py ' + input_file + ' ' + str(start_point) + ' ' + str(batch_size)

    f = open("~/job/beck_gen_base.j", "r")
    contents = f.readlines()
    f.close()

    contents.insert(15, string_to_write)

    file_to_write = "~/job/beck_gen.j"
    f = open(file_to_write, "w")
    contents = "".join(contents)
    f.write(contents)
    f.close()

    time.sleep(1)

    cmd = "sbatch ~/job/beck_gen.j"
    returned_value = subprocess.call(cmd, shell=True)
