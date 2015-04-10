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
            count = numel(fieldnames(self));
        end
    end
    methods(Access=protected)
        function displayScalarObject(self)
            className = matlab.mixin.CustomDisplay.getClassNameForHeader(self);
            scalarHeader = [className,' with properties:'];
            header = sprintf('%s\n',scalarHeader);
            disp(header)
            propgroup = getPropertyGroups(self);
            matlab.mixin.CustomDisplay.displayPropertyGroups(self,propgroup);
        end
        function pg = getPropertyGroups(self)
            if ~isscalar(self)
                pg = getPropertyGroups@matlab.mixin.CustomDisplay(self);
            else
                pg(1) = matlab.mixin.util.PropertyGroup(self.Vector,'Vector');
            end
        end
    end
end
