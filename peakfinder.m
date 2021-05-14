function [peakData] = peakfinder(freqData)
% basically i'm finding the peaks with their associated frequencies in this
% function, i output an object with both input and output peaks

%% first
% let's import the data from freqData to make it more readable
f=freqData(:,1);
input=freqData(:,2);
output=freqData(:,3);

%% second convert the peak into decibels

inputdB=10*log10(abs(input));
outputdB=10*log10(abs(output));

% decibels here will be used as the threshold for the peak prominence

thresholdInput=10*log10((max(abs(inputdB))));
thresholdOutput=10*log10((max(abs(outputdB))));



%% third let's calculate our input and output peaks and frequencies
% https://www.mathworks.com/help/signal/ref/findpeaks.html

% load them straightaway into the data structure

[peakData.inputPeaksdB,peakData.inputPeakFreqs]=findpeaks(inputdB,f,'MinPeakProminence',thresholdInput);

[peakData.outputPeaksdB,peakData.outputPeakFreqs]=findpeaks(outputdB,f,'MinPeakProminence',thresholdOutput);

% now i also want to load frequency and complex gain into the peak finder

[pks,inputPeakIndex]=findpeaks(inputdB,'MinPeakProminence',thresholdInput);
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
findpeaks(inputdB,f,'MinPeakProminence',thresholdInput);
hold on
findpeaks(outputdB,f,'MinPeakProminence',thresholdOutput);
disp('remember to also set hold off')

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