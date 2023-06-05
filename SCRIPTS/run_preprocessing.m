clear
params_config_file

params.paths.participant_nr = 'P03/';
params.paths.session = 'Session2/';
params.paths.trial_type = 'localizer/';

files = dir(fullfile(strcat(params.paths.data, params.paths.participant_nr, params.paths.session),'*.bdf')); 
sprintf('%s\n', files.name)

params.paths.filenames = {'P03_B_Locfix_run1', 'P03_B_Locfix_run2'}; 

%% load data 
ALLEEG = load_files(params, params.paths.data, '.bdf'); % load set or bdf files 

for i = 1:length(ALLEEG)
    EEG = ALLEEG(i);
    EEG.data = double(EEG.data);
    EEG = eeg_checkset(EEG);
    disp(strcat('****** Run file:', ALLEEG(1).filename, ' ******'));
    
    %% channel alloc, re-ref, remove ext, high pass fillter, remove begin and end
    EEG = basic_preprocessing(EEG, params);
    
    %% convert condition names: high - low frequency
    EEG = convert_condition_names(EEG, params);
    
    %% remove bad channels
    EEG = remove_data(EEG);
    ALLEEG(i) = EEG;
    disp('******end******');
end

%% concatenate files
EEG = concat_files(ALLEEG, params);

timestamp = string(datetime('now'), '_dhm');

%% inspect data
plot_continuous_data(EEG, params, 1, timestamp);
   
%% epoch data and make plots, it is not saved to EEG atm 
epoch_data(EEG, params, timestamp, false);

%% save in ALLEEG struct and as set file
save_file(EEG, params, timestamp);
