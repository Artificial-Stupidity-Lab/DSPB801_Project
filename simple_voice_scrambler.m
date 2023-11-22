% Load some speech
[d, sr] = audioread('a1.wav');

% Set parameters
segmentSize = round(sr * 0.0005);  % Segment size of 0.0005 seconds

% Perform audio scrambling with segment swapping
[scrambledAudio, segmentOrder] = audioScrambling(d, sr, segmentSize);

% Normalize the audio to avoid clipping during playback
scrambledAudio = scrambledAudio / max(abs(scrambledAudio));

% Listen to the original and scrambled audio using audioplayer
playerOriginal = audioplayer(d, sr);
playerScrambled = audioplayer(scrambledAudio, sr);

disp('Playing Original Audio...');
playblocking(playerOriginal); % Play the original and wait for it to finish
pause;  % Pause briefly between playback
disp('Playing Scrambled Audio...');
playblocking(playerScrambled); % Play the scrambled and wait for it to finish

% Unscramble the audio
unscrambledAudio = audioUnscrambling(scrambledAudio, segmentOrder, segmentSize);

% Normalize the unscrambled audio to avoid clipping during playback
unscrambledAudio = unscrambledAudio / max(abs(unscrambledAudio));

% Listen to the unscrambled audio
playerUnscrambled = audioplayer(unscrambledAudio, sr);

disp('Playing Unscrambled Audio...');
playblocking(playerUnscrambled); % Play the unscrambled and wait for it to finish

% Function to perform audio scrambling with segment swapping
function [scrambledAudio, segmentOrder] = audioScrambling(audio, sr, segmentSize)
    % Verify that the segment size is smaller than the signal length
    if segmentSize >= length(audio)
        error('Segment size is larger than the signal length.');
    end

    % Calculate the number of segments
    numSegments = floor(length(audio) / segmentSize);

    % Initialize scrambled audio
    scrambledAudio = zeros(size(audio));

    % Generate a random permutation for the segment indices
    segmentOrder = randperm(numSegments);

    % Iterate over segments
    for i = 1:numSegments
        % Extract current segment
        segmentStart = (segmentOrder(i) - 1) * segmentSize + 1;
        segmentEnd = segmentStart + segmentSize - 1;

        % Ensure the end index does not exceed the number of array elements
        if segmentEnd > length(audio)
            segmentEnd = length(audio);
        end

        segment = audio(segmentStart:segmentEnd);

        % Place the segment in the shuffled position
        scrambledAudio((i-1) * segmentSize + 1 : i * segmentSize) = segment;
    end
end

% Function to perform audio unscrambling
function unscrambledAudio = audioUnscrambling(scrambledAudio, segmentOrder, segmentSize)
    % Get the number of segments
    numSegments = length(segmentOrder);

    % Initialize unscrambled audio
    unscrambledAudio = zeros(size(scrambledAudio));

    % Iterate over segments
    for i = 1:numSegments
        % Extract current segment from the scrambled audio
        segmentStart = (i - 1) * segmentSize + 1;
        segmentEnd = segmentStart + segmentSize - 1;

        % Ensure the end index does not exceed the number of array elements
        if segmentEnd > length(scrambledAudio)
            segmentEnd = length(scrambledAudio);
        end

        scrambledSegment = scrambledAudio(segmentStart:segmentEnd);

        % Determine the index for the unscrambled segment
        unscrambledIndex = segmentOrder(i);

        % Place the segment in the unscrambled position
        unscrambledAudio((unscrambledIndex - 1) * segmentSize + 1 : unscrambledIndex * segmentSize) = scrambledSegment;
    end
end
