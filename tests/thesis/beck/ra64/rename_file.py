import numpy as np
import pandas as pd
import subprocess
import sys

sys_arg = np.array(sys.argv) #input_csv, file_type

input_data = pd.read_csv(sys_arg[1])
file_type = sys_arg[2]

nx = np.array(input_data['h1'], dtype=int)
nz = np.array(input_data['h2'], dtype=int)

nodes = np.array([nx, nz]).T

cl = 0.05

for node in nodes:
    x = node[0]
    z = node[1]

    if file_type=='csv':
        file1 = 'voa_beck_gen' + str(x) + '_' + str(z) + '_out.' + file_type
        file2 = 'voa_beck_gen_combined' + str(x) + '_' + str(z) + '_out.' + file_type
    elif file_type=='e':
        file1 = 'voa_beck_gen' + str(x) + '_' + str(z) + '_out.' + file_type
        file2 = 'voa_beck_gen_restart' + str(x) + '_' + str(z) + '_out.' + file_type

    cmd = "mv " + file2 + ' ' + file1
    returned_value = subprocess.call(cmd, shell=True)

print('rename_file: All done!')
