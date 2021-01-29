function [freqData] = myFFT(csvFile)
% this is a custom FFT Script that takes time domain data 
% one input and one output, and churns out gain and phase data


%   Detailed explanation goes here


% first we import the csv file, of course greet the user first too...

helloWorld();
data=csv2array(csvFile);
printImportcsv();

% now we have csv data, we'll need to do a nufft on it to churn out
% normalised FFT of our data

freqData=normalisedFFT(data);

end

%% below are functions used in the above main function

function [] = helloWorld()

disp('hello this is the FFT function')

disp('we start by importing a csv file with one column for time, one for input signal, one for output signal')

end

function [] = printImportcsv()

disp('imported csv file to array...')

end

function [array] = csv2array(csv)

% first let's import the table, using readTable, 
% https://www.mathworks.com/matlabcentral/answers/72545-how-to-import-csv-file-in-matlab
tableData = readtable(csv);

% then i'll convert the table data into a double array
% https://www.mathworks.com/matlabcentral/answers/370544-how-do-i-convert-table-data-to-double-to-manipulate-them
array = table2array(tableData);


end

%% here are functions actually doing FFT

function [freqData] = normalisedFFT(data)

% firstly, note that nufft is a non uniform FFT,
% documentation here:  https://www.mathworks.com/help/matlab/ref/double.nufft.html

% step 1: construct a proper frequency list

% first lets get the sampling frequency
n=length(data(:,1));
deltaT=data(n,1)-data(1,1);
fs=n/deltaT;

% next let's get a frequency array transposed in column form 
f=(0:n-1)*fs/n;
f=f';


% next is to prepare the data to be handled, we take out the DC component
% as well by integrating out the average
t=data(:,1);
input=data(:,2);
output=data(:,3);

DCinput=trapz(t,input)/deltaT;
DCoutput=trapz(t,output)/deltaT;

disp('average value of input is')
disp(DCinput)
disp('average value of output is')
disp(DCoutput)

% now i'll subtract the DC component out mostly
input=input-DCinput*ones(n,1);
output=output-DCoutput*ones(n,1);

% next let's get the non uniform FFT of first plot
% https://www.mathworks.com/help/matlab/ref/double.nufft.html
% to normalise the FFT, we divide by no. of data points
Y1=nufft(input,t,f)/n;
Y2=nufft(output,t,f)/n;

% now we can return the data as a frequency data array
freqData=[f,Y1,Y2];


end
