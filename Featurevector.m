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
        function featurevector = select(self,varargin)
            % Reduce the dimension, selecting only the most relevant features
            vector = self.Vector;
            filteredfields = varargin;
            if length(filteredfields) == 0
                filteredfields = fieldnames(self.Vector);
            end
            for f = setdiff(fieldnames(self.Vector),filteredfields)
                vector = rmfield(vector,f);
            end
            featurevector = Featurevector(vector);
        end
        function components = pca(self, numberofcomponents)
            m = self.matrix();
            normalized = (m-repmat(min(m),size(m,1),1))./repmat(max(m)-min(m),size(m,1),1);
            [coeff score latent] = princomp(normalized);
            components = num2cell(score(:,1:numberofcomponents),2);
            if numberofcomponents == 2
                components = arrayfun(@(v){Featurevector(struct('PC1', v{1}(1), 'PC2', v{1}(2)))},components);
            elseif numberofcomponents == 3
                components = arrayfun(@(v){Featurevector(struct('PC1', v{1}(1), 'PC2', v{1}(2), 'PC3', v{1}(3)))},components);
            end
            components = [components{:}]';
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
