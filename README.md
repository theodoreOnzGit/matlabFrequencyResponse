# matlabFrequencyResponse
Demonstration of Matlab Frequency Response Tools









#### debugging notes....
note that for the labview generated PRBS example,

samples are taken every 0.05s (sampling freq =20hz ideally)

but because of time taken for the calculation and iteration loops,

samples are taken every 0.0503s (sampling freq becomes 19.884 Hz, the mirror side of data
doesn't get captured)

my workaround: use another frequency column OR,

append the maximum frequency as another test frequency... use that for nyquist frequency.