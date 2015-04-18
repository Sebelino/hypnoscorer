addpath('lib/wfdb-toolbox/mcode/')

recordpath = 'data/slp01a/slp01a';
[tm,signal,Fs,siginfo] = rdmat(strcat(recordpath,'m'));
physicaleeg = signal(:,3);

eeg = Signal(tm',siginfo(3).Units,physicaleeg);
ss = eeg.segment(30);

sfs = arrayfun(@(s){s.features.select},ss);
sfs = [sfs{:}]';

efs = sfs; % Unsupervised processing here

clear tm signal Fs siginfo physicaleeg eeg ss sfs

[ann,type,subtype,chan,num,comments] = rdann(recordpath,'st');
annotations = [char([comments{:}]),num2str(ann)];
labels = char([comments{:}]');
labels = labels(:,1);
%labels = labels(ismember(labels,'WR1234'));
%labels(labels == 'M') = '4';

plot3D(efs,labels)
animate()

%svm = SVM()
%svm.train(efs,)

