function [activity,mobility,complexity] = hjorthparameters(graph)
    derivative = diff(graph);
    secondderivative = diff(derivative);
    activity = var(graph);
    mobility = sqrt(var(derivative)/var(graph));
    complexity = sqrt(var(secondderivative)/var(graph));
end
