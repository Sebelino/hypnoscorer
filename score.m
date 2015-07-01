function stream = score(varargin)
    % cmd A string describing what to do in UNIXy pipeline notation
    % Examples:
    % load slp | segment 3 | extract | select Mean Variance | plot
    % load shh | segment 1 | extract | select Mean Variance | bundle 12RW 34M | keep 0.1
    %          | partition 0.5 | balance | svm | eval | plot
    if nargin == 0
        error('Expected at least one argument.')
    elseif nargin == 1
        cmd = varargin{1};
    elseif nargin == 2
        stream = varargin{1};
        cmd = varargin{2};
    end
    pipeline = strsplit(cmd,'|');
    for filter = pipeline
        tokens = strsplit(strtrim(filter{:}));
        if strcmp(tokens{1},'load')
            recordstr = tokens{2};
            [record,eeg,labels] = readrecord(recordstr);
            stream = struct('eeg',eeg,'labels',labels);
        elseif strcmp(tokens{1},'segment')
            segmentsperannotation = str2num(tokens{2});
            seconds = 30/segmentsperannotation;
            segments = stream.eeg.segment(seconds);
            labels = repmat(stream.labels',1,segmentsperannotation)';
            labeledsegments = arrayfun(@(i){segments(i).label(labels(i))},(1:size(segments,1)));
            labeledsegments = [labeledsegments{:}]';
            stream = labeledsegments;
        elseif strcmp(tokens{1},'extract')
            fs = arrayfun(@(s){s.features},stream);
            fs = [fs{:}]';
            stream = fs;
        elseif strcmp(tokens{1},'select')
            features = tokens(2:end);
            sfs = arrayfun(@(f){f.select(features{:})},stream);
            sfs = [sfs{:}]';
            stream = sfs;
        elseif strcmp(tokens{1},'partition')
            ratio = str2num(tokens{2});
            trainingindices = randperm(size(stream,1),ratio*size(stream,1))';
            testindices = setdiff(1:size(stream,1),trainingindices)';
            trainedfs = stream(trainingindices);
            testedfs = stream(testindices);
            stream = struct('trainingset',trainedfs,'testset',testedfs);
        elseif strcmp(tokens{1},'bundle')
            bundles = tokens(2:end);
            newlabel = 'A';
            for bundle = bundles
                indices = ismember([stream.Label],bundle{:})';
                newlabels = num2cell(repmat(newlabel,1,size(indices,1)));
                [stream(indices).Label] = newlabels{:};
                newlabel = char(newlabel+1);
            end
        elseif strcmp(tokens{1},'keep')
            % Keep a certain random share of the stream and discard the rest
            ratio = str2num(tokens{2});
            indices = randperm(size(stream,1),ratio*size(stream,1));
            stream = stream(indices);
        elseif strcmp(tokens{1},'balance')
            if isa(stream,'LabeledFeaturevector')
                % Make the number of vectors belonging to a label constant
                partition = stream.partition();
                cardinality = min(cellfun(@(p)(size(p,2)),partition.values));
                newstream = [];
                for part = partition.values
                    indices = randperm(size(part{:},2),cardinality);
                    newpart = part{:};
                    newpart = newpart(indices);
                    newstream = [newpart,newstream];
                end
                stream = newstream';
            elseif isfield(stream,'trainingset')
                % Make the number of training vectors belonging to a label constant
                partition = stream.trainingset.partition();
                cardinality = min(cellfun(@(p)(size(p,2)),partition.values));
                newset = [];
                for part = partition.values
                    indices = randperm(size(part{:},2),cardinality);
                    newpart = part{:};
                    newpart = newpart(indices);
                    newset = [newpart,newset];
                end
                stream.trainingset = newset';
            end
        elseif strcmp(tokens{1},'pca')
            continue
        elseif strcmp(tokens{1},'plot')
            if isa(stream,'LabeledFeaturevector')
                vs = [stream.Vector]';
                features = fieldnames(vs);
                xaxis = [vs.(features{1})]';
                yaxis = [vs.(features{2})]';
                labels = [stream.Label]';
                figure
                whitebg(1,'k')
                gscatter(xaxis,yaxis,labels)
                xlabel(features{1})
                ylabel(features{2})
            elseif isfield(stream,'trainingset') && isfield(stream,'testset')
                figure
                whitebg(1,'k')
                plot(stream.trainingset,{})
                hold on
                plot(stream.testset,{'','+','','off'})
                if isfield(stream,'predictedset')
                    pfs = stream.predictedset;
                    pfs = arrayfun(@(i){LabeledFeaturevector(pfs(i).Vector,pfs(i).Label)},(1:size(pfs,1)));
                    pfs = [pfs{:}]';
                    diff = [pfs.Label]'-[stream.testset.Label]';
                    indices = find(diff);
                    pfs = pfs(indices);
                    plot(pfs,{'y','o','','off'})
                end
            end
            if isfield(stream,'svm')
                stream.svm.plot()
            end
            return
        elseif strcmp(tokens{1},'svm')
            stream.svm = SVM(stream.trainingset);
        elseif strcmp(tokens{1},'eval')
            stream.predictedset = stream.svm.predict(stream.testset);
            diff = [stream.predictedset.Label]'-[stream.testset.Label]';
            diff(diff~=0) = 1;
            stream.ratio = 1-sum(diff)/size(diff,1);
        else
            error(['Could not interpret command "',tokens{1},'".'])
        end
    end
end

function plot(labeledfeatureset,style)
    if isempty(labeledfeatureset)
        return
    end
    vs = [labeledfeatureset.Vector]';
    features = fieldnames(vs);
    plotdata = [[vs.(features{1})]',[vs.(features{2})]',double([labeledfeatureset.Label]')];
    plotdata = sortrows(plotdata,3);
    gscatter(plotdata(:,1),plotdata(:,2),char(plotdata(:,3)),style{:})
    xlabel(features{1})
    ylabel(features{2})
end

function [record,eeg,labels] = readrecord(spec)
    % Reads the record specified by the supplied parameter.
    datadir = 'data/';
    records = {
    'slp01a/slp01a',
    'shhs/shhs1-200001'
    }; % TODO cache this data
    matches = strfind(records,spec);
    matchindices = find(cellfun(@(y)(length(y) == 2),matches));
    record = records{1};
    if length(matchindices) > 0
        record = records{matchindices(1)};
    end
    cachepath = cachepath(record);
    if exist(cachepath)
        disp(['Reading ',cachepath,'...'])
        data = load(cachepath,'eeg','labels');
        eeg = data.eeg;
        labels = data.labels;
    else
        recordpath = [datadir,record];
        disp(['Reading ',recordpath,'...'])
        [eeg,labels] = readsignal(recordpath);
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
