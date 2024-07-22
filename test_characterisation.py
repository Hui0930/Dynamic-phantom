# -*- coding: utf-8 -*-
"""
Created on Wed Mar  6 15:24:44 2024

@author: hui.ma
"""

from characterisation import LCDCharacterisation
import numpy as np

voltages=np.arange(0.5,3,0.05)
colours=['I','R','G','B']


LCDCharacterisation(voltages, colours)