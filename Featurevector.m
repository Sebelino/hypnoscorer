classdef Featurevector
    % Featurevector A vector of features represented numerically, extracted from
    % a signal segment.

    properties(SetAccess='private')
        Mean % Mean of the physical quantity of the signal segment
        Variance % Variance of the physical quantity of the signal segment
        StandardDeviation % Standard deviation of the physical quantity of the signal segment
        Skewness % Skewness of the physical quantity of the signal segment
        Kurtosis % Kurtosis of the physical quantity of the signal segment
        %Mode % Mode of the physical quantity of the signal segment
    end
    methods
        function self = Featurevector(featureStruct)
            features = fieldnames(self);
            for i = 1:self.dimension
                self.(features{i}) = featureStruct.(features{i})
            end
        end
        function count = dimension(self)
            count = numel(fieldnames(self))
        end
    end
end
