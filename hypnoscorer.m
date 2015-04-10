
addpath('lib/wfdb-toolbox/mcode/')

recordpath = 'data/slp01a/slp01a';
[tm,signal,Fs,siginfo] = rdmat(strcat(recordpath,'m'));
physicaleeg = signal(:,3);

eeg = Signal(tm',siginfo(3).Units,physicaleeg)
ss = eeg.segment(1)
s = ss(1)
f = s.features

%[ann,type,subtype,chan,num,comments] = rdann(recordpath,'st');
%annotations = [char([comments{:}]),num2str(ann)];
