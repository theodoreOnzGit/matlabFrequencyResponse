%% so this file is supposed to take in a csv file containing nonuniform time input and output signals,

% and churn out information for bode plot data, and gain and phase plots
% for all frequencies in the fourier transform.

%% firstly, clear the matlab workspace and figures
clear


%% secondly take the double and perform a nonuniform FFT

% this will return and input FFT array and output FFT array against
% frequency

% both are done in myFFT function


freqData=myFFT('binaryNoiseSignal.csv');


%% Thirdly, plot gain and phase of the FFTs vs frequency

% for nonlinear methods, this plot may not work
% so the first method is for linear frequency response only!

gainAndPhase=gainAndPhase(freqData);



% the second is for both linear and nonlinear plots if you have a sine wave
% input signal

% but i'll not be doing the second part so much, cos that will just include
% dividing everything by the gain of the input frequency

peakData=peakfinder(freqData);

%% fourth put in gain and phase data into correct matlab form for the principal frequency

% first i'll need to find the principal freqencies,
% that comes from the FFT of the input file.


% note that you'll need the signal processing toolbox for this


%% for testing
f=freqData(:,1);
input=freqData(:,2);
output=freqData(:,3);



%% function for complex gain and frequencies at the input frequencies(s)

