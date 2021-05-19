% this script takes a csvFile with first row of frequencies and second row
% of complex gain and turns it into transfer function

clear 
clc
clf

%% firstly, import bode plot data with frequency in first column against complex magnitude
% in second column and turn it into frequency Response data idfrd object



frData=csv2idfrd('testData.csv','listofFreqs.csv')

%% secondly use the tfest function to generate a transfer function

%https://www.mathworks.com/help/ident/ref/tfest.html

% decide your delay time, number of poles and number of zeroes here
delayTime=0; %delay time is sometimes residence time
nPoles=2;
nZeroes=nPoles-1;

% lastly your transfer function is estimated here
transferFunctionSys=tfest(frData,nPoles,nZeroes,delayTime)
%transferFunctionSys=tfest(frData,nPoles)
data.sys=transferFunctionSys;
data.frData=frData;

magPlots(data);
%phasePlots(data);

%% poles, zeros and gain

poles=pole(transferFunctionSys)
[zeros,gain]=zero(transferFunctionSys)


%% to see the bode plot use the functions below

function []=magPlots(data)

%% first let's import the magnitude and frequency data
data_freq=data.frData.Frequency;
data_mag=data.frData.Response;
% reduce a (1,1,n) matrix to a (n) matrix
data_mag=squeeze(data_mag);
data_mag=abs(data_mag);

%phase=angle(data.frData(:,2));

%% second let's plot out the bode plots
[tf_mag,tf_phase,tf_freq]=bode(data.sys);
tf_mag=squeeze(tf_mag);
% remember, we need to convert radians per sec to Hz
tf_freq=squeeze(tf_freq*1/2/pi);

tfmagdB=20*log10(tf_mag);
datamagdB=20*log10(data_mag);
logtf_freq=log10(tf_freq);
log_dataFreq=log10(data_freq);

plot(log_dataFreq,datamagdB,'*')
hold on
grid on
plot(logtf_freq,tfmagdB)

title('Bode Magnitude Plot of Raw Frequency Response Data and Fitted Transfer Function')
xlabel('log_{10} frequency(Hz)')
ylabel('20*log_{10} (Gain)') 
disp('use clf to clear plots')
hold off

end

function []=phasePlots(data)

% first let's import the phase and frequency data

%% first let's import the phase and frequency data
data_freq=data.frData.Frequency;
data_phase=data.frData.Response;
% reduce a (1,1,n) matrix to a (n) matrix
data_phase=squeeze(data_phase);
data_phase=angle(data_phase);

%phase=angle(data.frData(:,2));

%% second let's plot out the bode plots
[tf_mag,tf_phase,tf_freq]=bode(data.sys);
tf_phase=squeeze(tf_phase);
% remember, we need to convert radians per sec to Hz

tf_freq=squeeze(tf_freq/2/pi);

plot(data_freq,data_phase,'*')
hold on
grid on
plot(tf_freq,tf_phase)

disp('use clf to clear plots')

hold off
end
%% below is the csv2idfrd function

function [fr_data]=csv2idfrd(freqRespDataCSV,freqArrayCSV)
%% this function takes multiple bode plots and creates a idfrd object which can be used to estimate
% a transfer function

%% one would obtain several plots of data first

% use main_nufft_import_and_plot.m to obtain bode data from csv files

% next, concatenate the test data to obtain two vectors:
% first of frequencies, and second of complex gain

% probably will want to store the testData into a csv file

% let's say the test Data comes from testData.csv
bodeArray=csv2array_2col(freqRespDataCSV);

%% now i load in my sampling frequency (estimated)
maxFreqArray=csv2array_1col(freqArrayCSV);
fs = max(maxFreqArray);
Ts = 1/fs;


% note that sampling time here is just to help eliminate any data point
% with frequency above nyquist frequency


freq=bodeArray(:,1);
response=bodeArray(:,2);

% lastly create the idfrd object
% https://www.mathworks.com/help/ident/ref/idfrd.html#f4-1777348

fr_data=idfrd(response,freq,Ts,'FrequencyUnit','Hz');
%fr_data=idfrd(response,freq,Ts);

end


function [array] = csv2array_2col(csv)

% first let's import the table, using readTable, 
% https://www.mathworks.com/matlabcentral/answers/72545-how-to-import-csv-file-in-matlab

% the delimiter bit gives this function capability to deal with complex
% numbers
% see here: https://itectec.com/matlab/matlab-how-to-import-columns-of-complex-numbers-to-matlab-variables-from-csv-file/

tableData = readtable(csv,'delimiter',',');
% then i'll convert the table data into a double array
% https://www.mathworks.com/matlabcentral/answers/370544-how-do-i-convert-table-data-to-double-to-manipulate-them
response=tableData(:,2);
response=table2array(response);
response=str2double(response);

freq=tableData(:,1);
freq=table2array(freq);
array=[freq,response];

end

function [array] = csv2array_1col(csv)


tableData = readtable(csv,'delimiter',',');


freq=tableData(:,1);
array=table2array(freq);
end