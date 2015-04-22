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
bilabels = labels;
bilabels(ismember(labels,['4','3','M'])) = 'D';
bilabels(ismember(labels,['1','2','R','W'])) = 'S';

%plot3D(efs,labels)
%animate()

indices = find(ismember(labels,['W','4']));
labels = labels(indices);
efs = efs(indices);

plot2D(efs,labels)

svm = SVM(efs,labels);
hold on
svm.plot()

