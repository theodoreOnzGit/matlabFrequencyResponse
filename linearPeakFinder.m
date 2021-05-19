function [peakData] = linearPeakFinder(freqData)
% basically i'm finding the peaks with their associated frequencies in this
% function, i output an object with both input and output peaks

%% first
% let's import the data from freqData to make it more readable
f=freqData(:,1);
input=freqData(:,2);
output=freqData(:,3);

%% second find the magnitude of the peaks

inputMag=abs(input);
outputMag=abs(output);

% decibels here will be used as the threshold for the peak prominence

thresholdInput=max(abs(inputMag))/4;
thresholdOutput=max(abs(outputMag))/10; % only input peaks are used 



%% third let's calculate our input and output peaks and frequencies
% https://www.mathworks.com/help/signal/ref/findpeaks.html

% load them straightaway into the data structure

[peakData.inputPeaksMag,peakData.inputPeakFreqs]=findpeaks(inputMag,f,'MinPeakHeight',thresholdInput);

[peakData.outputPeaksMag,peakData.outputPeakFreqs]=findpeaks(outputMag,f,'MinPeakHeight',thresholdOutput);

% now i also want to load frequency and complex gain into the peak finder

[pks,inputPeakIndex]=findpeaks(inputMag,'MinPeakHeight',thresholdInput);
clear pks

% this next part extracts the peaks at the various frequencies according to ONLY the input peaks
inputPeaks=elementSearch(input,inputPeakIndex);
outputPeaks=elementSearch(output,inputPeakIndex);
peakFrequencies=elementSearch(f,inputPeakIndex);

complexGain=outputPeaks./inputPeaks;

peakData.peakFrequenciesCSV=peakFrequencies;
peakData.complexGainCSV=complexGain;


%% fourth, print the results
disp('use clf to clear the figures')
findpeaks(inputMag,f,'MinPeakHeight',thresholdInput);
hold on
findpeaks(outputMag,f,'MinPeakHeight',thresholdOutput);
disp('remember to also set hold off')
hold off
end

%% the element search function used to isolate peaks based on location is here
% it takes in two vectors, 

% first vector is a vector of FFT data against some index
% second vector is a vector of indices
% the output vector just gives a vector of indices at that location

function [filteredFFTData]=elementSearch(FFTData,inputPeakIndices)

n=length(inputPeakIndices);
filteredFFTData=zeros(n,1);


for i=1:n
    peakIndex=inputPeakIndices(i,1);
    filteredFFTData(i,1)=FFTData(peakIndex,1);
end

end