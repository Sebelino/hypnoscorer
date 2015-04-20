addpath('lib/wfdb-toolbox/mcode/')

recordpath = 'data/slp01a/slp01a';
[tm,signal,Fs,siginfo] = rdmat(strcat(recordpath,'m'));
physicaleeg = signal(:,3);

eeg = Signal(tm',siginfo(3).Units,physicaleeg);
segmentsperannotation = 1;
ss = eeg.segment(30/segmentsperannotation);

fs = arrayfun(@(s){s.features},ss);
fs = [fs{:}]';

fm = [fs.Vector]';
fm = [fm.Mean;fm.Variance;fm.StandardDeviation;fm.Skewness;fm.Kurtosis]';
covariance = cov(fm);
[V,D] = eigs(covariance,2);

sfs = arrayfun(@(f){f.select},fs);
sfs = [sfs{:}]';

efs = sfs; % Unsupervised processing here

clear tm signal Fs siginfo physicaleeg eeg ss fs sfs

[ann,type,subtype,chan,num,comments] = rdann(recordpath,'st');
annotations = [char([comments{:}]),num2str(ann)];
labels = char([comments{:}]');
labels = labels(:,1);
labels = repmat(labels,1,segmentsperannotation)';
labels = labels(:);
%labels = labels(ismember(labels,'WR1234'));
%labels(labels == 'M') = '4';

%plot3D(efs,labels)
%animate()

%svm = SVM()
%svm.train(efs,)

