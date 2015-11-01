function listresults
    files = matfiles();

    a_lin_accuracies = [];
    a_rbf_accuracies = [];
    b_lin_accuracies = [];
    b_rbf_accuracies = [];
    for i = 1:numel(files)
        load(files{i})
        e1 = evaluations1(1);
        e2 = evaluations2(1);

        c1 = e1.confusionmatrix;
        c1 = c1./repmat(sum(c1,2),1,size(c1,1));
        o1 = strjoin(num2cell(e1.confusionorder));
        c2 = e2.confusionmatrix;
        c2 = c2./repmat(sum(c2,2),1,size(c2,1));
        o2 = strjoin(num2cell(e2.confusionorder));
        if strfind(files{i},'lin')
            a_lin_accuracies = [a_lin_accuracies e1.accuracy];
            b_lin_accuracies = [b_lin_accuracies e2.accuracy];
        elseif strfind(files{i},'rbf')
            a_rbf_accuracies = [a_rbf_accuracies e1.accuracy];
            b_rbf_accuracies = [b_rbf_accuracies e2.accuracy];
        else
            error('MAT file is not marked lin nor rbf.')
        end

        disp(['Feature selection  | ' strjoin(e1.testingset.features)])
        disp(['Enhanced selection | ' strjoin(e2.testingset.features)])
        disp(['Accuracy           | ' num2str(e1.accuracy)])
        disp(['Enhanced accuracy  | ' num2str(e2.accuracy) ' (' num2str(100*e2.accuracy/e1.accuracy-100) ' %)'])
        disp( 'Confusion matrix   | ')
        printmat(c1,'',o1,o1)
        fprintf('\n')
    end
    a_lin_mean_estimate = mean(a_lin_accuracies);
    a_rbf_mean_estimate = mean(a_rbf_accuracies);
    b_lin_mean_estimate = mean(b_lin_accuracies);
    b_rbf_mean_estimate = mean(b_rbf_accuracies);
    a_lin_std_estimate = std(a_lin_accuracies);
    a_rbf_std_estimate = std(a_rbf_accuracies);
    b_lin_std_estimate = std(b_lin_accuracies);
    b_rbf_std_estimate = std(b_rbf_accuracies);
    disp(['Average accuracy of A, linear | ',num2str(a_lin_mean_estimate),' +-~ ',num2str(a_lin_std_estimate)])
    disp(['Average accuracy of B, linear | ',num2str(b_lin_mean_estimate),' +-~ ',num2str(b_lin_std_estimate)])
    disp(['Average accuracy of A, RBF    | ',num2str(a_rbf_mean_estimate),' +-~ ',num2str(a_rbf_std_estimate)])
    disp(['Average accuracy of B, RBF    | ',num2str(b_rbf_mean_estimate),' +-~ ',num2str(b_rbf_std_estimate)])
    d_lin = sqrt(a_lin_std_estimate^2/numel(a_lin_accuracies)+b_lin_std_estimate^2/numel(b_lin_accuracies));
    d_rbf = sqrt(a_rbf_std_estimate^2/numel(a_rbf_accuracies)+b_rbf_std_estimate^2/numel(b_rbf_accuracies));
    u_lin = (b_lin_mean_estimate-a_lin_mean_estimate)/d_lin;
    u_rbf = (b_rbf_mean_estimate-a_rbf_mean_estimate)/d_rbf;
    significance95 = norminv(1-0.05/2);
    if abs(u_lin) < significance95
        disp([num2str(-significance95),' < ',num2str(u_lin),' < ',num2str(significance95)])
        disp('Insignificant result --> no conclusion can be made.')
    else
        disp(['u_lin = ',num2str(u_lin),' --> SIGNIFICANCE!!!!!!!!!!!1111111111111'])
    end
    if abs(u_rbf) < significance95
        disp([num2str(-significance95),' < ',num2str(u_rbf),' < ',num2str(significance95)])
        disp('Insignificant result --> no conclusion can be made.')
    else
        disp(['u_rbf = ',num2str(u_rbf),' --> SIGNIFICANCE!!!!!!!!!!!1111111111111'])
    end
end

function filenames = matfiles
    f = dir('.');
    r = regexpi({f.name},'.*\.mat','match');
    filenames = [r{:}];
end
