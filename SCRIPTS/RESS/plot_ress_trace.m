figure('name', EEG.filename)
filt = ones(1, 600)/600;
low = filter(filt, 1, EEG.data(1,:));
high = filter(filt, 1, EEG.data(2,:));

x = [];
y = [];
labels = [];
order = 1;
for i= 1:length(EEG.event)
    if EEG.event(i).type == "1" || EEG.event(i).type == "3"
        if order == 1
            first_y = min([low, high]);
            second_y = max([low, high]);
            order = 2;
        else
            first_y = max([low, high]);
            second_y = min([low, high]);
            order = 1;
        end
        x(end+1) = EEG.times(EEG.event(i).latency);
        y(end+1) = first_y;
        x(end+1) = EEG.times(EEG.event(i).latency);
        y(end+1) = second_y;
        labels(end + 1) = string(EEG.event(i).type);
    end
end

plot(EEG.times, low ,EEG.times, high);
hold on
fill(x, y, [0 0.4470 0.7410], 'FaceAlpha', 0.2, 'LineStyle','none')

if string(labels(1)) == "1"
    label = "6 Hz";
else 
    label = "7.5 Hz";
end
legend(EEG.chanlocs(1).labels, EEG.chanlocs(2).labels, label)

ylim tight
xlim tight
ylabel('Amplitude')
xlabel('Time')
title('RESS Trace')

filename = sprintf("%s\\img\\%s_ress_trace", params.paths.results, extractBefore(EEG.filename, '.set'));
saveas(gcf, filename,'fig');


