function [gainAndPhase] = gainAndPhase(freqData)
%% Summary of this function goes here

% this function just extracts the gain and phase of the inputs and outputs
% in freqData
% this takes the absolute values of output at each frequency and divides
% by the absolute values of input at each frequency

disp('warning, this may only work on LINEAR frequency response')

%   Detailed explanation goes here


% just make sure that  the frequency data is in columns. First column is
% frequency in Hz (not crucial), second is normalised FFT for input signal, third
% column is normalised FFT for output signal
%% first we get our frequency and etc first


f=freqData(:,1);
input=freqData(:,2);
output=freqData(:,3);

%% second gain matrix

gain=abs(output)./abs(input);

%% third let's get the phase for both

phaseInput=angle(input);
phaseOutput=angle(output);
phaseDiff=angle(output)-angle(input);

%% fourth reconstruct the matrix to give it out
% in the format, frequency, gain and phase

gainAndPhase=[f,gain,phaseDiff];

disp('%%%% gain and phase function complete')
end

