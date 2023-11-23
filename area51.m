% Load a built-in MATLAB audio file
close all, clear, clc;
[x, fs] = audioread('a1.wav');

% Trim the audio to 12 seconds
desired_length = 12; % seconds
x_trimmed = x(1:min(length(x), round(desired_length * fs)), :);

% Plot the time domain signal
t = (0:length(x_trimmed)-1) / fs;
plot(t, x_trimmed);
xlabel('Time (seconds)');
ylabel('Amplitude');
title('Time Domain Signal of Audio Signal');
grid on;

% Display the plot

%%
% Load a built-in MATLAB audio file
close all, clear, clc;
% Load a built-in MATLAB audio file
[x, fs] = audioread('a1.wav');

% Trim the audio to 12 seconds
desired_length = 12; % seconds
x_trimmed = x(1:min(length(x), round(desired_length * fs)), :);

% Plot the time domain signal
t = (0:length(x_trimmed)-1) / fs;
subplot(2, 1, 1);
plot(t, x_trimmed);
xlabel('Time (seconds)');
ylabel('Amplitude');
title('Time Domain Signal');
grid on;

% Take the Fourier transform
nfft = 2^nextpow2(length(x_trimmed));
frequencies = linspace(0, fs/2, nfft/2 + 1);
X = fft(x_trimmed, nfft);
magnitude_spectrum = 2*abs(X(1:nfft/2+1))/length(x_trimmed);

% Limit the frequency range
freq_range = (frequencies >= 80) & (frequencies <= 400);
magnitude_spectrum = magnitude_spectrum(freq_range);
frequencies = frequencies(freq_range);

% Zero out signals less than 50% of the peak
peak_magnitude = max(magnitude_spectrum);
magnitude_spectrum(magnitude_spectrum < 0.5 * peak_magnitude) = 0;

% Plot the modified frequency domain signal
subplot(2, 1, 2);
plot(frequencies, magnitude_spectrum);
xlabel('Frequency (Hz)');
ylabel('Magnitude');
title('Frequency Domain Signal');
grid on;

% Display the plots

%%
% Load a built-in MATLAB audio file
clear, close all, clc;
% Load a built-in MATLAB audio file
% Load a built-in MATLAB audio file
[x, fs] = audioread('a3.wav');

% Trim or pad the audio to 12 seconds
desired_length = 12; % seconds
x_padded = [x; zeros(round(desired_length * fs) - length(x), size(x, 2))];
num_segments = floor(length(x_padded) / (fs / 2));

% Compute the average amplitude for each 0.5-second interval
average_amplitudes = zeros(num_segments, size(x_padded, 2));
for i = 1:num_segments
    segment_start = (i - 1) * (fs / 2) + 1;
    segment_end = i * (fs / 2);
    average_amplitudes(i, :) = mean(x_padded(segment_start:segment_end, :));
end

% Plot the average amplitude over time
time_intervals = (0.5:0.5:(num_segments * 0.5)) - 0.25; % Adjust for the midpoint of each interval
figure;
plot(time_intervals, average_amplitudes);
xlabel('Time (seconds)');
ylabel('Average Amplitude');
title('Average Amplitude Over 0.5-Second Intervals');
grid on;


