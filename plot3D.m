function plot3D(featurevectors,labels)
    vs = [featurevectors.Vector]';
    features = fieldnames(vs);
    xaxis = [vs.(features{1})]';
    yaxis = [vs.(features{2})]';
    zaxis = [vs.(features{3})]';
    figure
    whitebg(1,'k')
    h = gscatter(xaxis,yaxis,labels);
    labelset = [h.DisplayName]';
    for k = 1:numel(labelset)
        set(h(k),'ZData',zaxis(labels==labelset(k)));
    end
    xlabel(features{1})
    ylabel(features{2})
    zlabel(features{3})
    view(3)
end

