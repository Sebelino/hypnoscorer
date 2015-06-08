classdef Hypnoscorer
    properties
        Labels
        SegmentsPerAnnotation = 3
        Segments % Memory heavy
        Featurespace
        SelectedFeaturespace
        TransformedFeaturespace
        ExtendedFeaturespace
        Bilabels
    end

    methods
        function self = Hypnoscorer(varargin)
            datadir = 'data/';
            records = {
            'slp01a/slp01a',
            'shhs/shhs1-200001'
            };
            record = records{1};
            if nargin > 0
                substr = varargin{1};
                matches = strfind(records, substr);
                matchindices = find(cellfun(@(y)(length(y) == 2), matches));
                record = records{1};
                if length(matchindices) > 0
                    record = records(matchindices(1));
                end
            end
            [eeg,self.Labels] = signalread([datadir,record]);
            self.Segments = eeg.segment(30/self.SegmentsPerAnnotation);
            clear eeg

            self.Featurespace = arrayfun(@(s){s.features},self.Segments);
            self.Featurespace = [self.Featurespace{:}]';

            % Feature selection
            self.SelectedFeaturespace = arrayfun(@(f){f.select('Mean','Variance','StandardDeviation','Skewness','Kurtosis')},self.Featurespace);
            self.SelectedFeaturespace = [self.SelectedFeaturespace{:}]';

            % PCA
            self.TransformedFeaturespace = self.SelectedFeaturespace.pca(2);

            self.ExtendedFeaturespace = self.TransformedFeaturespace; % Unsupervised processing here

            self.Labels = repmat(self.Labels,1,self.SegmentsPerAnnotation)';
            self.Labels = self.Labels(:);
            %self.Labels = self.Labels(ismember(self.Labels,'WR1234'));
            %self.Labels(self.Labels == 'M') = '4';
            self.Bilabels = self.Labels;
            self.Bilabels(ismember(self.Labels,['4','3','M'])) = 'D';
            self.Bilabels(ismember(self.Labels,['1','2','R','W'])) = 'S';
        end
        function plot3D(self)
            plot3D(self.ExtendedFeaturespace,self.Labels)
        end
        function animate(self)
            animate()
        end
        function svm(self)
            indices = find(ismember(self.Labels,['W','4']));
            self.Labels = self.Labels(indices);
            self.ExtendedFeaturespace = self.ExtendedFeaturespace(indices);

            plot2D(self.ExtendedFeaturespace,self.Labels)

            svm = SVM(self.ExtendedFeaturespace,self.Labels);
            hold on
            svm.plot()
        end
    end
end
