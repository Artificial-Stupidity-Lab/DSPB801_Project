% Load a built-in MATLAB audio file
[x, fs] = audioread('a1.wav');

% Plot the time domain signal
t = (0:length(x)-1) / fs;
plot(t, x);
xlabel('Time (seconds)');
ylabel('Amplitude');
title('Time Domain Signal of Handel Audio');
grid on;

% Display the plot
