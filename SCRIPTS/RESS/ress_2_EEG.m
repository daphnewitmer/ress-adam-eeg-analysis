%% RESS to EEGLab

% edit the following fields in the EEG data structure to create an EEG
% dataset with only 2 channels corresponding to the RESS data

EEG.filepath = params.paths.ress_trace;
EEG.nbchan = 2;
EEG.data(1,:) = ress.ts1';
EEG.data(2,:) = ress.ts2';
EEG.data(3:end,:) = [];
chanlocs = struct('labels', { '6hz' '7.5hz'});
EEG.chanlocs = pop_chanedit( chanlocs );
% plot_ress_trace;
EEG = epoch_data(EEG, params, 'NaN', true); % to input in ADAM
pop_saveset(EEG,'filename', EEG.filename, 'filepath', EEG.filepath);