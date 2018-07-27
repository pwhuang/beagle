import numpy as np
import math
import pandas as pd
import subprocess
import sys
import time

sys_arg = np.array(sys.argv) #input_file, start, total number of nodes, batch size

input_file = sys_arg[1]
start = int(sys_arg[2])
nodes = int(sys_arg[3])
batch_size = int(sys_arg[4])

cl = 0.05

for i in range(math.ceil((nodes-start)/batch_size)):
    start_point = int(i*batch_size) + start

    if start_point+batch_size > nodes:
        batch_size = int(nodes - start_point)

    f = open("/homea/jhpc52/jhpc5202/job/beck_gen_base.j", "r")
    contents = f.readlines()
    f.close()

    #string_to_write = 'python generate_file_long.py' + input_file + ' ' + str(start_point) + ' ' + str(batch_size) + ' 42.25'

    contents.insert(14, 'cd ~/projects/beagle/tests/hiwi/florio\n')

    counter = 15
    for j in range(batch_size):
        string_to_write = 'mpirun -n 48 $BEAGLE_DIR/beagle_opt -i voa_florio_long_' + str(start_point) + '.i\n'
        contents.insert(counter, string_to_write)
        counter+=1
        start_point+=1

    file_to_write = "/homea/jhpc52/jhpc5202/job/beck_gen.j"
    f = open(file_to_write, "w")
    contents = "".join(contents)
    f.write(contents)
    f.close()

    time.sleep(0.5)

    cmd = "sbatch ~/job/beck_gen.j"
    returned_value = subprocess.call(cmd, shell=True)
