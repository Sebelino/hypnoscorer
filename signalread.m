function [eeg,labels] = signalread(recordpath)
    if findstr(recordpath,'slp01a')
        addpath('lib/wfdb-toolbox/mcode/')

        [tm,signal,Fs,siginfo] = rdmat(strcat(recordpath,'m'));
        physicaleeg = signal(:,3);

        eeg = Signal(tm',siginfo(3).Units,physicaleeg);

        [ann,type,subtype,chan,num,comments] = rdann(recordpath,'st');
        annotations = [char([comments{:}]),num2str(ann)];
        labels = char([comments{:}]');
        labels = labels(:,1);
    else if findstr(recordpath,'shhs')
        addpath('lib')

        edfpath = strcat(recordpath,'.edf');
        [hea,record] = edfread(edfpath);
        eegindex = 8;
        physicaleeg = record(eegindex,:)';
        unit = hea.units(8);

        csvpath = [recordpath,'-staging.csv'];
        csv = csvread(csvpath,1);  % Read everything below row 1 (header)
        epochs = csv(:,1);
        epochlength = 30;  % Seconds
        annotations = csv(:,2);
        values_per_epoch = size(physicaleeg,1)/size(csv,1);
        anns = repmat(annotations,1,values_per_epoch)'; anns = anns(:);
        labels = {''}';
        tm = (0:epochlength/values_per_epoch:size(epochs,1)*epochlength);
        eeg = Signal(tm',unit,physicaleeg);
    end
    error(['Cannot decide on a reading method for ',recordpath])
end

