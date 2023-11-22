% Specify the file path of the audio file
audioFilePath = 'a1.wav';

% Read the audio file
[y, Fs] = audioread(audioFilePath);

% Create an audioplayer object
player = audioplayer(y, Fs);

% Play the audio
play(player);

