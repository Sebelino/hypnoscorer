classdef SVM < Classifier
    % Signal Support vector machine based classifier.

    properties(SetAccess='private')
        Model % The SVM classifier model
    end
    methods
        function self = SVM(predictors,labels)
            predictormatrix = predictors.matrix();
            self.Model = fitcsvm(predictormatrix,labels);
        end
        function train(predictors,labels)
             % Trains a SVM model
        end
        function plot(self)
            sv = self.Model.SupportVectors;
            % Plot vectors
            plot(sv(:,1),sv(:,2),'yo','MarkerSize',5)
            % Plot hyperplane
            w = sum(repmat(self.Model.Alpha,1,2).*sv);
            svcentroid = sum(sv)/size(sv,1);
            bias = w*svcentroid'/w(2);
            xlimits = xlim;
            linex = linspace((3*xlimits(1)+xlimits(2))/4,(xlimits(1)+3*xlimits(2))/4);
            %liney = -w(1)*linex/w(2)-m.Bias;
            liney = -w(1)*linex/w(2)+bias;
            plot(linex,liney)

        end
    end
end
