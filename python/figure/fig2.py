#! /usr/bin/python3

# ==================================================
# Python Embedded Modules
# ==================================================
import numpy as np
import matplotlib.pyplot as plt
import sys, os
from mpl_toolkits.axisartist.axislines import SubplotZero
# ==================================================
# Python Custom Modules
# ==================================================
sys.path.append('/home/%s/.pyLib/'%(os.environ.get('USER')))
from nnWoong import *


x = np.arange(-1,4,0.001)
y1 = np.heaviside(x, 1)-np.heaviside(x-1, 1)
y2 = 2*x
y3 = y1*y2

fig = plt.figure()
ax1 = SubplotZero(fig, 311)
ax2 = SubplotZero(fig, 312)
ax3 = SubplotZero(fig, 313)

fig.add_subplot(ax1)
ax1.axis['xzero', 'yzero'].set_visible(True)
ax1.axis['top','bottom','left','right'].set_visible(False)
ax1.plot(x,y1)
ax1.axis([min(x-0.1), max(x+0.1), -0.1, 2+0.1])
#ax1.xticks(np.array([-1,0,1,2,3,4]))
#ax1.yticks(np.array([-0,1]))

fig.add_subplot(ax2)
ax2.axis['xzero', 'yzero'].set_visible(True)
ax2.axis['top','bottom','left','right'].set_visible(False)
ax2.plot(x,y2)
ax2.axis([min(x-0.1), max(x+0.1), -0.1, 2+0.1])
#ax2.xticks(np.array([-1,0,1,2,3,4]))
#ax2.yticks(np.array([-0,1]))

fig.add_subplot(ax3)
ax3.axis['xzero', 'yzero'].set_visible(True)
ax3.axis['top','bottom','left','right'].set_visible(False)
ax3.plot(x,y3)
ax3.axis([min(x-0.1), max(x+0.1), -0.1, 2+0.1])
#ax3.xticks(np.array([-1,0,1,2,3,4]))
#ax3.yticks(np.array([-0,1]))

plt.tight_layout()
plt.show()
