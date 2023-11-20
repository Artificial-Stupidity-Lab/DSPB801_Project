% Revised Training Script for Speaker Identification
clear, clc, close all;

% Define the list of audio files and corresponding labels for training
audio_files = {'a1.wav', 'a2.wav', 'a3.wav', 'a4.wav', 'a5.wav', ...
               'b1.wav', 'b2.wav', 'b3.wav', 'b4.wav', 'b5.wav', ...
               'c1.wav', 'c2.wav', 'c3.wav', 'c4.wav', 'c5.wav', ...
               'd1.wav', 'd2.wav', 'd3.wav', 'd4.wav', 'd5.wav'};

labels = {'Speaker 1', 'Speaker 1', 'Speaker 1', 'Speaker 1', 'Speaker 1', ...
          'Speaker 2', 'Speaker 2', 'Speaker 2', 'Speaker 2', 'Speaker 2', ...
          'Speaker 3', 'Speaker 3', 'Speaker 3', 'Speaker 3', 'Speaker 3', ...
          'Speaker 4', 'Speaker 4', 'Speaker 4', 'Speaker 4', 'Speaker 4'};

% Initialize variables for FFT accumulation
num_speakers = 4;
sum_Y = cell(1, num_speakers);

% Set the target duration in seconds
target_duration = 12;

% Loop over each file for training
for k = 1:length(audio_files)
    % Read audio file and get sampling rate
    [y, fs] = audioread(audio_files{k});

    % Calculate the target number of samples
    target_samples = fs * target_duration;

    % Trim or pad audio to reach the target duration
    if length(y) < target_samples
        % If the audio is shorter than the target, pad with zeros
        y = [y; zeros(target_samples - length(y), size(y, 2))];
    else
        % If the audio is longer than the target, trim to the target
        y = y(1:target_samples, :);
    end

    % Compute the FFT
    Y = fft(y, target_samples);

    % Determine the speaker index based on the label
    speaker_index = find(strcmp(labels{k}, {'Speaker 1', 'Speaker 2', 'Speaker 3', 'Speaker 4'}));

    % Store the magnitudes of the FFT results
    if isempty(sum_Y{speaker_index})
        sum_Y{speaker_index} = abs(Y);
    else
        sum_Y{speaker_index} = sum_Y{speaker_index} + abs(Y);
    end
end

% Find the maximum length among all audio files
max_length = max(cellfun(@length, sum_Y));

% Pad or trim all FFT results to have the same length
sum_Y_padded = cellfun(@(x) [x; zeros(max_length - length(x), size(x, 2))], sum_Y, 'UniformOutput', false);

% Save the averaged FFT data for later use
save('speaker_database.mat', 'sum_Y_padded', 'labels', 'fs');

% Plot the averaged FFT for each group of speakers in separate plots
for speaker_group = 1:num_speakers
    figure;
    plot(0:max_length-1, abs(sum_Y_padded{speaker_group}));
    xlabel('Frequency (Hz)');
    ylabel('Magnitude');
    title(['Averaged FFT for Speaker Group ' num2str(speaker_group)]);
end
