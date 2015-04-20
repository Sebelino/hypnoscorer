function plot2D(featurevectors,labels)
    vs = [featurevectors.Vector]';
    features = fieldnames(vs);
    xaxis = [vs.(features{1})]';
    yaxis = [vs.(features{2})]';
    figure
    whitebg(1,'k')
    gscatter(xaxis,yaxis,labels)
    xlabel(features{1})
    ylabel(features{2})
end

