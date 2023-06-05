clear all
params_config_file

files = dir(fullfile(params.paths.preprocessed,'*.set')); 
sprintf('%s\n', files.name)

params.paths.filenames = {'P03_B_SR_run1+2_S1_2433'};

%% load data 
ALLEEG = load_files(params, params.paths.preprocessed, '.set');

for i = 1:length(ALLEEG)
    EEG = ALLEEG(i);
    EEG.data = double(EEG.data);
    EEG = eeg_checkset(EEG);

    BR_compute_RESS_SRS;
    BR_plot_RESS_component;
    ress_2_EEG;
end