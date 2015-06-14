classdef Hypnoscorer
    properties
        Record
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
            tic
            [self.Record,eeg,self.Labels] = Hypnoscorer.readrecord(varargin);
            self.Segments = eeg.segment(30/self.SegmentsPerAnnotation);
            clear eeg

            self.Featurespace = arrayfun(@(s){s.features},self.Segments);
            self.Featurespace = [self.Featurespace{:}]';

            % Feature selection
            self.SelectedFeaturespace = arrayfun(@(f){f.select('Mean','Variance','StandardDeviation','Skewness','Kurtosis')},self.Featurespace);
            self.SelectedFeaturespace = [self.SelectedFeaturespace{:}]';

            % PCA
            self.TransformedFeaturespace = self.SelectedFeaturespace.pca(3);

            self.ExtendedFeaturespace = self.TransformedFeaturespace; % Unsupervised processing goes here

            self.Labels = repmat(self.Labels,1,self.SegmentsPerAnnotation)';
            self.Labels = self.Labels(:);
            %self.Labels = self.Labels(ismember(self.Labels,'WR1234'));
            %self.Labels(self.Labels == 'M') = '4';
            self.Bilabels = self.Labels;
            self.Bilabels(ismember(self.Labels,['4','3','M'])) = 'D';
            self.Bilabels(ismember(self.Labels,['1','2','R','W'])) = 'S';
            toc
        end
        function plot2D(self)
            plot2D(self.ExtendedFeaturespace,self.Labels)
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
    methods(Static, Access=private)
        function [record,eeg,labels] = readrecord(spec)
            % Reads the record specified by the supplied parameter.
            datadir = 'data/';
            records = {
            'slp01a/slp01a',
            'shhs/shhs1-200001'
            }; % TODO cache this data
            record = records{1};
            if size(spec,2) == 1
                substr = spec{1};
                matches = strfind(records, substr);
                matchindices = find(cellfun(@(y)(length(y) == 2), matches));
                record = records{1};
                if length(matchindices) > 0
                    record = records{matchindices(1)};
                end
            end
            cachepath = Hypnoscorer.cachepath(record);
            if exist(cachepath)
                disp(['Reading ',cachepath,'...'])
                data = load(cachepath,'eeg','labels');
                eeg = data.eeg;
                labels = data.labels;
            else
                recordpath = [datadir,record];
                disp(['Reading ',recordpath,'...'])
                [eeg,labels] = Hypnoscorer.readsignal(recordpath);
                save(cachepath,'eeg','labels');
            end
        end
        function path = cachepath(record)
            % Returns the path to the file caching the record.
            path = ['cache/',strrep(record,'/','.'),'.mat'];
        end
        function [eeg,labels] = readsignal(recordpath)
            % Reads the record from the file specified by the path.
            if findstr(recordpath,'slp01a')
                addpath('lib/wfdb-toolbox/mcode/')

                [tm,signal,Fs,siginfo] = rdmat(strcat(recordpath,'m'));
                physicaleeg = signal(:,3);

                eeg = Signal(tm',siginfo(3).Units,physicaleeg);

                [ann,type,subtype,chan,num,comments] = rdann(recordpath,'st');
                annotations = [char([comments{:}]),num2str(ann)];
                labels = char([comments{:}]');
                labels = labels(:,1);
            elseif findstr(recordpath,'shhs')
                addpath('lib')

                edfpath = strcat(recordpath,'.edf');
                [hea,record] = edfread(edfpath);
                eegindex = 8;
                physicaleeg = record(eegindex,:)';
                clear record
                unit = hea.units(8);

                csvpath = [recordpath,'-staging.csv'];
                csv = csvread(csvpath,1);  % Read everything below row 1 (header)
                epochs = csv(:,1);
                epochlength = 30;  % Seconds
                annotations = csv(:,2);
                values_per_epoch = size(physicaleeg,1)/size(csv,1);
                labels = repmat('_',size(annotations,1),1);
                stagemap = {[0 'W'] [1 '1'] [2 '2'] [3 '3'] [4 '4'] [5 'R'] [6 'M'] [9 'X']};
                for row=stagemap
                    key = row{1}(1); value = row{1}(2);
                    labels(annotations==key) = value;
                end
                tm = (0:epochlength/values_per_epoch:size(epochs,1)*epochlength);
                tm = tm(1:size(physicaleeg,1));
                eeg = Signal(tm',unit,physicaleeg);
            else
                error(['Cannot decide on a reading method for ',recordpath])
            end
        end
    end
end
