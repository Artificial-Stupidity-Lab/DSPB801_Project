% Load the saved database
close all, clc;
load('speaker_database.mat');

% Read the new audio file for testing
test_file = 'd4.wav'; % Replace with the path to your test file
[new_voice, fs] = audioread(test_file);

% Set the target duration in seconds for the test voice
target_duration = 12;

% Calculate the target number of samples
target_samples = fs * target_duration;

% Trim or pad audio to reach the target duration
if length(new_voice) < target_samples
    % If the audio is shorter than the target, pad with zeros
    new_voice = [new_voice; zeros(target_samples - length(new_voice), 1)];
else
    % If the audio is longer than the target, trim to the target
    new_voice = new_voice(1:target_samples);
end

% Compute the FFT for the test voice
Y_test = fft(new_voice, target_samples);
magnitude_spectrum_test = abs(Y_test);

% Define the frequency range of interest (80Hz to 400Hz)
frequency_range = [80, 400];

% Find the indices corresponding to the frequency range
indices_of_interest = find((fs * (0:(target_samples-1))/target_samples >= frequency_range(1)) & ...
                           (fs * (0:(target_samples-1))/target_samples <= frequency_range(2)));

% Extract the relevant part of the magnitude spectrum for the test voice
magnitude_spectrum_test_of_interest = magnitude_spectrum_test(indices_of_interest);

% Find the index of the maximum peak in the test audio
[~, max_index_test] = max(magnitude_spectrum_test_of_interest);

% Convert the index to the corresponding frequency
peak_frequency_test = fs * (indices_of_interest(max_index_test) - 1) / target_samples;

% Display the peak frequency for the test voice
disp(['Peak Frequency for Test Voice: ' num2str(peak_frequency_test) ' Hz']);
disp("---------------------------------------");
disp("---------------------------------------");

% Initialize variables for tracking the closest match
min_distance = Inf;
closest_speaker = '';
closest_speaker_index = 0;  % Variable to store the index of the closest speaker

% Create a figure to display the information
figure;
hold on;

% Loop over each speaker in the training data
for k = 1:length(sum_Y_padded)
    % Get the FFT for the current speaker in the training data
    Y_train = sum_Y_padded{k};
    
    % Extract the relevant part of the magnitude spectrum for the training voice
    magnitude_spectrum_train = abs(Y_train(indices_of_interest));
    
    % Find the index of the maximum peak in the training audio
    [~, max_index_train] = max(magnitude_spectrum_train);
    
    % Convert the index to the corresponding frequency
    peak_frequency_train = fs * (indices_of_interest(max_index_train) - 1) / target_samples;
    
    % Calculate the distance (absolute difference) between the test and training peak frequencies
    distance = abs(peak_frequency_test - peak_frequency_train);
    
    % Display the peak frequency for each speaker in the training data
    disp(['Peak Frequency for Speaker ' num2str(k) ': ' num2str(peak_frequency_train) ' Hz']);
    
    
    % Display the difference between the test and training peak frequencies
    disp(['Difference for Speaker ' num2str(k) ': ' num2str(distance) ' Hz']);
    disp("---------------------------------------");
    disp("---------------------------------------");
    
    % Update the closest match if the current speaker is closer
    if distance < min_distance
        min_distance = distance;
        closest_speaker = labels{k};
        closest_speaker_index = k;  % Update the index of the closest speaker
    end
    
    % Plot the information on the figure with clearer markers
    plot(k, peak_frequency_train, '*', 'MarkerSize', 10, 'DisplayName', ['Speaker ' num2str(k)]);
end

% Plot the peak frequency for the test voice with a distinct marker
plot(length(sum_Y_padded) + 1, peak_frequency_test, '*', 'MarkerSize', 10, 'DisplayName', 'Test Voice');

% Set plot labels and legend
xlabel('Speaker');
ylabel('Peak Frequency (Hz)');
title('Peak Frequencies for Test and Training Voices');
legend('show');
grid();

% Display the index of the closest speaker
disp(['Estimated speaker: ' num2str(closest_speaker_index)]);

hold off;
