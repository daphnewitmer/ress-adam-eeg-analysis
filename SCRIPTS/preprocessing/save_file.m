function save_file(EEG, params, timestamp)
    prompt = "Do you want to save the dataset? Y/N [Y]: ";
    save = input(prompt,"s");

    if isempty(save) | contains('YyyesYes', save)
        
        if params.paths.file_type == ".bdf"
            name = sprintf('%s_S%s%s.set', string(EEG.filename), string(params.paths.session(8)), timestamp);
        end 
        if params.paths.file_type == ".set"
            name = EEG.filename;
        end

        pop_saveset( EEG, 'filename', name, 'filepath', strcat(params.paths.preprocessed, params.paths.trial_type));
        text = sprintf('%s\n', string(cellstr(EEG.comments)));
        text = regexprep( text, '\', '\\\');
        
        txt_file = fopen(params.paths.preprocessed + string(params.paths.trial_type) + string(extractBefore(name, '.set')) + '.txt', 'w');
        fprintf(txt_file, text);
        fclose(txt_file);
    end