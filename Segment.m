classdef Segment < Signal
    % Segment Basically a continuous subset of a signal

    methods
        function self = Segment(time,unit,recording)
            self = self@Signal(time,unit,recording)
        end
        % Extract a set of features
        function features=features(self)
            fs = struct( ...
                'Mean',mean(self.quantity) ...
               ,'Variance',var(self.quantity) ...
               ,'StandardDeviation',std(self.quantity) ...
               ,'Skewness',skewness(self.quantity) ...
               ,'Kurtosis',kurtosis(self.quantity) ...
            );
            features = Featurevector(fs);
        end
    end
end
