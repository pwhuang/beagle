import numpy as np
import math
import pandas as pd
import subprocess
import sys
import time

sys_arg = np.array(sys.argv) #start_seed, end_seed

start_seed = int(sys_arg[1])
end_seed = int(sys_arg[2])

for seed in range(start_seed, end_seed):
    string_to_write = 'python generate_file.py ' + str(seed)

    f = open("/homea/jhpc52/jhpc5202/job/beck_gen_base.j", "r")
    contents = f.readlines()
    f.close()

    contents.insert(14, 'cd ~/projects/beagle/tests/hiwi\n')
    contents.insert(15, string_to_write)

    file_to_write = "/homea/jhpc52/jhpc5202/job/beck_gen.j"
    f = open(file_to_write, "w")
    contents = "".join(contents)
    f.write(contents)
    f.close()

    time.sleep(0.5)

    cmd = "sbatch ~/job/beck_gen.j"
    returned_value = subprocess.call(cmd, shell=True)
