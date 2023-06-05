clear all
params_config_file

files = dir(fullfile(params.paths.preprocessed,'*.set')); 

figure(1), clf
for i = 1:length(files)
    EEG = pop_loadset('filename', files(i).name, 'filepath', params.paths.preprocessed);

    %% static power spectrum
    % first take FFT's of every trial, then average     
    hz = linspace(0,EEG.srate,EEG.pnts);
    if numel(size(EEG.data))==3
        pw = mean((2*abs(fft(EEG.data,[],2)/EEG.pnts)).^2,3);
    else
        pw = (2*abs(fft(EEG.data,[] ,2)/EEG.pnts)).^2;
    end

    subplot(5,4, i)
    plot(hz,pw,'linew',2)
    set(gca,'xlim',[5 9], 'ylim', [0 15])
    xlabel('Frequency (Hz)'), ylabel('Power')
    t = strrep(extractBefore(EEG.filename, '.set'),'_','\');
    title(t)

end


files = dir(fullfile(strcat(params.paths.results, 'RESS'),'*.mat')); 
peakfreq1 = params.low_freq;
peakfreq2 = params.high_freq;

figure('Name','frequency 6hz');
for i = 1:length(files)
    load(strcat(params.paths.results, 'RESS\', files(i).name));

    [~,hz1_index] = min(abs(peakfreq1-ress.hz));
    snr1 = ress.snr1(hz1_index);

    xlim = [5 9];
    subplot(4, 5, i)
    plot(ress.hz,ress.snr1,'ro-','linew',1,'markersize',5,'markerface','w')
    set(gca,'xlim',xlim)
    xticks(5:0.5:10);
    axis square
    xlabel('Frequency (Hz)'), ylabel('SNR')
    t = strrep(extractBefore(files(i).name, '.mat'),'_','\');
    title(t) 
end

figure('Name','frequency 7.5hz');
for i = 1:length(files)
    load(strcat(params.paths.results, 'RESS\', files(i).name));
    [~,hz2_index] = min(abs(peakfreq2-ress.hz));
    snr2 = ress.snr2(hz2_index);
    ress.SNR = [snr1 snr2];

    xlim = [5 9];
    subplot(4,5,i)
    plot(ress.hz,ress.snr2,'bo-','linew',1,'markersize',5,'markerface','w')
    set(gca,'xlim',xlim)
    xticks(5:0.5:10);
    axis square
    xlabel('Frequency (Hz)'), ylabel('SNR')
    t = strrep(extractBefore(files(i).name, '.mat'),'_','\');
    title(t)
end