function plot3D(featurevectors,labels)
    vs = [featurevectors.Vector]';
    means = [vs.Mean]';
    variances = [vs.Variance]';
    skewnesses = [vs.Skewness]';
    figure
    whitebg(1,'k')
    h = gscatter(means,variances,labels);
    labelset = [h.DisplayName]';
    for k = 1:numel(labelset)
        set(h(k),'ZData',skewnesses(labels==labelset(k)));
    end
    zlabel('skewnesses')
    view(3)
end

