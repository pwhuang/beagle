import numpy as np
import matplotlib.pyplot as plt
import matplotlib.image as mpimg
import matplotlib as mpl
import netCDF4
import sys
import pandas as pd

sys_arg = np.array(sys.argv)
f = []
lg = []
plt.figure()

for i, file in enumerate(sys_arg[1:]): 
    f.append(pd.read_csv(file))
    lg.append(file)
    plt.plot(f[i]['time'], f[i]['N_S'])


plt.title('Entropy Production')
plt.legend(lg)
plt.show()

plt.figure()
for i in len(sys_arg[1:]):
    plt.plot(f[i]['time'], f[i]['max_CFL'])
    
plt.title('Max CFL Number')
plt.legend(lg)
plt.show()

plt.figure()
for i in len(sys_arg[1:]):
    plt.plot(f[i]['time'], f[i]['max_Peclet'])

plt.title('Max Peclet Number')
plt.legend(lg)
plt.show()