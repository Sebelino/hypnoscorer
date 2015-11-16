function exhaustiveevaler
    record = '200001';
    kernel = 'linear';
    fs = score(['load ',record,' | segment 1 | extract']);
    evals = score(fs,['partition 3:1 | select exhaustive svm ',kernel,' | eval']);
    save([record,'-',kernel(1:3),'-exhaustive'],'evals')
end
