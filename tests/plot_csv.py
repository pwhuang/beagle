#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Mon Nov 27 18:15:33 2017

@author: huang
"""

import numpy as np
import matplotlib.pyplot as plt
import pandas as pd
import sys

print(sys.argv)

sys_arg = np.array(sys.argv)

data = pd.read_csv(sys_arg[1])

#print(data)

x = data[sys_arg[2]]

for i, arg in enumerate(sys_arg[3:]):
    plt.subplot(220+i+1)
    plt.plot(x, data[arg])
    plt.xlabel(sys_arg[2])
    plt.ylabel(arg)
    
plt.tight_layout()    
plt.show()