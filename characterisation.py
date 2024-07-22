# -*- coding: utf-8 -*-
"""
Created on Mon Mar  4 12:14:17 2024

@author: Hui
"""

def LCDCharacterisation(voltages,colours): 
#voltage is an integer or float, colour is a string corresponding to an LED (I, R, G or B)

    import os
    os.environ["KMP_DUPLICATE_LIB_OK"]="TRUE"
    import os.path
    from os import path
    # from simple_pyspin import Camera
    import nidaqmx
    from scipy import signal
    import time
    import numpy as np
    import matplotlib.pyplot as plt
    from datetime import datetime
    import csv
    from nidaqmx.stream_writers import (AnalogSingleChannelWriter)
    from nidaqmx.stream_readers import (AnalogSingleChannelReader)

    now = datetime.now() # current date and time
    date = now.strftime("%y%m%d")
    if path.exists(date) == False:
        os.mkdir(now.strftime("%y%m%d"))
    
    frq=200 #frequency of the signal
    fs=10000 #sampling rate
    t = np.linspace(0, 1, fs, endpoint=False)
    o=signal.square(2 * np.pi * frq * t) #generate square wave
    input_fs=100

    voltagecontrol=nidaqmx.Task()  # set the voltage control
    voltagecontrol.ao_channels.add_ao_voltage_chan('Dev5/ao0') #connect to the computer to see the device name
    voltagecontrol.timing.cfg_samp_clk_timing(rate= fs, sample_mode=nidaqmx.constants.AcquisitionType.CONTINUOUS)
    voltage_Writer = nidaqmx.stream_writers.AnalogSingleChannelWriter(voltagecontrol.out_stream, auto_start=True)
    
    photodetector=nidaqmx.Task()
    photodetector.ai_channels.add_ai_voltage_chan('Dev5/ai8',min_val=-10,max_val=10)
    photodetector.timing.cfg_samp_clk_timing(rate=input_fs, sample_mode=nidaqmx.constants.AcquisitionType.CONTINUOUS)
    data_Reader = nidaqmx.stream_readers.AnalogSingleChannelReader(photodetector.in_stream)
    
    red=nidaqmx.Task() #red LED
    red.do_channels.add_do_chan('Dev5/port0/line0')

    green=nidaqmx.Task() #green LED
    green.do_channels.add_do_chan('Dev5/port0/line1')

    blue=nidaqmx.Task() #blue LED
    blue.do_channels.add_do_chan('Dev5/port0/line2')

    nir=nidaqmx.Task() #NIR LED
    nir.do_channels.add_do_chan('Dev5/port0/line3')

    red.start()  #initialize LED
    green.start()
    blue.start()
    nir.start()    
    
    I = []
    R = []
    G = []
    B = []
    
    dataarr=np.zeros(input_fs//4)

    for colour in colours:
        
        #set LED
        if colour == 'I':
            nir.write(True)
        elif colour == 'R':
            red.write(True)
        elif colour == 'G':
            green.write(True)
        elif colour == 'B':
            blue.write(True)
        else:
            red.write(False)
            green.write(False)
            blue.write(False)
            nir.write(False)
        
        for voltage in voltages:
            print(voltage)
            filename = now.strftime("%y%m%d/") + colour + str(round(voltage,2))
            
            samples=o*voltage
            voltage_Writer.write_many_sample(samples) #generate square wave
            time.sleep(0.5) # Wait for LCD attenuation to settle
            photodetector.start()
            input_data= data_Reader.read_many_sample(dataarr,number_of_samples_per_channel=input_fs//4)
            intensity=np.mean(np.absolute(dataarr))
            voltagecontrol.stop()
            photodetector.stop()
            
            if colour == 'I':
                I.append(intensity)
            elif colour == 'R':
                R.append(intensity)
            elif colour == 'G':
                G.append(intensity)
            elif colour == 'B':
                B.append(intensity)
                
        red.write(False)
        green.write(False)
        blue.write(False)
        nir.write(False)
                
    voltagecontrol.close()
    red.stop()
    red.close()
    green.stop()
    green.close()
    blue.stop()
    blue.close()
    nir.stop()
    nir.close()     
    photodetector.close()

    
    I=np.array(I)
    R=np.array(R)
    G=np.array(G)
    B=np.array(B)    

    np.savetxt(now.strftime("%y%m%d/")+'I.txt',I)
    np.savetxt(now.strftime("%y%m%d/")+'G.txt',G)
    np.savetxt(now.strftime("%y%m%d/")+'B.txt',B)
    np.savetxt(now.strftime("%y%m%d/")+'R.txt',R)        