classdef SVM < Classifier
    % Signal Support vector machine based classifier.

    properties(SetAccess='private')
        Model % Struct mapping two labels (string containing two characters and a leading 'L') to a SVM model
    end
    methods
        % kernel = 'linear' | 'rbf'
        function self = SVM(labeledfeaturevectors,kernel)
            predictormatrix = labeledfeaturevectors.matrix();
            labels = [labeledfeaturevectors.Label]';
            classes = unique(labels);
            self.Model = struct();
            for i = 1:numel(classes)
                label1 = classes(i);
                for j = i+1:numel(classes)
                    label2 = classes(j);
                    key = ['L',label1,label2];
                    indices = [find(labels==label1);find(labels==label2)];
                    m = predictormatrix(indices,:);
                    self.Model.(key) = fitcsvm(m,labels(indices),'KernelFunction',kernel,'KernelScale','auto');
                end
            end
        end
        function featureset = predict(self,predictors)
            % Predicts the labels for the given data
            alllabels = [];
            for f = fieldnames(self.Model)'
                [labels,score] = self.Model.(f{:}).predict(predictors.matrix());
                alllabels = [alllabels,labels];
            end
            %[M,F,C] = mode(uint8(alllabels)'); %TODO
            winnerlabels = mode(alllabels,2);
            featureset = arrayfun(@(i){LabeledFeaturevector(predictors(i).Vector,winnerlabels(i))},(1:size(winnerlabels,1)));
            featureset = [featureset{:}]';
        end
        function plot(self)
            for f = fieldnames(self.Model)
                sv = self.Model.(f{:}).SupportVectors;
                % Plot vectors
                plot(sv(:,1),sv(:,2),'s','MarkerEdgeColor',[0.1 0.1 0.1],'MarkerSize',9,'LineWidth',1)
            end
        end
    end
end
