import numpy as np
import matplotlib.pyplot as plt
import matplotlib.image as mpimg
import matplotlib as mpl
from matplotlib.tri import Triangulation, TriAnalyzer, UniformTriRefiner
from math import ceil
from math import floor
import pandas as pd
import netCDF4
import sys
from datetime import datetime
from itertools import product
import os

from scipy.interpolate import griddata


def elder_compare(input_file, variable, output_file, mesh_node, dt):
    time_to_plot = [0.01, 0.025, 0.05]
    found_time = []
    dt = dt/2
    nc = netCDF4.Dataset(input_file)
    
    img1=mpimg.imread('Graf_Elder_t1.png')
    img2=mpimg.imread('Graf_Elder_t2.png')
    img3=mpimg.imread('Graf_Elder_t3.png')

    #print(nc.variables)

    time = nc.variables['time_whole']
    time = np.array(time)
    temp_interval = np.array([0.0,0.125,0.375,0.625,0.875,1.0])

    x = nc.variables['coordx'][:]
    y = nc.variables['coordy'][:]
    connect = nc.variables['connect1'][:]
    connect = connect - 1

    fig = plt.figure(figsize=(15,10))
    
    #vel_x = nc.variables['vals_nod_var2'][:]
    #vel_y = nc.variables['vals_nod_var3'][:]
    #stream = nc.variables['vals_nod_var1'][:]

    #time.index()

    x_len = len(img1[0])
    y_len = len(img1)
    plt_im1 = plt.subplot(321)
    plt_im1.set_xticks([0, x_len/4.0, x_len/2.0, x_len/4.0*3.0, x_len-1])
    plt_im1.set_xticklabels([0,150,300,450,600])
    plt_im1.set_yticks([0, y_len/3.0*2.0, y_len/3.0])
    plt_im1.set_yticklabels([150, 100, 50])
    #plt_im1.set_xlabel('x (m)')
    plt_im1.set_ylabel('y (m)')
    plt.imshow(img1)

    x_len = len(img2[0])
    y_len = len(img2)
    plt_im2 = plt.subplot(323)
    plt_im2.set_xticks([0, x_len/4.0, x_len/2.0, x_len/4.0*3.0, x_len-1])
    plt_im2.set_xticklabels([0,150,300,450,600])
    plt_im2.set_yticks([0, y_len/3.0*2.0, y_len/3.0])
    plt_im2.set_yticklabels([150, 100, 50])
    #plt_im2.set_xlabel('x (m)')
    plt_im2.set_ylabel('y (m)')
    plt.imshow(img2)

    x_len = len(img3[0])
    y_len = len(img3)
    plt_im3 = plt.subplot(325)
    plt_im3.set_xticks([0, x_len/4.0, x_len/2.0, x_len/4.0*3.0, x_len-1])
    plt_im3.set_xticklabels([0,150,300,450,600])
    plt_im3.set_yticks([0, y_len/3.0*2.0, y_len/3.0])
    plt_im3.set_yticklabels([150, 100, 50])
    plt_im3.set_xlabel('x (m)')
    plt_im3.set_ylabel('y (m)')
    plt.imshow(img3)


    for i, t in enumerate(time_to_plot):
        index = np.max(np.where(time<t+dt))
        found_time.append(time[index])
        temp = nc.variables[variable][index] 

        ax = plt.subplot(320+2*i+2, adjustable='box', aspect=1.851)
        
        ax.xaxis.set_major_locator(mpl.ticker.MultipleLocator(1.0))
        ax.yaxis.set_major_locator(mpl.ticker.MultipleLocator(1.0/3.0))
        
        #plt.scatter(x, y, c=temp[200], s=2, cmap='coolwarm')
        plt.tricontourf(x, y, temp, levels=temp_interval, colors=['1.0','0.8','0.5','0.25','0.0'])
        
        if mesh_node == 4:
            mesh_scatter(ax, x, y, connect, mesh_node)
        elif mesh_node == 3:
            ax.triplot(x, y, triangles = connect[:, :3], linewidth=0.2)
        
        if i==2:
            plt.xlabel('x (-)')
        plt.ylabel('y (-)')

    cbaxes1 = fig.add_axes([0.6, 0.05, 0.25, 0.01]) #left, bottom, width, height
    cbaxes2 = fig.add_axes([0.175, 0.05, 0.25, 0.01])
    cb1 = plt.colorbar(cax = cbaxes1, orientation='horizontal', spacing='proportional')
    cb2 = plt.colorbar(cax = cbaxes2, orientation='horizontal', spacing='proportional')

    cb1.set_ticklabels([0.0,0.125,0.375,0.625,0.875,1.0])
    cb1.set_label('Temperature (-)')

    cb2.set_ticklabels([12,13,15,17,19,20])
    cb2.set_label('Temperature (C)')

    #plt.tight_layout(pad = 1.0)
    print(input_file)
    print('Founded time = ', found_time)
    #plt.tight_layout()
    fig.subplots_adjust(hspace=0.2)
    fig.savefig(output_file, transparent=True, bbox_inches='tight', pad_inches=0.1)
    plt.show()
    
def elder_compare_adaptive(input_file, variable, output_file, mesh_node, dt):
    img1=mpimg.imread('Graf_Elder_t1.png')
    img2=mpimg.imread('Graf_Elder_t2.png')
    img3=mpimg.imread('Graf_Elder_t3.png')
    
    fig = plt.figure(figsize=(15,10))
    
    time_to_plot = [0.01, 0.025, 0.05]
    found_time = []
    dt = dt/2
    
    x_len = len(img1[0])
    y_len = len(img1)
    plt_im1 = plt.subplot(321)
    plt_im1.set_xticks([0, x_len/4.0, x_len/2.0, x_len/4.0*3.0, x_len-1])
    plt_im1.set_xticklabels([0,150,300,450,600])
    plt_im1.set_yticks([0, y_len/3.0*2.0, y_len/3.0])
    plt_im1.set_yticklabels([150, 100, 50])
    #plt_im1.set_xlabel('x (m)')
    plt_im1.set_ylabel('y (m)')
    plt.imshow(img1)

    x_len = len(img2[0])
    y_len = len(img2)
    plt_im2 = plt.subplot(323)
    plt_im2.set_xticks([0, x_len/4.0, x_len/2.0, x_len/4.0*3.0, x_len-1])
    plt_im2.set_xticklabels([0,150,300,450,600])
    plt_im2.set_yticks([0, y_len/3.0*2.0, y_len/3.0])
    plt_im2.set_yticklabels([150, 100, 50])
    #plt_im2.set_xlabel('x (m)')
    plt_im2.set_ylabel('y (m)')
    plt.imshow(img2)

    x_len = len(img3[0])
    y_len = len(img3)
    plt_im3 = plt.subplot(325)
    plt_im3.set_xticks([0, x_len/4.0, x_len/2.0, x_len/4.0*3.0, x_len-1])
    plt_im3.set_xticklabels([0,150,300,450,600])
    plt_im3.set_yticks([0, y_len/3.0*2.0, y_len/3.0])
    plt_im3.set_yticklabels([150, 100, 50])
    plt_im3.set_xlabel('x (m)')
    plt_im3.set_ylabel('y (m)')
    plt.imshow(img3)
    
    
    temp_interval = np.array([0.0,0.125,0.375,0.625,0.875,1.0])
    
    for i, t in enumerate(time_to_plot):
        nc = netCDF4.Dataset(input_file[i])
        x = nc.variables['coordx'][:]
        y = nc.variables['coordy'][:]
        connect = nc.variables['connect1'][:]
        connect = connect - 1
        time = nc.variables['time_whole']
        time = np.array(time)
    
        index = np.max(np.where(time<t+dt))
        found_time.append(time[index])
        temp = nc.variables[variable][index] 

        ax = plt.subplot(320+2*i+2, adjustable='box', aspect=1.851)
        ax.xaxis.set_major_locator(mpl.ticker.MultipleLocator(1.0))
        ax.yaxis.set_major_locator(mpl.ticker.MultipleLocator(1.0/3.0))

        #plt.scatter(x, y, c=temp[200], s=2, cmap='coolwarm')
        plt.tricontourf(x, y, temp, levels=temp_interval, colors=['1.0','0.8','0.5','0.25','0.0'])
        
        if mesh_node == 4:
            mesh_scatter(ax, x, y, connect, mesh_node)
        elif mesh_node == 3:
            ax.triplot(x, y, triangles = connect[:,:3], linewidth=0.1)
            
        if i==2:
            plt.xlabel('x (-)')
        plt.ylabel('y (-)')

    cbaxes1 = fig.add_axes([0.6, 0.05, 0.25, 0.01]) #left, bottom, width, height
    cbaxes2 = fig.add_axes([0.175, 0.05, 0.25, 0.01])
    cb1 = plt.colorbar(cax = cbaxes1, orientation='horizontal', spacing='proportional')
    cb2 = plt.colorbar(cax = cbaxes2, orientation='horizontal', spacing='proportional')

    cb1.set_ticklabels([0.0,0.125,0.375,0.625,0.875,1.0])
    cb1.set_label('Temperature (-)')

    cb2.set_ticklabels([12,13,15,17,19,20])
    cb2.set_label('Temperature (C)')

    #plt.tight_layout(pad = 1.0)
    
    print(input_file)
    print('Founded time = ', found_time)
    
    #fig.subplots_adjust(hspace=0.4)
    fig.savefig(output_file, transparent=True, bbox_inches='tight', pad_inches=0.1)
    plt.show()

def elder_compare1(input_file, variable, output_file, mesh_node, dt):
    time_to_plot = [0.01]
    found_time = []
    dt = dt/2
    nc = netCDF4.Dataset(input_file)
    
    img1=mpimg.imread('Graf_Elder_t1.png')
    
    #print(nc.variables)

    time = nc.variables['time_whole']
    time = np.array(time)
    temp_interval = np.array([0.0,0.125,0.375,0.625,0.875,1.0])

    x = nc.variables['coordx'][:]
    y = nc.variables['coordy'][:]
    connect = nc.variables['connect1'][:]
    connect = connect - 1

    fig = plt.figure(figsize=(15,5))
    
    #vel_x = nc.variables['vals_nod_var2'][:]
    #vel_y = nc.variables['vals_nod_var3'][:]
    #stream = nc.variables['vals_nod_var1'][:]

    #time.index()

    x_len = len(img1[0])
    y_len = len(img1)
    plt_im1 = plt.subplot(121)
    plt_im1.set_xticks([0, x_len/4.0, x_len/2.0, x_len/4.0*3.0, x_len-1])
    plt_im1.set_xticklabels([0,150,300,450,600])
    plt_im1.set_yticks([0, y_len/3.0*2.0, y_len/3.0])
    plt_im1.set_yticklabels([150, 100, 50])
    plt_im1.set_xlabel('x (m)')
    plt_im1.set_ylabel('y (m)')
    plt.imshow(img1)


    for i, t in enumerate(time_to_plot):
        index = np.max(np.where(time<t+dt))
        found_time.append(time[index])
        temp = nc.variables[variable][index] 

        ax = plt.subplot(120+2*i+2, adjustable='box', aspect=1.851)
        
        ax.xaxis.set_major_locator(mpl.ticker.MultipleLocator(1.0))
        ax.yaxis.set_major_locator(mpl.ticker.MultipleLocator(1.0/3.0))
        
        #plt.scatter(x, y, c=temp[200], s=2, cmap='coolwarm')
        plt.tricontourf(x, y, temp, levels=temp_interval, colors=['1.0','0.8','0.5','0.25','0.0'])

        #plt.grid(ls='--', markevery=1)
        if mesh_node == 4:
            mesh_scatter(ax, x, y, connect, mesh_node)
        elif mesh_node == 3:
            ax.triplot(x, y, triangles = connect[:, :3], linewidth=0.2)
        
        plt.xlabel('x (-)')
        plt.ylabel('y (-)')

    cbaxes1 = fig.add_axes([0.6, 0.15, 0.25, 0.01]) #left, bottom, width, height
    cbaxes2 = fig.add_axes([0.175, 0.15, 0.25, 0.01])
    cb1 = plt.colorbar(cax = cbaxes1, orientation='horizontal', spacing='proportional')
    cb2 = plt.colorbar(cax = cbaxes2, orientation='horizontal', spacing='proportional')

    cb1.set_ticklabels([0.0,0.125,0.375,0.625,0.875,1.0])
    cb1.set_label('Temperature (-)')

    cb2.set_ticklabels([12,13,15,17,19,20])
    cb2.set_label('Temperature (C)')

    #plt.tight_layout(pad = 1.0)
    print(input_file)
    print('Founded time = ', found_time)
    #plt.tight_layout()
    #fig.subplots_adjust(hspace=0.4)
    fig.savefig(output_file, transparent=True, bbox_inches='tight', pad_inches=0.1)
    plt.show()
    
def entropy_compare(input_file, variable, ax, mesh_node, time_to_plot, dt):
    dt = dt/2
    nc = netCDF4.Dataset(input_file)
    
    found_time = []
    time = nc.variables['time_whole']
    time = np.array(time)
    temp_interval = np.array([0.0,0.125,0.375,0.625,0.875,1.0])

    x = nc.variables['coordx'][:]
    y = nc.variables['coordy'][:]
    connect = nc.variables['connect1'][:]
    connect = connect - 1

    fig = plt.figure(figsize=(15,10))
    
    for i, t in enumerate(time_to_plot):
        index = np.max(np.where(time<t+dt))
        temp = nc.variables[variable][index] 
        found_time.append(time[index])
    
        #ax = plt.subplot(320+2*i+2, adjustable='box', aspect=1.851)
        
        #plt.scatter(x, y, c=temp[200], s=2, cmap='coolwarm')
        mapobj = ax[i].tricontourf(x, y, temp, levels=temp_interval, colors=['1.0','0.8','0.5','0.25','0.0'])
        #plt.tricontour(x, y, temp[200], 11, cmap='coolwarm')
        #plt.colorbar()

        #plt.xlim(0,4)
        #plt.ylim(0,1)

        #plt.title('Temperature (-)')
        #plt.grid(ls='--', markevery=1)
        if mesh_node == 4:
            mesh_scatter(ax[i], x, y, connect, mesh_node)
        elif mesh_node == 3:
            ax[i].triplot(x, y, triangles = connect[:, :3], linewidth=0.1)
    
    print(input_file)
    print('Founded time = ', found_time)
    return found_time, mapobj
    '''
        if i==2:
            plt.xlabel('x (-)')
        plt.ylabel('y (-)')
        
    
    cbaxes1 = fig.add_axes([0.6, 0.05, 0.25, 0.01]) #left, bottom, width, height
    cbaxes2 = fig.add_axes([0.175, 0.05, 0.25, 0.01])
    cb1 = plt.colorbar(cax = cbaxes1, orientation='horizontal', spacing='proportional')
    cb2 = plt.colorbar(cax = cbaxes2, orientation='horizontal', spacing='proportional')

    cb1.set_ticklabels([0.0,0.125,0.375,0.625,0.875,1.0])
    cb1.set_label('Temperature (-)')

    cb2.set_ticklabels([12,13,15,17,19,20])
    cb2.set_label('Temperature (C)')

    #plt.tight_layout(pad = 1.0)
    '''
    #plt.savefig(output_file)
    #plt.show()


def entropy_evolution(time_to_plot, dt, file1, file2, var1, var2, node1, node2, output_file):
    fig = plt.figure(figsize=(20,15))
    ax_top = []
    ax_bot = []
    #Top row
    ax_top.append(plt.subplot2grid((5,4), (0,0))) 
    ax_top.append(plt.subplot2grid((5,4), (0,1)))
    ax_top.append(plt.subplot2grid((5,4), (0,2)))
    ax_top.append(plt.subplot2grid((5,4), (0,3)))
    #Bottom row
    ax_bot.append(plt.subplot2grid((5,4), (4,0)))
    ax_bot.append(plt.subplot2grid((5,4), (4,1)))
    ax_bot.append(plt.subplot2grid((5,4), (4,2)))
    ax_bot.append(plt.subplot2grid((5,4), (4,3)))
    #Middle row
    ax_mid = plt.subplot2grid((5,4), (1,0), colspan=4)
    ax_mid2 = plt.subplot2grid((5,4), (2,0), colspan=4)
    ax_mid3 = plt.subplot2grid((5,4), (3,0), colspan=4)
    
    
    f1 = pd.read_csv(file1 + '.csv')
    f2 = pd.read_csv(file2 + '.csv')
    
    ax_mid.plot(f1['time'], f1['N_S'], c='#1cad0f', linewidth=2)
    ax_mid.plot(f2['time'], f2['N_S'], c='#f22424', linewidth=2, ls='-.')
    #ax_mid.set_xlabel('Time (-)')
    ax_mid.set_ylabel('N_S (-)')
    
    ax_mid2.plot(f1['time'], f1['max_CFL'], c='#1cad0f', linewidth=2)
    ax_mid2.plot(f2['time'], f2['max_CFL'], c='#f22424', linewidth=2, ls='-.')
    
    #ax_mid2.set_xlabel('Time (-)')
    ax_mid2.set_ylabel('CFL (-)')
    
    ax_mid3.plot(f1['time'], f1['max_Peclet'], c='#1cad0f', linewidth=2)
    ax_mid3.plot(f2['time'], f2['max_Peclet'], c='#f22424', linewidth=2, ls='-.')
    
    ax_mid3.set_xlabel('Time (-)')
    ax_mid3.set_ylabel('Pe (-)')
    
    print(file1 + ' Maximum entropy: ', max(f1['N_S']))
    print(file2 + ' Maximum entropy: ', max(f2['N_S']))

    for t in time_to_plot:
        ax_mid.axvline(t, ls='--')
        ax_mid2.axvline(t, ls='--')
        ax_mid3.axvline(t, ls='--')

    ax_mid.set_ylim(0,10)
    #ax_mid.([file1, file2])
    #ax_mid2.legend([file1, file2])
    ax_mid3.legend([file1, file2])

    entropy_compare(file1+'.e', var1, ax_top, node1, time_to_plot, dt)
    entropy_compare(file2+'.e', var2, ax_bot, node2, time_to_plot, dt)
    
    plt.tight_layout()
    fig.subplots_adjust(hspace=0.4)
    fig.savefig(output_file, transparent=True, bbox_inches='tight', pad_inches=0.1)
    plt.show()

def beck_plot(csv_name, variable, plot_type, refinement, output_name):
    fig = plt.figure(figsize=(15,10))

    img1=mpimg.imread('beck.png')
    
    y_len = len(img1)
    img1=np.delete(img1, [0,1,2, y_len-1], 0) #Deleting rows

    x_len = len(img1[0])
    img1=np.delete(img1, [0,1,2, x_len-1, x_len-2, x_len-3, x_len-4], 1) #Deleting columns
    
    x_len = len(img1[0])
    y_len = len(img1)

    plt_im1 = plt.subplot(111)
    plt_im1.set_xticks(x_len*np.linspace(0,1,11))
    plt_im1.set_xticklabels(np.linspace(0,5,11), fontsize=14)
    plt_im1.set_yticks(y_len*np.linspace(0,1,8))
    plt_im1.set_yticklabels(np.linspace(0,3.5,8), fontsize=14)

    plt_im1.set_xlabel('$h_1 (-)$', fontsize=16)
    plt_im1.set_ylabel('$h_2 (-)$', fontsize=16, rotation=0, labelpad=30)
    plt.imshow(img1, origin='lower')

    data = pd.read_csv(csv_name)

    cl = 0.05
    nx = np.array(data['nx'])
    nz = np.array(data['nz'])
    N_S = np.array(data[variable])
    
    min_N_S = np.min(N_S)
    max_N_S = np.max(N_S)
    floor_N_S = floor(min_N_S*1000)/1000
    ceil_N_S  = ceil(max_N_S*1000)/1000
    
    x = nx*x_len*cl/5.0
    z = nz*y_len*cl/3.5
    
    triang = Triangulation(x, z)
    refiner = UniformTriRefiner(triang)
    #tri_refi = refiner.refine_triangulation(return_tri_index=False, subdiv=refinement)
    #interp_lin = mpl.tri.LinearTriInterpolator(triang, N_S)
    #interp_cubic = mpl.tri.CubicTriInterpolator(triang, N_S, kind='min_E', trifinder=None, dz=None)
    #N_S_refi = interp_lin(tri_refi)
    tri_refi, N_S_refi = refiner.refine_field(N_S, triinterpolator=None, subdiv=refinement)

    print(len(nx))
    
    if plot_type=='both':
        plt.tricontourf(tri_refi, N_S_refi, alpha=0.5)
        plt.scatter(x, z, c=N_S, cmap='viridis', vmin=floor_N_S, vmax=ceil_N_S)
        cb = plt.colorbar(fraction=0.046, pad=0.04, ticks=np.linspace(floor_N_S, ceil_N_S, 5))
    elif plot_type=='scatter':
        plt.scatter(x, z, c=N_S, cmap='viridis', vmin=floor_N_S, vmax=ceil_N_S)
        cb = plt.colorbar(fraction=0.046, pad=0.04, ticks=np.linspace(floor_N_S, ceil_N_S, 5))
    elif plot_type=='contour':
        plt.tricontourf(tri_refi, N_S_refi, alpha=0.5)
        cb = plt.colorbar(fraction=0.046, pad=0.04)
        
    cb.ax.tick_params(labelsize=14)
    cb.ax.set_title('$N_{\dot S}$ (-)\n', rotation=0, fontsize=16)
    fig.savefig(output_name, transparent=True, bbox_inches='tight', pad_inches=0.1)
    plt.show()
    
def beck_3d_plot(csv_name, variable, surface):
    data = pd.read_csv(csv_name)

    cl = 0.05
    nx = np.array(data['nx'])
    nz = np.array(data['nz'])
    N_S = np.array(data[variable])
    
    cell_x = np.around(np.array(data['cell_x']))
    cell_z = np.around(np.array(data['cell_z']))

    x = cl*nx
    z = cl*nz
    
    total_cell = np.array([cell_x, cell_z], dtype=int).T
    cell_type = np.unique(total_cell, axis=0)
    cell_label = np.zeros(len(cell_x))
    

    lg_list = []
    #for ct in cell_type:
    #    lg_list.append(np.array2string(ct, separator=','))

    for j, ct in enumerate(cell_type):
        for i, cell in enumerate(total_cell):
            if np.array_equal(cell, ct):
                if ct[0]==0: #1d convetion in z dir
                    cell_label[i] = 3*j
                elif ct[1]==0: #1d convection in x dir
                    cell_label[i] = 3*j+1 
                else: #2d convection
                    cell_label[i] = 3*j+2
    
    c_label_unique = np.unique(cell_label)
    
    zdir_count = len(c_label_unique[c_label_unique%3==0])
    xdir_count = len(c_label_unique[c_label_unique%3==1])
    
    comp_xz_count = max([xdir_count, zdir_count])
    
    color_label_1d = np.linspace(0.5,1,comp_xz_count+1)
    color_label_2d = np.linspace(0,1,len(cell_type)-xdir_count-zdir_count)
    
    cl1_x = 0
    cl1_z = 0
    cl2   = 0
    
    #grid_temp = griddata(np.array([x_mid, z_mid]).T, temp_mid, (grid_x, grid_z), method='linear')
    
    fig = plt.figure()
    ax = fig.add_subplot(111, projection='3d')
    
    for j, i in enumerate(c_label_unique): 
        if i%3==0:
            plt.scatter(x[cell_label==i], N_S[cell_label==i], color=plt.cm.Greens(color_label_1d[cl1_z]))
            cl1_z += 1
            cell_string = np.array2string(cell_type[j], separator=',')
            cell_string = cell_string.replace('[', '(')
            cell_string = cell_string.replace(']', ')')
            lg_list.append(cell_string)
    for j, i in enumerate(c_label_unique):
        if i%3==1:
            plt.scatter(x[cell_label==i], N_S[cell_label==i], color=plt.cm.Blues(color_label_1d[cl1_x]))
            cl1_x += 1
            cell_string = np.array2string(cell_type[j], separator=',')
            cell_string = cell_string.replace('[', '(')
            cell_string = cell_string.replace(']', ')')
            lg_list.append(cell_string)
    for j, i in enumerate(c_label_unique):
        if i%3==2:
            plt.scatter(x[cell_label==i], N_S[cell_label==i], color=plt.cm.autumn(color_label_2d[cl2]))
            cl2 += 1
            cell_string = np.array2string(cell_type[j], separator=',')
            cell_string = cell_string.replace('[', '(')
            cell_string = cell_string.replace(']', ')')
            lg_list.append(cell_string)
    
    cell_label = cell_label/np.max(cell_label)
    
    if surface==True:
        ax.plot_wireframe(x, z, N_S)
    
    ax.set_xlabel('$h_1 (-)$')
    ax.set_ylabel('$h_2 (-)$')
    ax.set_zlabel(variable)
    ax.legend(lg_list)
    plt.show()

def beck_cell_plot(csv_name, output_name, extend_x, extend_y):
    fig = plt.figure(figsize=(15,10))

    img1=mpimg.imread('beck.png')
    
    y_len = len(img1)
    img1=np.delete(img1, [0,1,2, y_len-1], 0) #Deleting rows

    x_len = len(img1[0])
    img1=np.delete(img1, [0,1,2, x_len-1, x_len-2, x_len-3, x_len-4], 1) #Deleting columns
    
    x_len = len(img1[0])
    y_len = len(img1)

    plt_im1 = plt.subplot(111)
    plt_im1.set_xticks(x_len*np.linspace(0,1,11))
    plt_im1.set_xticklabels(np.linspace(0,5,11), fontsize=14)
    plt_im1.set_yticks(y_len*np.linspace(0,1,8))
    plt_im1.set_yticklabels(np.linspace(0,3.5,8), fontsize=14)

    plt_im1.set_xlabel('$h_1 (-)$', fontsize=16)
    plt_im1.set_ylabel('$h_2 (-)$', fontsize=16, rotation=0, labelpad=30)
    plt.imshow(img1, origin='lower')
    
    beck_cell_plot_ax(plt_im1, csv_name, x_len/5.0, y_len/3.5, True)
    
    fig.savefig(output_name, transparent=True, bbox_inches='tight', pad_inches=0.1)
    plt.show()

def beck_cell_plot_ax(ax, csv_name, x_len, y_len, plot_legend):
    data = pd.read_csv(csv_name)

    cl = 0.05
    nx = np.array(data['nx'])
    nz = np.array(data['nz'])
    cell_x = np.around(np.array(data['cell_x']))
    cell_z = np.around(np.array(data['cell_z']))

    total_cell = np.array([cell_x, cell_z], dtype=int).T
    cell_type = np.unique(total_cell, axis=0)
    cell_label = np.zeros(len(cell_x))


    lg_list = []
    #for ct in cell_type:
    #    lg_list.append(np.array2string(ct, separator=','))

    for j, ct in enumerate(cell_type):
        for i, cell in enumerate(total_cell):
            if np.array_equal(cell, ct):
                if ct[0]==0: #1d convetion in z dir
                    cell_label[i] = 3*j
                elif ct[1]==0: #1d convection in x dir
                    cell_label[i] = 3*j+1 
                else: #2d convection
                    cell_label[i] = 3*j+2
    
    c_label_unique = np.unique(cell_label)
    
    zdir_count = len(c_label_unique[c_label_unique%3==0])
    xdir_count = len(c_label_unique[c_label_unique%3==1])
    
    comp_xz_count = max([xdir_count, zdir_count])
    
    color_label_1d = np.linspace(0.5,1,comp_xz_count+1)
    color_label_2d = np.linspace(0,1,len(cell_type)-xdir_count-zdir_count)
    
    cl1_x = 0
    cl1_z = 0
    cl2   = 0

    N_S = np.array(data['N_S'])
    N_Sfixed = N_S/max(N_S)
    N_Sfixed = N_Sfixed*N_Sfixed*100
    
    x = nx*x_len*cl
    z = nz*y_len*cl

    print(len(nx))

    for j, i in enumerate(c_label_unique): 
        if i%3==0:
            ax.scatter(x[cell_label==i], z[cell_label==i], color=plt.cm.Greens(color_label_1d[cl1_z]), zorder=2)
            cl1_z += 1
            cell_string = np.array2string(cell_type[j], separator=',')
            cell_string = cell_string.replace('[', '(')
            cell_string = cell_string.replace(']', ')')
            lg_list.append(cell_string)
    for j, i in enumerate(c_label_unique):
        if i%3==1:
            ax.scatter(x[cell_label==i], z[cell_label==i], color=plt.cm.Blues(color_label_1d[cl1_x]), zorder=2)
            cl1_x += 1
            cell_string = np.array2string(cell_type[j], separator=',')
            cell_string = cell_string.replace('[', '(')
            cell_string = cell_string.replace(']', ')')
            lg_list.append(cell_string)
    for j, i in enumerate(c_label_unique):
        if i%3==2:
            ax.scatter(x[cell_label==i], z[cell_label==i], color=plt.cm.autumn(color_label_2d[cl2]), zorder=2)
            cl2 += 1
            cell_string = np.array2string(cell_type[j], separator=',')
            cell_string = cell_string.replace('[', '(')
            cell_string = cell_string.replace(']', ')')
            lg_list.append(cell_string)
    
    if plot_legend==True:
        ax.legend(lg_list, fontsize=14)
    
    return lg_list
    
    
def beck_cell_plot_xdir(csv_name, output_name):
    data = pd.read_csv(csv_name)

    cl = 0.05
    nx = np.array(data['nx'])
    nz = np.array(data['nz'])
    N_S = np.array(data['N_S'])

    x = cl*nx

    cell_x = np.around(np.array(data['cell_x']))
    cell_z = np.around(np.array(data['cell_z']))

    total_cell = np.array([cell_x, cell_z], dtype=int).T
    cell_type = np.unique(total_cell, axis=0)
    cell_label = np.zeros(len(cell_x))

    lg_list = []
    #for ct in cell_type:
    #    lg_list.append(np.array2string(ct, separator=','))
    
    for j, ct in enumerate(cell_type):
        for i, cell in enumerate(total_cell):
            if np.array_equal(cell, ct):
                if ct[0]==0: #1d convetion in z dir
                    cell_label[i] = 3*j
                elif ct[1]==0: #1d convection in x dir
                    cell_label[i] = 3*j+1 
                else: #2d convection
                    cell_label[i] = 3*j+2
    
    c_label_unique = np.unique(cell_label)
    
    zdir_count = len(c_label_unique[c_label_unique%3==0])
    xdir_count = len(c_label_unique[c_label_unique%3==1])
    
    comp_xz_count = max([xdir_count, zdir_count])
    
    color_label_1d = np.linspace(0.5,1,comp_xz_count+1)
    color_label_2d = np.linspace(0,1,len(cell_type)-xdir_count-zdir_count)
    
    cl1_x = 0
    cl1_z = 0
    cl2   = 0
    
    fig = plt.figure(figsize=(10,5))
    plt.tick_params(labelsize=14)
    
    for j, i in enumerate(c_label_unique): 
        if i%3==0:
            plt.scatter(x[cell_label==i], N_S[cell_label==i], color=plt.cm.Greens(color_label_1d[cl1_z]))
            cl1_z += 1
            cell_string = np.array2string(cell_type[j], separator=',')
            cell_string = cell_string.replace('[', '(')
            cell_string = cell_string.replace(']', ')')
            lg_list.append(cell_string)
    for j, i in enumerate(c_label_unique):
        if i%3==1:
            plt.scatter(x[cell_label==i], N_S[cell_label==i], color=plt.cm.Blues(color_label_1d[cl1_x]))
            cl1_x += 1
            cell_string = np.array2string(cell_type[j], separator=',')
            cell_string = cell_string.replace('[', '(')
            cell_string = cell_string.replace(']', ')')
            lg_list.append(cell_string)
    for j, i in enumerate(c_label_unique):
        if i%3==2:
            plt.scatter(x[cell_label==i], N_S[cell_label==i], color=plt.cm.autumn(color_label_2d[cl2]))
            cl2 += 1
            cell_string = np.array2string(cell_type[j], separator=',')
            cell_string = cell_string.replace('[', '(')
            cell_string = cell_string.replace(']', ')')
            lg_list.append(cell_string)
        
    plt.legend(lg_list, loc='center left', bbox_to_anchor=(1, 0.5), fontsize=14)
    
    fig.savefig(output_name, transparent=True, bbox_inches='tight', pad_inches=0.1)
    plt.show()

def beck_plot_combined(csv_name, output_name, cspan):
    fig = plt.figure(figsize=(12,12))
    ax1 = plt.subplot2grid((3,100), (0,0), rowspan=2, colspan=100)
    ax2 = plt.subplot2grid((3,100), (2,0), colspan=cspan)

    img1=mpimg.imread('beck.png')
    
    y_len = len(img1)
    img1=np.delete(img1, [0,1,2, y_len-1], 0) #Deleting rows

    x_len = len(img1[0])
    img1=np.delete(img1, [0,1,2, x_len-1, x_len-2, x_len-3, x_len-4], 1) #Deleting columns

    x_len = len(img1[0])
    y_len = len(img1)
    
    ax1.set_xticks(x_len*np.linspace(0,1,11))
    ax1.set_xticklabels(np.linspace(0,5,11), fontsize=14)
    ax1.set_yticks(y_len*np.linspace(0,1,8))
    ax1.set_yticklabels(np.linspace(0,3.5,8), fontsize=14)

    ax1.set_xlabel('$h_1 (-)$', fontsize=16)
    ax1.set_ylabel('$h_2 (-)$', fontsize=16, rotation=0, labelpad=30)
    ax1.imshow(img1, origin='lower')

    beck_cell_plot_ax(ax1, csv_name, x_len/5.0, y_len/3.5, True)

    data = pd.read_csv(csv_name)

    cl = 0.05
    nx = np.array(data['nx'])
    nz = np.array(data['nz'])
    N_S = np.array(data['N_S'])

    x = cl*nx

    cell_x = np.around(np.array(data['cell_x']))
    cell_z = np.around(np.array(data['cell_z']))

    total_cell = np.array([cell_x, cell_z], dtype=int).T
    cell_type = np.unique(total_cell, axis=0)
    cell_label = np.zeros(len(cell_x))

    lg_list = []
    #for ct in cell_type:
    #    lg_list.append(np.array2string(ct, separator=','))

    for j, ct in enumerate(cell_type):
        for i, cell in enumerate(total_cell):
            if np.array_equal(cell, ct):
                if ct[0]==0: #1d convetion in z dir
                    cell_label[i] = 3*j
                elif ct[1]==0: #1d convection in x dir
                    cell_label[i] = 3*j+1 
                else: #2d convection
                    cell_label[i] = 3*j+2

    c_label_unique = np.unique(cell_label)

    zdir_count = len(c_label_unique[c_label_unique%3==0])
    xdir_count = len(c_label_unique[c_label_unique%3==1])

    comp_xz_count = max([xdir_count, zdir_count])

    color_label_1d = np.linspace(0.5,1,comp_xz_count+1)
    color_label_2d = np.linspace(0,1,len(cell_type)-xdir_count-zdir_count)

    cl1_x = 0
    cl1_z = 0
    cl2   = 0

    plt.tick_params(labelsize=14)

    for j, i in enumerate(c_label_unique): 
        if i%3==0:
            plt.scatter(x[cell_label==i], N_S[cell_label==i], color=plt.cm.Greens(color_label_1d[cl1_z]))
            cl1_z += 1
            cell_string = np.array2string(cell_type[j], separator=',')
            cell_string = cell_string.replace('[', '(')
            cell_string = cell_string.replace(']', ')')
            lg_list.append(cell_string)
    for j, i in enumerate(c_label_unique):
        if i%3==1:
            plt.scatter(x[cell_label==i], N_S[cell_label==i], color=plt.cm.Blues(color_label_1d[cl1_x]))
            cl1_x += 1
            cell_string = np.array2string(cell_type[j], separator=',')
            cell_string = cell_string.replace('[', '(')
            cell_string = cell_string.replace(']', ')')
            lg_list.append(cell_string)
    for j, i in enumerate(c_label_unique):
        if i%3==2:
            plt.scatter(x[cell_label==i], N_S[cell_label==i], color=plt.cm.autumn(color_label_2d[cl2]))
            cl2 += 1
            cell_string = np.array2string(cell_type[j], separator=',')
            cell_string = cell_string.replace('[', '(')
            cell_string = cell_string.replace(']', ')')
            lg_list.append(cell_string)

    #plt.legend(lg_list, loc='center left', bbox_to_anchor=(1, 0.5), fontsize=14)
    #plt.legend(lg_list, fontsize=14)
    plt.ylabel('$N_{\dot S} (-)$', rotation=0, labelpad=25, fontsize=16)
    plt.xlabel('$h_1 (-)$', fontsize=16)
    plt.xlim(0,5)
    plt.tight_layout()

    ax2.set_xticks(np.linspace(0,5.0,11))

    ax1.set_anchor('W')
    ax2.set_anchor('W')

    fig.savefig(output_name, transparent=True, bbox_inches='tight', pad_inches=0.1)
    plt.show()
    
def output_cells_to_csv(csv_name, exodus_file, csv_file, output_name, exclude):
    nodes = pd.read_csv(csv_name)
    node_x = np.array(nodes['h1'], dtype=int)
    node_z = np.array(nodes['h2'], dtype=int)

    total_node = np.array([node_x, node_z]).T
    
    #print(exclude)
    #exclude = [[25,15], [27,15], [26,15]]

    for exx, exz in exclude:
        index = np.nonzero(np.logical_and(total_node[:,0]==exx, total_node[:,1]==exz))[0][0]

        total_node = np.delete(total_node, index, 0)

    #date = 'feb19/'

    output_list = []

    for nx, nz in total_node:
        file_name = exodus_file + str(nx) + '_' + str(nz) + '_out'
        file_name_csv = csv_file + str(nx) + '_' + str(nz) + '_out'
        cell_x, cell_z = count_convection_cells(file_name + '.e', 'vals_nod_var1', 0.002, 1e-2)

        #get entropy production and Nusselt number
        data = pd.read_csv(file_name_csv+'.csv')
        N_S = np.array(data['N_S'])
        N_S = N_S[-1]

        Nu = np.array(data['Nusselt'])
        Nu = Nu[-1]


        output_list.append([nx, nz, cell_x, cell_z, N_S, Nu])
        if (Nu < 1.05):
            print(nx, nz, cell_x, cell_z, N_S, Nu)

    pd.DataFrame(output_list).to_csv(output_name, header=['nx', 'nz', 'cell_x', 'cell_z', 'N_S', 'Nu'], index=False)
    print(str(datetime.now()))
    print('output_cells_to_csv done!')

def output_cells_to_csv_picard(csv_name, exodus_file, csv_file, output_name, exclude, max_pair, Ra):
    nodes = pd.read_csv(csv_name)
    node_x = np.array(nodes['h1'], dtype=int)
    node_z = np.array(nodes['h2'], dtype=int)
    
    total_node = np.array([node_x, node_z]).T
    
    for exx, exz in exclude:
        index = np.nonzero(np.logical_and(total_node[:,0]==exx, total_node[:,1]==exz))[0][0]

        total_node = np.delete(total_node, index, 0)

    output_list = []

    for nx, nz in total_node:
        pairs = Beck_cell_predict(nx*0.05, nz*0.05, max_pair, Ra)
        for p in pairs:
            file_name = exodus_file + str(nx) + '_' + str(nz) + '_' + str(p[0]) + str(p[1]) + '_out'
            file_name_csv = csv_file + str(nx) + '_' + str(nz) + '_' + str(p[0]) + str(p[1]) + '_out'
            
            #print(file_name_csv)
            
            if os.path.isfile(file_name_csv+'.csv'):
                cell_x, cell_z = count_convection_cells(file_name + '.e', 'vals_nod_var1', 0.002, 1e-2)

                #get entropy production and Nusselt number
                data = pd.read_csv(file_name_csv+'.csv')
                N_S = np.array(data['N_S'])
                N_S = N_S[-1]

                Nu = np.array(data['Nusselt'])
                Nu = Nu[-1]

                output_list.append([nx, nz, cell_x, cell_z, N_S, Nu])
                if (Nu < 1.05):
                    print(nx, nz, cell_x, cell_z, N_S, Nu)
            else:
                continue

    pd.DataFrame(output_list).to_csv(output_name, header=['nx', 'nz', 'cell_x', 'cell_z', 'N_S', 'Nu'], index=False)
    print(str(datetime.now()))
    print('output_cells_to_csv done!')
    
def output_cells_to_csv_ranu(csv_name, exodus_file, csv_file, output_name, exclude):
    csv_data = pd.read_csv(csv_name)
    total_ra = np.array(csv_data['Ra'], dtype=str)

    for exx, exz in exclude:
        index = np.nonzero(np.logical_and(total_node[:,0]==exx, total_node[:,1]==exz))[0][0]

        total_node = np.delete(total_node, index, 0)

    #date = 'feb19/'

    output_list = []

    for ra in total_ra:
        file_name = exodus_file + '_' + ra + '_final'
        file_name_csv = exodus_file + '_' + ra + '_out'
        cell_x, cell_z = count_convection_cells(file_name + '.e', 'vals_nod_var1', 0.002, 1e-2)

        #get entropy production and Nusselt number
        data = pd.read_csv(file_name_csv+'.csv')
        N_S = np.array(data['N_S'])
        N_S = N_S[-1]

        Nu = np.array(data['Nusselt'])
        Nu = Nu[-1]


        output_list.append([ra, cell_x, cell_z, N_S, Nu])
        if (Nu < 1.05):
            print(ra, cell_x, cell_z, N_S, Nu)

    pd.DataFrame(output_list).to_csv(output_name, header=['Ra', 'cell_x', 'cell_z', 'N_S', 'Nu'], index=False)
    print(str(datetime.now()))
    print('output_cells_to_csv done!')
    
def convergence_test(input_file, variable, ax_object):
    solution_file = 'feb13/pressure_elder_gen11_sol_out.e'
    nc_sol = netCDF4.Dataset(solution_file)

    sol_x = nc_sol.variables['coordx'][:]
    sol_y = nc_sol.variables['coordy'][:]
    sol_temp = nc_sol.variables['vals_nod_var2'][-1]
    
    delta_h = [1.0/16, 1.0/32, 1.0/64, 1.0/128]
    
    for file_list in input_file:
        norm = []
        for file in file_list:
            nc = netCDF4.Dataset(file)
            x = nc.variables['coordx'][:]
            y = nc.variables['coordy'][:]
            temp = nc.variables[variable][-1] 

            temp_interpolated = griddata(np.array([sol_x, sol_y]).T, sol_temp, (x, y), method='linear')

            norm.append(np.linalg.norm(temp-temp_interpolated, 2)) #2-norm

        ax_object.plot(delta_h, norm, marker='o')

def count_convection_cells(input_file, variable, cl, threshold):
    nc = netCDF4.Dataset(input_file)

    x = nc.variables['coordx'][:]
    y = nc.variables['coordy'][:]
    z = nc.variables['coordz'][:]

    temp = nc.variables[variable][-1] 

    #index = np.where(y==0.5)
    
    index = np.intersect1d(np.where(y <= 0.5+threshold)[0],np.where(y >= 0.5-threshold)[0])
    
    temp_mid = temp[index]
    x_mid = x[index]
    z_mid = z[index]

    x_max = np.max(x_mid)
    z_max = np.max(z_mid)

    grid_x, grid_z = np.meshgrid(np.arange(0,x_max,cl), np.arange(0,z_max,cl))
    grid_temp = griddata(np.array([x_mid, z_mid]).T, temp_mid, (grid_x, grid_z), method='linear')

    grid_temp[grid_temp>=0.5] = 1
    grid_temp[grid_temp< 0.5] = 0
    
    #x-direction
    total_count_x = 0
    for row in grid_temp:
        total_count_x += np.count_nonzero(np.diff(row))

    cell_x = total_count_x/len(grid_temp)

    #z-direction
    total_count_z = 0
    for row in grid_temp.T:
        total_count_z += np.count_nonzero(np.diff(row))

    cell_z = total_count_z/len(grid_temp.T)

    return cell_x, cell_z

def convergence_checker(csv_name, exodus_name, output_name, epsilon):
    nodes = pd.read_csv(csv_name)
    node_x = np.array(nodes['h1'], dtype=int)
    node_z = np.array(nodes['h2'], dtype=int)

    total_node = np.array([node_x, node_z]).T

    b = [] #for plotting
    b_name = []
    output_list = []

    for nx, nz in total_node:
        #get entropy production
        file_name = exodus_name + str(nx) + '_' + str(nz) + '_out'
        data = pd.read_csv(file_name+'.csv')
        N_S = np.array(data['N_S'])
        time = np.array(data['time'])
        
        dN_S = np.diff(N_S)
        dt = np.diff(time)

        dN_S_dt = dN_S/dt
        last_dN_S = dN_S_dt[-20:]
        
        #print(np.sum(last_dN_S))
        
        max_dN_S = np.max(dN_S)
        
        index = np.argmax(dN_S)
        
        if index!=len(dN_S)-1: 
            diff_max = dN_S[np.argmax(dN_S)+1]-max_dN_S
        else:
            diff_max = 1.0 #if it is the last index, it does not pass convergence test
        
        
        #if the gradients are not smooth enough, (but how smooth is smooth?)
        #of if the 
        #the problem does not converge.
        
        if np.abs(np.sum(last_dN_S))>epsilon or diff_max>0: # or max(N_S[100:])==N_S[-1]:
            print(file_name)
            b_name.append(file_name)
            b.append(pd.read_csv(file_name + '.csv'))
            output_list.append([nx, nz])
            
    if len(output_list)!=0:
        pd.DataFrame(output_list).to_csv(output_name, header=['h1', 'h2'], index=False)
        print('Output possibly not converged nodes to csv done!')
        print('Count: ', len(output_list))

    for i in range(len(b)):
        fig = plt.figure(figsize=(12,4))
        plt.subplot(121)
        plt.plot(b[i]['time'], b[i]['N_S'])
        plt.scatter(b[i]['time'][np.argmax(b[i]['N_S'][100:])], max(b[i]['N_S'][100:]), c='r')
        plt.title(b_name[i])
        
        plt.subplot(122)
        nc = netCDF4.Dataset(b_name[i] + '.e')

        x = nc.variables['coordx'][:]
        y = nc.variables['coordy'][:]
        z = nc.variables['coordz'][:]

        temp = nc.variables['vals_nod_var1'][-1]
        
        cell_x, cell_z = count_convection_cells(b_name[i] + '.e', 'vals_nod_var1', 0.002, 1e-2)

        #index = np.where(y==0.5)
        threshold = 0.01
        index = np.intersect1d(np.where(y <= 0.5+threshold)[0],np.where(y >= 0.5-threshold)[0])

        temp_mid = temp[index]
        x_mid = x[index]
        z_mid = z[index]

        #plt.scatter(x,y, c=temp, cmap='coolwarm')
        plt.tricontourf(x_mid, z_mid, temp_mid, cmap='coolwarm')
        plt.colorbar()
        plt.title(str(np.around(cell_x, decimals=2)) + ', ' + str(np.around(cell_z, decimals=2)))
        
        plt.show()

def convergence_checker_ranu(csv_name, exodus_name, output_name, epsilon):
    csv_data = pd.read_csv(csv_name)
    total_ra = np.array(csv_data['Ra'], dtype=str)

    b = [] #for plotting
    b_name = []
    output_list = []

    for ra in total_ra:
        #get entropy production
        file_name = exodus_name + '_' + ra + '_out'
        e_name = exodus_name + '_' + ra + '_final.e'
        data = pd.read_csv(file_name+'.csv')
        N_S = np.array(data['N_S'])
        time = np.array(data['time'])
        
        dN_S = np.diff(N_S)
        dt = np.diff(time)

        dN_S_dt = dN_S/dt
        last_dN_S = dN_S_dt[-20:]
        
        max_dN_S = np.max(dN_S)
        
        index = np.argmax(dN_S)
        
        if index!=len(dN_S)-1: 
            diff_max = dN_S[np.argmax(dN_S)+1]-max_dN_S
        else:
            diff_max = 1.0 #if it is the last index, it does not pass convergence test
        
        #if the gradients are not smooth enough, (but how smooth is smooth?)
        #of if the 
        #the problem does not converge.
        
        if np.abs(np.sum(last_dN_S))>epsilon or diff_max>0: # or max(N_S[100:])==N_S[-1]:
            print(e_name)
            b_name.append(e_name)
            b.append(pd.read_csv(file_name + '.csv'))
            output_list.append(ra)
            
    if len(output_list)!=0:
        pd.DataFrame(output_list).to_csv(output_name, header=['Ra'], index=False)
        print('Output possibly not converged nodes to csv done!')
        print('Count: ', len(output_list))

    for i in range(len(b)):
        fig = plt.figure(figsize=(12,4))
        plt.subplot(121)
        plt.plot(b[i]['time'], b[i]['N_S'])
        plt.scatter(b[i]['time'][np.argmax(b[i]['N_S'][100:])], max(b[i]['N_S'][100:]), c='r')
        plt.title(b_name[i])
        
        plt.subplot(122)
        nc = netCDF4.Dataset(b_name[i])

        x = nc.variables['coordx'][:]
        y = nc.variables['coordy'][:]
        z = nc.variables['coordz'][:]

        temp = nc.variables['vals_nod_var1'][-1]
        
        cell_x, cell_z = count_convection_cells(b_name[i], 'vals_nod_var1', 0.002, 1e-2)

        #index = np.where(y==0.5)
        threshold = 0.01
        index = np.intersect1d(np.where(y <= 0.5+threshold)[0],np.where(y >= 0.5-threshold)[0])

        temp_mid = temp[index]
        x_mid = x[index]
        z_mid = z[index]

        #plt.scatter(x,y, c=temp, cmap='coolwarm')
        plt.tricontourf(x_mid, z_mid, temp_mid, cmap='coolwarm')
        plt.colorbar()
        plt.title(str(np.around(cell_x, decimals=2)) + ', ' + str(np.around(cell_z, decimals=2)))
        
        plt.show()
        
def mesh_scatter(ax_object, x, y, connect, mesh_nodes):
    connect_index = np.array([])
    
    for con in connect:
        connect_index = np.append(connect_index, con[0:mesh_nodes])
    
    connect_index = np.unique(connect_index)
    connect_index = np.array(connect_index, dtype=int)
    
    ax_object.scatter(np.take(x, connect_index), np.take(y, connect_index), s=0.2)
    ax_object.set_xlim(0,4)
    ax_object.set_ylim(0,1)
    
def ep_box_plot(file_name):
    fig = plt.figure(figsize=(10,3))
    nc = netCDF4.Dataset(file_name + '.e')

    x = nc.variables['coordx'][:]
    y = nc.variables['coordy'][:]
    z = nc.variables['coordz'][:]

    temp = nc.variables['vals_nod_var1'][-1]
    v = nc.variables['vals_nod_var3'][-1]

    cell_x, cell_z = count_convection_cells(file_name + '.e', 'vals_nod_var1', 0.002, 1e-2)

    csv_data = pd.read_csv(file_name + '.csv')

    print(file_name, np.around(np.array(csv_data['N_S'])[-1], decimals=3))

    #index = np.where(y==0.5)
    threshold = 0.0005
    index = np.intersect1d(np.where(y <= 0.5+threshold)[0],np.where(y >= 0.5-threshold)[0])

    temp_mid = temp[index]
    v_mid = v[index]
    x_mid = x[index]
    z_mid = z[index]

    #ax2 = plt.subplot2grid((4,5), (i,0), rowspan=1, colspan=2) #plt.subplot(422+2*i)
    #ax = plt.subplot2grid((4,5), (i,2), rowspan=1, colspan=3) #plt.subplot(421+2*i)

    ax = plt.subplot(132)

    ax.tick_params(labelsize=14)
    ax.set_xticks(np.linspace(0,np.max(x),3))
    ax.set_xticklabels(np.linspace(0,np.max(x),3), fontsize=14)
    ax.set_yticks(np.linspace(0,np.max(z),3))
    ax.set_yticklabels(np.linspace(0,np.max(z),3), fontsize=14)

    cax = ax.tricontourf(x_mid, z_mid, temp_mid, cmap='coolwarm')#, vmin=0.1, vmax=0.9)
    ax.set_title(str(np.around(cell_x, decimals=2)) + ', ' + str(np.around(cell_z, decimals=2)), fontsize=16)
    cb = plt.colorbar(cax)
    cb.ax.tick_params(labelsize=14)
    cb.ax.set_title('T (-)', fontsize=16, rotation=0)
    ax.set_xlabel('$h_1$', fontsize=16)
    ax.set_ylabel('$h_2$', fontsize=16, rotation=0, labelpad=20)
    
    ax3 = plt.subplot(133)

    ax3.tick_params(labelsize=14)
    ax3.set_xticks(np.linspace(0,np.max(x),3))
    ax3.set_xticklabels(np.linspace(0,np.max(x),3), fontsize=14)
    ax3.set_yticks(np.linspace(0,np.max(z),3))
    ax3.set_yticklabels(np.linspace(0,np.max(z),3), fontsize=14)

    cax = ax3.tricontourf(x_mid, z_mid, v_mid, cmap='coolwarm')#, vmin=0.1, vmax=0.9)
    ax3.set_title(str(np.around(cell_x, decimals=2)) + ', ' + str(np.around(cell_z, decimals=2)), fontsize=16)
    #cb = plt.colorbar(cax)
    #cb.ax.tick_params(labelsize=14)
    #cb.ax.set_title('v (-)', fontsize=16, rotation=0)
    ax3.set_xlabel('$h_1$', fontsize=16)
    ax3.set_ylabel('$h_2$', fontsize=16, rotation=0, labelpad=20)
    
    ax2 = plt.subplot(131)

    ax2.tick_params(labelsize=14)
    ax2.plot(csv_data['time'], csv_data['N_S'])
    #ax2.set_ylim(1.0, 2.0)
    ax2.set_xlabel('time (-)', fontsize=16)
    ax2.set_ylabel('$N_{\dot S}$', fontsize=16, rotation=0, labelpad=20)
    ax2.set_ylim(1,2)

    plt.tight_layout()
    plt.show()
    return [cell_x, cell_z]

def count_cells(grid_temp):
    temp_check = np.zeros_like(grid_temp)
    temp_check[grid_temp>=0.5] = 1
    temp_check[grid_temp< 0.5] = 0

    #x-direction
    total_count_x = 0
    for row in temp_check:
        total_count_x += np.count_nonzero(np.diff(row))

    cell_x = total_count_x/len(temp_check)

    #z-direction
    total_count_z = 0
    for row in temp_check.T:
        total_count_z += np.count_nonzero(np.diff(row))

    cell_z = total_count_z/len(temp_check.T)
    return [cell_x, cell_z]

def Beck_cell_predict(h_1, h_2, max_cell, Ra):
    pairs = []
    for p in product(range(0,max_cell+1), repeat=2):
        pairs.append(p)

    pairs.pop(0)
    pairs = np.array(pairs)

    #minimizing the objective_function
    obj_func = []
    for m, n in pairs:
        b = np.sqrt(m**2/h_1**2 + n**2/h_2**2)
        Ra_c = np.pi**2*(b+1.0/b)**2
        obj_func.append(Ra_c)

    obj_func = np.array(obj_func)
    sorted_index = np.argsort(obj_func, axis=0)
    obj_func = np.sort(obj_func, axis=0)

    pair_list = []
    for i in range(len(obj_func)):
        if obj_func[i]<Ra:
            pair_list.append(pairs[sorted_index][i])
        #print(pairs[sorted_index][i], obj_func[i])

    return pair_list