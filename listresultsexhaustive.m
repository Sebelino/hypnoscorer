function listresults
    record = '200001-lin-exhaustive';
    load(record)

    accuracies = [evals.accuracy];
    accuracyhistogram = cell(1,7); % TODO Soft-code
    for i = 1:numel(evals)
        e = evals(i);
        d = numel(e.trainingset.features);
        accuracyhistogram{d} = [accuracyhistogram{d};e.accuracy];
    end
    accuracymeans = cellfun(@(a) mean(a(:)),accuracyhistogram);
    accuracylows = accuracymeans-cellfun(@(a) min(a(:)),accuracyhistogram);
    accuracyhighs = cellfun(@(a) max(a(:)),accuracyhistogram)-accuracymeans;
    plt = bar(accuracymeans);
    hold on
    errorbar((1:7),accuracymeans,accuracylows,accuracyhighs,'xk')
    title('Scorer accuracy in respect to size of feature selection')
    xlabel('Number of features')
    ylabel('Accuracy')
end
