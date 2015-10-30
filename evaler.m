function evaler(record,filename,kernel)
    if ~exist('filename')
        error('Please supply a file name.')
    end

    query = ['load ',record,' | segment 1 | extract'];
    fs = score(query);
    accuracies1 = [];
    accuracies2 = [];
    evaluations1 = [];
    evaluations2 = [];
    e1 = score(fs,['partition 3:1 | select restricted svm ',kernel,' | eval']);
    e2 = score(fs,['organize dbn 20 3 | partition 3:1 | select restricted svm ',kernel,' | eval']);
    accuracies1 = [accuracies1;e1.accuracy];
    accuracies2 = [accuracies2;e2.accuracy];
    evaluations1 = [evaluations1;e1];
    evaluations2 = [evaluations2;e2];
    save(filename,'fs')
    save(filename,'accuracies1','-append')
    save(filename,'accuracies2','-append')
    save(filename,'evaluations1','-append')
    save(filename,'evaluations2','-append')
end

