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
        function featurevector = select(self)
            % Reduce the dimension, selecting only the most relevant features
            vector = self.Vector;
            filteredfields = {'Mean' 'Variance','Skewness'}';
            for f = setdiff(fieldnames(self.Vector),filteredfields)
                vector = rmfield(vector,f);
            end
            featurevector = Featurevector(vector);
        end
        function matrix = matrix(self)
            % The set of features in the form of a NxM matrix, where N is the number of vectors and M
            % is the number of features
            matrix = cell2mat(struct2cell([self.Vector]')');
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
