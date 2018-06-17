import numpy as np
import pandas as pd
import subprocess
import sys

sys_arg = np.array(sys.argv) #the seed for the cubes to compute

seed = int(sys_arg[1])

string_to_write = 'seed = ' + str(seed) + '\n'

f = open("voa_long.i", "r")
contents = f.readlines()
f.close()

contents.insert(81, string_to_write)

file_to_write = "voa_long_seed_" + str(seed) + '.i'
f = open(file_to_write, "w")
contents = "".join(contents)
f.write(contents)
f.close()

cmd = "srun -n 48 $BEAGLE_DIR/beagle-opt -i " + file_to_write
returned_value = subprocess.call(cmd, shell=True)
