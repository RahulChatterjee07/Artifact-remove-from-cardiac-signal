% Author - Rahul Chatterjee, Created on Jan 09, 2022

% data import
data=load('C:\Users\Downloads\test_signals\signal_1.mat')


fs=48000; % sampling frequency
Y=data.signal.y();

T = 1/fs;
l=length(Y);


fn=(fs/2); % Nyquist frequency

% Removing power line artifacts
f0 = 60;                % notch frequency
              
freqRatio = f0/fn;      % ratio of notch freq. to Nyquist freq.

notchWidth = 0.1;       % width of the notch

% Design Notch filter

% Compute zeros
notchZeros = [exp( sqrt(-1)*pi*freqRatio ), exp( -sqrt(-1)*pi*freqRatio )];

% Compute poles
notchPoles = (1-notchWidth) * notchZeros;


b = poly( notchZeros ); %  filter coefficients
a = poly( notchPoles ); %  filter coefficients
fOut = filter(b,a,Y);

% Bandpass filter within the range of 10 to 20 Hz

d = designfilt('bandpassiir','FilterOrder',40, ...
    'HalfPowerFrequency1',10,'HalfPowerFrequency2',20, ...
    'SampleRate',fs);

fOut = filter(d,fOut);
%fOut = bandpass(fOut,[10 20],fs)


% Smoothing the data using normalization

n=1000; % n = 2000 (signal_2; for better visualization)
fOut = fOut - mean(fOut)
fOut = resample(fOut,1,n)

% Plot the results
t = (0:(l/n)-1)*n*T;
fs_new=fs/n;

plot (t(fs_new:30*fs_new),fOut(fs_new:30*fs_new),'b')

