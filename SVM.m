classdef SVM < Classifier
    % Signal Support vector machine based classifier.

    properties(SetAccess='private')
        Model % The SVM classifier model
    end
    methods
        function self = SVM(labeledfeaturevectors)
            predictormatrix = labeledfeaturevectors.matrix();
            labels = [labeledfeaturevectors.Label]';
            self.Model = fitcsvm(predictormatrix,labels);
        end
        function featureset = predict(self,predictors)
             % Predicts the labels for the given data
             [labels,score] = predict(self.Model,predictors.matrix());
             featureset = arrayfun(@(i){LabeledFeaturevector(predictors(i).Vector,labels(i))},(1:size(labels,1)));
             featureset = [featureset{:}]';
        end
        function plot(self)
            sv = self.Model.SupportVectors;
            % Plot vectors
            plot(sv(:,1),sv(:,2),'s','MarkerEdgeColor',[0.3 0.3 0.3],'MarkerSize',7)
        end
    end
end
