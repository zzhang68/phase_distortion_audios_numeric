clear;clc;
% available conditions
% noisy for now (reverb avai)
condition = {'Noisy','Noisy-enhanced','NoisyTraining'};
% low-pass filter for anchor signal
FilterSpec1 = fdesign.lowpass('N,Fc,Ap,Ast',50,2000,0.1,70,16000);  % fc = 2000 Hz, fs = 16000 Hz
FilterObj_anchor = design(FilterSpec1,'equiripple');

for i = 1:3 % i for conditions
    % specify path
    audioPath = ['.\Audios\',condition{i},'\Phase1\']; % load in phase distorted files
    audioDir = dir(audioPath);
    audioDir = audioDir(~ismember({audioDir.name},{'.','..'})); % Get rid of '.' and '..' in dir
    files = sort({audioDir.name}); % sort to make order consistent, numeric values will follow this order
    
    cleanPath = ['.\Audios\',condition{i},'\Clean\'];
    phasePath2 = ['.\Audios\',condition{i},'\Phase2\'];
    phasePath3 = ['.\Audios\',condition{i},'\Phase3\'];
    phasePath4 = ['.\Audios\',condition{i},'\Phase4\'];
    
    % outpath for wavs
    outPath_clean = ['.\Audios_numeric\',condition{i},'\Clean\'];
    outPath_anchor = ['.\Audios_numeric\',condition{i},'\Anchor\'];
    outPath_phase1 = ['.\Audios_numeric\',condition{i},'\Phase1\'];
    outPath_phase2 = ['.\Audios_numeric\',condition{i},'\Phase2\'];
    outPath_phase3 = ['.\Audios_numeric\',condition{i},'\Phase3\'];
    outPath_phase4 = ['.\Audios_numeric\',condition{i},'\Phase4\'];
    
    for idx = 1:length(files)
        audioFile = files{idx}; % Get audio Name (Phase 1)
        % find clean file
        tmp_file = getFileName(audioFile);
        cleanfile = [tmp_file,'.wav'];
        % read clean file
        [clean,fs] = audioread([cleanPath,cleanfile]);
        % generate low-pass anchor
        anchor = FilterObj_anchor.filter(clean); % The anchor signal @2k Hz
        
        % load phase-distorted file
        phase1 = audioread([audioPath,audioFile]);
        phase2 = audioread([phasePath2,audioFile]);
        phase3 = audioread([phasePath3,audioFile]);
        phase4 = audioread([phasePath4,audioFile]);
        
        % save
        if ~exist(outPath_clean, 'dir')
            mkdir(outPath_clean);
            mkdir(outPath_anchor);
            mkdir(outPath_phase1);
            mkdir(outPath_phase2);
            mkdir(outPath_phase3);
            mkdir(outPath_phase4);
        end
        
        % name in numeric values
        out_filename = [num2str(idx),'.wav'];
        out_filepath_clean = [outPath_clean,out_filename];
        out_filepath_anchor = [outPath_anchor,out_filename];
        out_filepath_phase1 = [outPath_phase1,out_filename];
        out_filepath_phase2 = [outPath_phase2,out_filename];
        out_filepath_phase3 = [outPath_phase3,out_filename];
        out_filepath_phase4 = [outPath_phase4,out_filename];
        
        % save audio files
        audiowrite(out_filepath_clean,clean,fs); % clean
        audiowrite(out_filepath_anchor,anchor,fs); % anchor
        audiowrite(out_filepath_phase1,phase1,fs); % phase distortion 25%
        audiowrite(out_filepath_phase2,phase2,fs); % phase distortion 50%
        audiowrite(out_filepath_phase3,phase3,fs); % phase distortion 75%
        audiowrite(out_filepath_phase4,phase4,fs); % phase distortion 100%
        
    end
end
