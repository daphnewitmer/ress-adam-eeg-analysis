clear all
params_config_file

files = dir(fullfile(params.paths.ress_trace,'*.set')); 
sprintf('%s\n', files.name)

%% GENERAL SPECIFICATIONS OF THE EXPERIMENT 
filenames = {'P03_B_Locfix_run1+2_S1_2323'}; % comma = test - train

%% GENERAL ANALYSIS CONFIGURATION SETTINGS
cfg = [];                                  % clear the config variable  
cfg.datadir = params.paths.ress_trace;
cfg.model = 'BDM';                         % backward decoding ('BDM') or forward encoding ('FEM')
cfg.raw_or_tfr = 'raw';                    % classify raw or time frequency representations ('tfr')
cfg.nfolds = 1;                            % the number of folds to use
cfg.class_method = 'AUC';             	   % the performance measure to use
cfg.crossclass = 'yes';                    % 'no' = faster but no GAT
cfg.channelpool = 'FREQUENCY';

%% FIRST LEVEL ANALYSES
cfg.filenames = filenames;              % specifies filenames (EEG in this case)
cfg.class_spec{1} = cond_string(params.low_freq_con);     % the first stimulus class
cfg.class_spec{2} =  cond_string(params.high_freq_con);   % the second stimulus class
cfg.outputdir = params.paths.results;                     % output location
adam_MVPA_firstlevel(cfg);                                % run first level analysis

%% PLOT SINGLE SUBJECT RESULTS OF THE HIGH_LOW_FREQUENCY COMPARISON
cfg = [];                                    % clear the config variable
cfg.startdir = params.paths.results;         % path to first level results 
cfg.reduce_dims = 'diag';                    % train and test on the same points
cfg.splinefreq = 11;                         % acts as an 11 Hz low-pass filter
cfg.plotsubjects = true;                     % also plot individual subjects
cfg.channelpool = 'FREQUENCY';
adam_compute_group_MVPA(cfg);                % select EEG_FAM_VS_SCRAMBLED when dialog pops up

%% COMPUTE THE TEMPORAL GENERALIZATION MATRIX OF ALL EEG COMPARISONS
cfg = [];                                    % clear the config variable
cfg.startdir = params.paths.results;          % path to first level results 
cfg.mpcompcor_method = 'cluster_based';      % multiple comparison correction method
cfg.iterations = 250;                        % reduce the number of iterations to save time
mvpa_stats = adam_compute_group_MVPA(cfg);  % select RAW_EEG when dialog pops up
% PLOT THE TEMPORAL GENERALIZATION MATRIX 
cfg = [];                                    % clear the config variable
adam_plot_MVPA(cfg, mvpa_stats);  % actual plotting, combine EEG/MEG results

%% COMPUTE GENERALIZATION ACROSS TIME FOR THE x-x MS TIME WINDOW 
cfg = [];                                    % clear the config variable
cfg.startdir = params.paths.results;          % path to first level results 
cfg.mpcompcor_method = 'cluster_based';      % multiple comparison correction method
cfg.trainlim = [100 250];                    % specify a 250-400 ms interval in the training data
cfg.reduce_dims = 'avtrain';                 % average over that training interval
mvpa_stats = adam_compute_group_MVPA(cfg);  % select RAW_EEG when dialog pops up
% PLOT GENERALIZATION 
cfg = [];                                    % clear the config variable
adam_plot_MVPA(cfg, mvpa_stats);  % actual plotting, combine EEG/MEG results

%% COMPUTE RAW GROUP ERPs FROM THE HIGH_LOW_FREQUENCY FIRST LEVEL ANALYSIS
cfg = [];                                    % clear the config variable
cfg.startdir = params.paths.results; % path to first level results 
cfg.mpcompcor_method = 'cluster_based';      % multiple comparison correction method
cfg.electrode_def = {'P1'};                 % electrode to plot
erp_stats = adam_compute_group_ERP(cfg);     

%% COMPUTE THE DIFFERENCE BETWEEN THE ERPs FROM THE HIGH_LOW_FREQUENCY FIRST LEVEL ANALYSIS
cfg = [];                                    % clear the config variable
cfg.startdir = params.paths.results; % path to first level results 
cfg.mpcompcor_method = 'cluster_based';      % multiple comparison correction method
cfg.electrode_def = {'P1'};                 % electrode to plot
cfg.condition_method = 'subtract';           % compute subtraction of ERP 
erp_stats_dif = adam_compute_group_ERP(cfg); 

%% PLOT THE ERPs AND THEIR DIFFERENCE IN A SINGLE PLOT
cfg = [];                                    % clear the config variable
cfg.singleplot = true;                       % all graphs in a single plot
cfg.line_colors = {[.75 .75 .75] [.5 .5 .5] [0 0 .5]};  % change the colors
adam_plot_MVPA(cfg, erp_stats, erp_stats_dif);   % actual plotting


