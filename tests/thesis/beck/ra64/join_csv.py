import numpy as np
import pandas as pd
import subprocess
import sys

sys_arg = np.array(sys.argv) #input_csv

input_data = pd.read_csv(sys_arg[1])

nx = np.array(input_data['h1'], dtype=int)
nz = np.array(input_data['h2'], dtype=int)

nodes = np.array([nx, nz]).T

cl = 0.05

for node in nodes:
    x = node[0]
    z = node[1]

    file1 = 'voa_beck_gen' + str(x) + '_' + str(z) + '_out.csv'
    file2 = 'voa_beck_gen_restart' + str(x) + '_' + str(z) + '_out.csv'
    output_file = 'voa_beck_gen_combined' + str(x) + '_' + str(z) + '_out.csv'

    df1 = pd.read_csv(file1)
    df2 = pd.read_csv(file2)

    result = df1.append(df2)

    result.to_csv(output_file, index=False)
    print(output_file, 'done!')

print('join_csv: All done!')
