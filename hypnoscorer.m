
recordpath = 'data/slp01a/slp01a';
[tm,signal,Fs,siginfo] = rdmat(strcat(recordpath,'m'));
physicaleeg = signal(:,3);
[ann,type,subtype,chan,num,comments] = rdann(recordpath,'st');

