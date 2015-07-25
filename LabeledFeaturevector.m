classdef LabeledFeaturevector < Featurevector
    % LabeledFeaturevector A vector of features paired with a label.

    properties
        Label  % E.g. '3' for N3.
    end
    methods
        function self = LabeledFeaturevector(featureStruct,label)
            self@Featurevector(featureStruct);
            self.Label = label;
        end
        function labeledfeaturevector = select(self,varargin)
            fv = select@Featurevector(self,varargin{:});
            labeledfeaturevector = LabeledFeaturevector(fv.Vector,self.Label);
        end
        function tbl = table(self)
            % Displays the feature vectors + labels as strings in a table.
            vs = [self.Vector]';
            vs = num2cell(cell2mat(struct2cell(vs))',1);
            tbl = table(vs{:},[self.Label]');
        end
        function p = partition(self)
            % Returns a map Label -> {Featurevector}.
            labels = unique([self.Label]);
            p = containers.Map();
            for label = labels
                vs = self([self.Label]==label)';
                p(label) = vs;
            end
        end
        function components = pca(self,numberofcomponents)
            fs = pca@Featurevector(self,numberofcomponents);
            labels = [self.Label]';
            for i = 1:size(fs,1)
                lfs(i) = LabeledFeaturevector(fs(i).Vector,labels(i));
            end
            components = lfs';
        end
    end
    methods(Access=protected)
        function pg = getPropertyGroups(self)
            %pg = getPropertyGroups@Featurevector(self);
            if ~isscalar(self)
                pg = getPropertyGroups@matlab.mixin.CustomDisplay(self);
            else
                pg(1) = matlab.mixin.util.PropertyGroup(self.Vector,'Vector');
                pg(2) = matlab.mixin.util.PropertyGroup(self.Label,['Label: ',self.Label]);
            end
        end
    end
end
