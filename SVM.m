classdef SVM < Classifier
    % Signal Support vector machine based classifier.

    properties(SetAccess='private')
        model % The SVM classifier model
    end
    methods
        function self = SVM()
        end
        function train(predictors,labels)
            % Trains a SVM model
        end
    end
end
