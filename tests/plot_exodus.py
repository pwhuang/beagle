#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Thu Nov 30 16:29:31 2017

@author: huang
"""

import numpy as np
#from matplotlib.patches import Polygon
#from matplotlib.collections import PatchCollection
import matplotlib.pyplot as plt
import netCDF4
import sys


#sys_arg = np.array(sys.argv)
#nc = netCDF4.Dataset(sys_arg[1])

nc = netCDF4.Dataset('darcy_stream_elder_out.e')

#print(nc.variables)

x = nc.variables['coordx'][:]
y = nc.variables['coordy'][:]
connect = nc.variables['connect1'][:]

stream = nc.variables['vals_nod_var1'][:]
temp = nc.variables['vals_nod_var2'][:]
vel_x = nc.variables['vals_nod_var3'][:]
vel_y = nc.variables['vals_nod_var4'][:]


plt.figure(figsize=(20,5))
plt.axes(aspect=1)
#plt.scatter(x, y, c=temp[200], s=2, cmap='coolwarm')
    plt.tricontourf(x, y, temp[200], 11, cmap='coolwarm')
#plt.tricontour(x, y, temp[200], 11, cmap='coolwarm')
plt.colorbar()

#plt.xlim(0,4)
#plt.ylim(0,1)

plt.title('Temperature (-)')
plt.xlabel('x (-)')
plt.ylabel('y (-)')
plt.tight_layout(pad = 4.0)
plt.show()