% Read the audio file
clear, close all, clc;
[audioIn, Fs] = audioread('a1.wav');

% Specify the pitch shift in semitones
pitchShift = 10; % Positive values raise the pitch, negative values lower it

% Perform pitch shifting
audioOut = shiftPitch(audioIn, pitchShift);

% Plot the FFT of the original and altered audio in the specified frequency range
figure;

% Original audio FFT
subplot(2, 1, 1);
plotFFT(audioIn, Fs, 'Original Audio FFT', [50, 1000]);

% Altered audio FFT
subplot(2, 1, 2);
plotFFT(audioOut, Fs, 'Altered Audio FFT', [50, 1000]);

% Write the pitch-shifted audio to a new file
audiowrite('pitchShifted.wav', audioOut, Fs);

% Play the pitch-shifted audio
sound(audioOut, Fs);

% Function to plot the FFT of audio in a specified frequency range
function plotFFT(audio, Fs, titleText, frequencyRange)
    N = length(audio);
    f = linspace(0, Fs, N);

    % Calculate the FFT
    fftResult = abs(fft(audio));

    % Plot the FFT in the specified frequency range
    plot(f(1:N/2), 2/N * fftResult(1:N/2), 'LineWidth', 1.5);
    
    title(titleText);
    xlabel('Frequency (Hz)');
    ylabel('Amplitude');
    grid on;

    % Limit x-axis range to the specified frequency range
    xlim(frequencyRange);
end
