% Load some speech
[d, sr] = audioread('a1.wav');

% Set parameters
windowSize = round(sr * 0.025);  % 25 ms window
overlap = round(sr * 0.0125);    % 50% overlap

% Perform audio scrambling
scrambledAudio = audioScrambling(d, windowSize, overlap);

% Normalize the audio to avoid clipping during playback
scrambledAudio = scrambledAudio / max(abs(scrambledAudio));

% Listen to the original and scrambled audio using audioplayer
playerOriginal = audioplayer(d, sr);
playerScrambled = audioplayer(scrambledAudio, sr);

disp('Playing Original Audio...');
play(playerOriginal);
pause;  % Pause briefly between playback
disp('Playing Scrambled Audio...');
play(playerScrambled);

% Function to perform audio scrambling
function scrambledAudio = audioScrambling(audio, windowSize, overlap)
    % Verify that the window size is smaller than the signal length
    if windowSize >= length(audio)
        error('Window size is larger than the signal length.');
    end

    % Initialize scrambled audio
    scrambledAudio = zeros(size(audio));

    % Calculate the number of frames
    numFrames = floor((length(audio) - overlap) / (windowSize - overlap));

    % Iterate over frames
    for i = 1:numFrames
        % Extract current frame
        frame = audio((i-1)*(windowSize - overlap) + 1 : (i-1)*(windowSize - overlap) + windowSize);

        % Generate a random permutation for the frame indices
        permutation = randperm(length(frame));

        % Shuffle the frame using the permutation
        shuffledFrame = frame(permutation);

        % Overlap-add the shuffled frame into the scrambled audio
        scrambledAudio((i-1)*(windowSize - overlap) + 1 : (i-1)*(windowSize - overlap) + windowSize) = ...
            scrambledAudio((i-1)*(windowSize - overlap) + 1 : (i-1)*(windowSize - overlap) + windowSize) + shuffledFrame;
    end
end
