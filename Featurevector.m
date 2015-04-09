classdef Featurevector
    % Featurevector A vector of features represented numerically, extracted from
    % a signal segment.

    properties(SetAccess='private')
        Mean % The mean of the physical quantity of the signal segment
    end
    methods
        function self = Featurevector(featureStruct)
            self.Mean = featureStruct.Mean;
            % TODO for p in properties(fs): self.p = fs.p
        end
    end
end
