%% so this file is supposed to take in a csv file containing nonuniform time input and output signals,

% and churn out information for bode plot data, and gain and phase plots
% for all frequencies in the fourier transform.

%% firstly, clear the matlab workspace and figures
clear


%% secondly take the double and perform a nonuniform FFT

% this will return and input FFT array and output FFT array against
% frequency

% both are done in myFFT function


freqData=myFFT('frequencyResponse_PRBS_data_amp2.csv');


%% Thirdly, plot gain and phase of the FFTs vs frequency

% for nonlinear methods, this plot may not work
% so the first method is for linear frequency response only!

gainAndPhase=gainAndPhase(freqData);



% the second is for both linear and nonlinear plots if you have a sine wave
% input signal

% but i'll not be doing the second part so much, cos that will just include
% dividing everything by the gain of the input frequency

peakData=linearPeakFinder(freqData);

%% fourth put in gain and phase data into correct matlab form for the principal frequency

% first i'll need to find the principal freqencies,
% that comes from the FFT of the input file.


% note that you'll need the signal processing toolbox for this


%% for testing
f=freqData(:,1);
input=freqData(:,2);
output=freqData(:,3);

% add nyquist freq into peakData

peakData.samplingFrequency_Hz=max(f);
peakData.nyquistFrequency_Hz=peakData.samplingFrequency_Hz/2;
peakData.samplingInterval_s=1/peakData.samplingFrequency_Hz;


%% convert freqData peakData into frequency response data

frData=peakData2idfrd(peakData)

%% next use the tfest function to generate a transfer function

%https://www.mathworks.com/help/ident/ref/tfest.html

% decide your delay time, number of poles and number of zeroes here
delayTime=0; %delay time is sometimes residence time
nPoles=2;
nZeroes=nPoles-1;

% transfer function options
% change all poles to be stable
tfopt=tfestOptions;
tfopt.EnforceStability=true;


% lastly your transfer function is estimated here
transferFunctionSys=tfest(frData,nPoles,nZeroes,delayTime,tfopt)
%transferFunctionSys=tfest(frData,nPoles)
data.sys=transferFunctionSys;
data.frData=frData;

%% plot transfer function vs data
opt=bodeoptions;
opt.FreqUnits='Hz';

bodeplot(transferFunctionSys,frData,'*',opt)

% difference between bode and bodeplot,
% bode gives u the freq response data
% bodeplot, gives you more options to plot your bode plots

%% load data into arrays:

[peakData.fittedTrFnMag,peakData.fittedTrFnPhase,peakData.fittedTrFn_omega]=bode(transferFunctionSys);
[peakData.FrDataMag,peakData.FrDataPhase,peakData.FrData_omega]=bode(frData);


%tidy up arrays
peakData.fittedTrFnMag=squeeze(peakData.fittedTrFnMag);
peakData.fittedTrFnPhase=squeeze(peakData.fittedTrFnPhase);
peakData.FrDataMag=squeeze(peakData.FrDataMag);
peakData.FrDataPhase=squeeze(peakData.FrDataPhase);


% convert to Hz
peakData.fittedTrFnHz=peakData.fittedTrFn_omega/2/pi;
peakData.FrDataHz=peakData.FrData_omega/2/pi;


%% List of Functions

function [fr_data]=peakData2idfrd(peakData)
%% this function takes multiple bode plots and creates a idfrd object which can be used to estimate
% a transfer function

%% one would obtain several plots of data first



freq=peakData.peakFrequenciesCSV;
response=peakData.complexGainCSV;


%% now i load in my sampling interval (estimated)

Ts = peakData.samplingInterval_s;


% note that sampling time here is just to help eliminate any data point
% with frequency above nyquist frequency


% lastly create the idfrd object
% https://www.mathworks.com/help/ident/ref/idfrd.html#f4-1777348

fr_data=idfrd(response,freq,Ts,'FrequencyUnit','Hz');
%fr_data=idfrd(response,freq,Ts);

end
