
addpath('lib/wfdb-toolbox/mcode/')

recordpath = 'data/slp01a/slp01a';
[tm,signal,Fs,siginfo] = rdmat(strcat(recordpath,'m'));
physicaleeg = signal(:,3);

eeg = Signal(tm',siginfo(3).Units,physicaleeg);
ss = eeg.segment(30);

sfs = arrayfun(@(s){s.features.select},ss);
sfs = [sfs{:}]';


[ann,type,subtype,chan,num,comments] = rdann(recordpath,'st');
annotations = [char([comments{:}]),num2str(ann)];
labels = arrayfun(@(a)(ismember('W',a)),[comments{:}]');
