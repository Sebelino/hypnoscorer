function plot2D(featurevectors,labels)
    vs = [featurevectors.Vector]';
    means = [vs.Mean]';
    variances = [vs.Variance]';
    figure
    whitebg(1,'k')
    gscatter(means,variances,labels)
end

