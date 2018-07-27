import numpy as np
import sympy as sp
import matplotlib.pyplot as plt
import pandas as pd
import subprocess
import sys
from itertools import product

sys_arg = np.array(sys.argv)

x = sp.Symbol('x', real=True)
y = sp.Symbol('y', real=True)
z = sp.Symbol('z', real=True)
h1,h2 = sp.symbols('h1 h2', real=True, nonzero=True)
m,n = sp.symbols('m n', real=True)
T_n = sp.Symbol('T_n', real = True)
T_n2 = sp.Symbol('T_n2', real = True)
T_f = T_n*sp.sin(sp.pi*y)*sp.cos(m*sp.pi*x/h1)*sp.cos(n*sp.pi*z/h2) + 1-y
T_2 = T_n2*sp.sin(sp.pi*y)*sp.cos(m*sp.pi*x/h1)*sp.cos(n*sp.pi*z/h2)

def amplitude_test_2modes(m_val, n_val, h1_val, h2_val, Ra, T0):
    entropy_bound = 9.0/256*Ra
    print(entropy_bound)
    T0 = np.array(T0)

    #Test_space, 0 to 120% of the initial amplitude
    a0 = np.linspace(0.0*T0[0], 1.2*T0[0], 50)
    a1 = np.linspace(0.0*T0[1], 1.2*T0[1], 50)

    a00, a11 = np.meshgrid(a0, a1)
    T11 = np.zeros_like(a00)

    #Find an amplitude of temperature that is the closest to the amplitude bound
    #while(EP.evalf(subs = {h1: h1_val, h2: h2_val, m: m_val, n: n_val, T_n: T0}) > entropy_bound):
    #    T0 -= 0.1

    #Temperature superposition
    T_sp = T_f.subs([(m, m_val[0]), (n, n_val[0])])
    T_sp+= T_2.subs([(m, m_val[1]), (n, n_val[1])])

    EP2 = sp.integrate(sp.integrate(sp.integrate(sp.diff(T_sp,x)**2 + sp.diff(T_sp,y)**2 + sp.diff(T_sp,z)**2, (x,0,h1)),(y,0,1)),(z,0,h2))/(h1*h2)

    for i in range(50):
        for j in range(50):
            T11[i][j] = EP2.evalf(subs = {h1: h1_val, h2: h2_val, T_n: a0[i], T_n2: a1[j]})

    #plt.figure(figsize=(8,8))
    CS = plt.contour(a00, a11, T11, levels = [entropy_bound])
    dat0= CS.allsegs[0][0]
    #print(dat0[:,0])
    #plt.scatter(dat0[:,0],dat0[:,1], c='r')
    return np.array([dat0[:,0], dat0[:,1]])

m_val = [0,1]
n_val = [1,1]
h1_val = 1.5
h2_val = 1.0
Ra = 42.25
counter = 0

amplitude = amplitude_test_2modes(m_val, n_val, h1_val, h2_val, Ra, [0.3, 0.4])

denom0 = 1.0/(m_val[0]**2/h1_val**2+n_val[0]**2/h2_val**2+1.0)
denom1 = 1.0/(m_val[1]**2/h1_val**2+n_val[1]**2/h2_val**2+1.0)

for a in amplitude.T:
    T_init = 'value =' + "'" + str(a[0]) + '*sin(pi*y)*cos(' + str(m_val[0]) + '*pi*x/' + str(h1_val) + ')*cos(' + str(n_val[0]) + '*pi*z/' + str(h2_val) + ') + '
    u_init = 'value =' + "'" + str(-a[0]*Ra**0.5*m_val[0]/h1_val*denom0) + '*cos(pi*y)*sin(' + str(m_val[0]) + '*pi*x/' + str(h1_val) + ')*cos(' + str(n_val[0]) + '*pi*z/' + str(h2_val) + ') + '
    v_init = 'value =' + "'" + str( a[0]*Ra**0.5*(m_val[0]**2/h1_val**2+n_val[0]**2/h2_val**2)*denom0) + '*sin(pi*y)*cos(' + str(m_val[0]) + '*pi*x/' + str(h1_val) + ')*cos(' + str(n_val[0]) + '*pi*z/' + str(h2_val) + ') + '
    w_init = 'value =' + "'" + str(-a[0]*Ra**0.5*n_val[0]/h2_val*denom0) + '*cos(pi*y)*cos(' + str(m_val[0]) + '*pi*x/' + str(h1_val) + ')*sin(' + str(n_val[0]) + '*pi*z/' + str(h2_val) + ') + '

    T_init+= str(a[1]) + '*sin(pi*y)*cos(' + str(m_val[1]) + '*pi*x/' + str(h1_val) + ')*cos(' + str(n_val[1]) + '*pi*z/' + str(h2_val) + ') + 1.0-y' + "'" + '\n'
    u_init+= str(-a[1]*Ra**0.5*m_val[1]/h1_val*denom1) + '*cos(pi*y)*sin(' + str(m_val[1]) + '*pi*x/' + str(h1_val) + ')*cos(' + str(n_val[1]) + '*pi*z/' + str(h2_val) + ')' + "'" + '\n'
    v_init+= str( a[1]*Ra**0.5*(m_val[1]**2/h1_val**2+n_val[1]**2/h2_val**2)*denom1) + '*sin(pi*y)*cos(' + str(m_val[1]) + '*pi*x/' + str(h1_val) + ')*cos(' + str(n_val[1]) + '*pi*z/' + str(h2_val) + ')' + "'" + '\n'
    w_init+= str(-a[1]*Ra**0.5*n_val[1]/h2_val*denom1) + '*cos(pi*y)*cos(' + str(m_val[1]) + '*pi*x/' + str(h1_val) + ')*sin(' + str(n_val[1]) + '*pi*z/' + str(h2_val) + ')' + "'" + '\n'

    f = open("voa_florio_long.i", "r")
    contents = f.readlines()
    f.close()

    contents.insert(60, T_init)
    contents.insert(66, u_init)
    contents.insert(72, v_init)
    contents.insert(78, w_init)

    file_to_write = "voa_florio_long_" + str(counter) + '.i'
    counter += 1

    f = open(file_to_write, "w")
    contents = "".join(contents)
    f.write(contents)
    f.close()
    print('File write complete!    ' + file_to_write)

    #cmd = "srun -n 48 $BEAGLE_DIR/beagle-opt -i " + file_to_write
    #returned_value = subprocess.call(cmd, shell=True)
