classdef Featurevector < matlab.mixin.CustomDisplay
    % Featurevector A vector of features represented numerically, extracted from
    % a signal segment.

    properties(SetAccess=private)
        Vector % Struct mapping a feature (e.g. "Mean") to a numerical value (e.g. -0.0222)
    end
    methods
        function self = Featurevector(featureStruct)
            self.Vector = featureStruct;
        end
        function count = dimension(self)
            % The number of features
            count = numel(fieldnames(self));
        end
    end
    methods(Access=protected)
        function displayScalarObject(self)
            % Cosmetic
            className = matlab.mixin.CustomDisplay.getClassNameForHeader(self);
            scalarHeader = [className,' with properties:'];
            header = sprintf('%s\n',scalarHeader);
            disp(header)
            propgroup = getPropertyGroups(self);
            matlab.mixin.CustomDisplay.displayPropertyGroups(self,propgroup);
        end
        function pg = getPropertyGroups(self)
            % Cosmetic
            if ~isscalar(self)
                pg = getPropertyGroups@matlab.mixin.CustomDisplay(self);
            else
                pg(1) = matlab.mixin.util.PropertyGroup(self.Vector,'Vector');
            end
            % TODO Array of vectors of the same type should have format:
            % 1x2 Featurevector array with properties:
            %     Vector(Mean,Variance,Skewness)
        end
    end
end
