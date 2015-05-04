[eeg,labels] = signalread('data/slp01a/slp01a');

segmentsperannotation = 1;
ss = eeg.segment(30/segmentsperannotation);

fs = arrayfun(@(s){s.features},ss);
fs = [fs{:}]';

% Feature selection
sfs = arrayfun(@(f){f.select('Mean','Variance','StandardDeviation','Skewness','Kurtosis')},fs);
sfs = [sfs{:}]';

% PCA
cfs = sfs.pca;

efs = cfs; % Unsupervised processing here

clear tm signal Fs siginfo physicaleeg eeg ss fs sfs

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

