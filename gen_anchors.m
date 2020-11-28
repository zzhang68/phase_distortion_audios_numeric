clear;clc;
% available conditions
% noisy for now (reverb avai)
condition = {'Noisy','Noisy-enhanced','NoisyTraining'};
% low-pass filter for anchor signal
FilterSpec1 = fdesign.lowpass('N,Fc,Ap,Ast',50,2000,0.1,70,16000);  % fc = 2000 Hz, fs = 16000 Hz
FilterObj_anchor = design(FilterSpec1,'equiripple');

for i = 1:3 % i for conditions
    % specify path
    audioPath = ['.\Audios\',condition{i},'\Clean\']; % clean speech is the same for all phase conditions
    audioDir = dir(audioPath);
    audioDir = audioDir(~ismember({audioDir.name},{'.','..'})); % Get rid of '.' and '..' in dir
    % outpath for anchor wavs
    outPath = ['.\Audios\',condition{i},'\Anchor\'];
    for idx = 1:length(audioDir)
        audioFile = audioDir(idx).name; % Get audio Name (Phase 1)
        % generate low-pass anchor
        [clean,fs] = audioread([audioPath,audioFile]);
        anchorSig = FilterObj_anchor.filter(clean); % The anchor signal @2k Hz

        % normalize (not for now)
        % anchorSig = anchorSig/rms(anchorSig)*(0.05)*(10^((65-86)/20)); % Calibrate anchor signal's dB SPL
        
        % save
        if ~exist(outPath, 'dir')
            mkdir(outPath);
        end
        outfile = [outPath,audioFile];
        audiowrite(outfile,anchorSig,fs);
        
    end
end
