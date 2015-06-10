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
    elseif findstr(recordpath,'shhs')
        addpath('lib')

        edfpath = strcat(recordpath,'.edf');
        [hea,record] = edfread(edfpath);
        eegindex = 8;
        physicaleeg = record(eegindex,:)';
        clear record
        unit = hea.units(8);

        csvpath = [recordpath,'-staging.csv'];
        csv = csvread(csvpath,1);  % Read everything below row 1 (header)
        epochs = csv(:,1);
        epochlength = 30;  % Seconds
        annotations = csv(:,2);
        values_per_epoch = size(physicaleeg,1)/size(csv,1);
        labels = repmat('_',size(annotations,1),1);
        stagemap = {[0 'W'] [1 '1'] [2 '2'] [3 '3'] [4 '4'] [5 'R'] [6 'M'] [9 'X']};
        for row=stagemap
            key = row{1}(1); value = row{1}(2);
            labels(annotations==key) = value;
        end
        tm = (0:epochlength/values_per_epoch:size(epochs,1)*epochlength);
        tm = tm(1:size(physicaleeg,1));
        eeg = Signal(tm',unit,physicaleeg);
    else
        error(['Cannot decide on a reading method for ',recordpath])
    end
end

