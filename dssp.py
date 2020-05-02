#!/usr/bin/env python
# -*- coding:utf-8 -*-
# Author: Yujie Liu
# Plot ss.xpm produced by gmx do_dssp

from matplotlib import pyplot as plt
from matplotlib.pyplot import MultipleLocator
from mpl_toolkits.axes_grid1 import make_axes_locatable
from matplotlib.colors import LinearSegmentedColormap


import numpy as np
import re
import sys
import os
import shlex

def parse_xpm(fname):
    """Parses XPM file colors, legends, and data"""
    
    metadata = {}
    num_data = [[], [], []] # x, y, color
    color_data = {} # color code: color hex, color value

    ff_path = os.path.abspath(fname)
    if not os.path.isfile(ff_path):
        raise IOError('File not readable: {0}'.format(ff_path))
    
    with open(ff_path, 'r') as fhandle:
        for line in fhandle:
            line = line.strip().rstrip(',')
            
            if line.startswith('/*'):
                tokens = shlex.split(line[2:].lstrip())
                t_name = tokens[0]
                
                if t_name in set(('title:', 'legend:', 'x-label:', 'y-label:')):
                    metadata[t_name.strip(':')] = tokens[1]
                
                elif t_name == 'x-axis:':
                    x_values = map(float, tokens[1:-1]) # last */
                    num_data[0].extend(x_values)

                elif t_name == 'y-axis:':
                    y_values = map(float, tokens[1:-1]) # last */
                    num_data[1].extend(y_values)

            elif line.startswith('"'):
                if line.endswith('*/'):
                    # Color
                    tokens = shlex.split(line)
                    c_code, _, _ = tokens[0].split()
                    try:
                        c_value = float(tokens[2])
                    except:
                        seq = ['Coil', 'B-Sheet', 'B-Bridge', 'Bend', 'Turn', 'A-Helix', '5-Helix', '3-Helix', 'Chain_Separator']
                        c_value = unique_index(seq, tokens[2])[0]
                    color_data[c_code] = c_value
                    
                elif line.endswith('"') and ' ' not in line:
                    num_data[2].append(line[1:-1])
    
    # Convert data to actual values
    for irow, row in enumerate(num_data[2][:]):
        num_data[2][irow] = map(color_data.get, row)

    return metadata, num_data
    
def unique_index(L, e):
    return [i for (i,j) in enumerate(L) if j == e]

def main():
    metadata, data = parse_xpm(sys.argv[1])
    x, y, z = map(np.asarray, data)
    #x, y = np.meshgrid(x, y)
    font = {'family': 'Times New Roman',
            'weight': 'regular',
            'size': '12'}
    plt.rc('font', **font)
    x_major = MultipleLocator(500)
    y_major = MultipleLocator(20)
    colors = [(1, 1, 1), (1, 0, 0), (0, 0, 0), (0, 1, 0), 
              (1, 1, 0), (0, 0, 1), (0.7, 0.3, 0.8), (0.5, 0.5, 0.5)]
    cmap_name = 'my_list'
    cm = LinearSegmentedColormap.from_list(cmap_name, colors, N=8)
    plt.figure(figsize=(6, 6))
    ax = plt.gca()
    ax.xaxis.set_major_locator(x_major)
    ax.yaxis.set_major_locator(y_major)
    
    plt.imshow(z, cmap=cm, origin='upper')
    xtick_list = map(int, ax.get_xticks().tolist())
    ori_xticks = [xt for xt in xtick_list if xt>=0 and xt<=len(data[0])]
    for itick, xtick in enumerate(xtick_list[:]):
        if xtick >= 0 and xtick <= len(data[0]):
            xtick_list[itick] = data[0][xtick]
    ax.set_xticklabels(xtick_list)
    
    ytick_list = map(int, ax.get_yticks().tolist())
    ori_yticks = [xt for xt in ytick_list if xt>=0 and xt<=len(data[1])]
    ymin, ymax = ax.get_ylim()
    n_y_ticks = len(ori_yticks)
    y_spacing = ori_yticks[1] - ori_yticks[0]
    y_tick_list = [ymin - y_spacing*t for t in range(n_y_ticks)]
    y_tick_list = map(int, y_tick_list)
    y_labels = [data[1][ytick] for ytick in y_tick_list][::-1]
    offset = max(y_labels) - max(ytick_list)
    y_labels = [ytick - offset for ytick in y_labels]
    y_labels = map(int, y_labels)
    
    ax.set_yticks(y_tick_list)
    ax.set_yticklabels(y_labels)
    
    plt.xlabel(metadata.get('x-label', ''))
    plt.ylabel(metadata.get('y-label', ''))
    plt.title(metadata.get('title', ''))
    
    divider = make_axes_locatable(ax)
    cax = divider.append_axes("right", size="5%", pad=0.05)
    cb = plt.colorbar(cax=cax)
    cb.set_ticks(range(0, 8))
    cb.set_ticklabels(['Coil', 'B-Sheet', 'B-Bridge', 'Bend', 'Turn', 'A-Helix', '5-Helix', '3-Helix'])
    plt.savefig("ss.pdf", dpi = 600)
    plt.show()
    
if __name__ == '__main__':
    if len(sys.argv) < 2:
        print('\tERROR: No input files!')
        sys.exit(1)
    main()

