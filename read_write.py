# -*- coding: utf-8 -*-
"""
Created on Wed Mar  6 17:45:00 2024

@author: hui.ma
"""

import numpy as np
import nidaqmx
import matplotlib.pyplot as plt
import time
import threading
from nidaqmx import constants
from nidaqmx.constants import Edge, Slope
from nidaqmx.stream_readers import AnalogSingleChannelReader
from nidaqmx.stream_writers import AnalogSingleChannelWriter

outputdata=np.loadtxt('Ri.txt')
fs=10000
inputrate=50
input_value=[]
input_duration=7.6

voltagecontrol=nidaqmx.Task()  # set the voltage control
voltagecontrol.ao_channels.add_ao_voltage_chan('Dev5/ao0') #connect to the computer to see the device name
voltagecontrol.timing.cfg_samp_clk_timing(rate= fs, sample_mode=nidaqmx.constants.AcquisitionType.CONTINUOUS)
voltage_Writer = nidaqmx.stream_writers.AnalogSingleChannelWriter(voltagecontrol.out_stream, auto_start=True)

numsample=int(input_duration*inputrate)
dataarr=np.zeros(numsample)
photodiode = nidaqmx.Task()
photodiode.ai_channels.add_ai_voltage_chan('Dev5/ai8',min_val=-10,max_val=10)
photodiode.timing.cfg_samp_clk_timing(rate=inputrate,sample_mode=nidaqmx.constants.AcquisitionType.CONTINUOUS)
Photodiode_Reader = nidaqmx.stream_readers.AnalogSingleChannelReader(photodiode.in_stream)
photodiode.start()
starttime=time.time()
voltage_Writer.write_many_sample(outputdata) #generate square wave
Photodiode_Reader.read_many_sample(dataarr,number_of_samples_per_channel=numsample,timeout=10)
print(time.time()-starttime)
# time.sleep(6)
photodiode.stop()
photodiode.close()
input_value.append(np.absolute(dataarr))


# voltagecontrol.start()
# voltage_Writer.write_many_sample(outputdata) #generate square wave
# time.sleep(6)
voltagecontrol.stop()
voltagecontrol.close()

np.savetxt('Ro.txt',dataarr)
plt.plot(dataarr)