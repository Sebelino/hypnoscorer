classdef Featurevector
    % Featurevector A vector of features represented numerically, extracted from
    % a signal segment.

    properties(SetAccess='private')
        Mean % Mean of the physical quantity of the signal segment
        Variance % Variance of the physical quantity of the signal segment
        StandardDeviation % Standard deviation of the physical quantity of the signal segment
        Skewness % Skewness of the physical quantity of the signal segment
        Kurtosis % Kurtosis of the physical quantity of the signal segment
    end
    methods
        function self = Featurevector(featureStruct)
            self.Mean = featureStruct.Mean;
            self.Variance = featureStruct.Variance;
            self.StandardDeviation = featureStruct.StandardDeviation;
            self.Skewness = featureStruct.Skewness;
            self.Kurtosis = featureStruct.Kurtosis;
            % TODO for p in properties(fs): self.p = fs.p
            %features = fieldnames(self);
        end
    end
end
