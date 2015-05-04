classdef Segment < Signal
    % Segment Basically a continuous subset of a signal

    methods
        function self = Segment(time,unit,recording)
            self = self@Signal(time,unit,recording);
        end
        % Extract a set of features
        function features=features(self)
            [activity,mobility,complexity] = self.hjorthparameters;
            fs = struct( ...
                'Mean',mean(self.quantity) ...
               ,'Variance',activity ...
               ,'StandardDeviation',std(self.quantity) ...
               ,'Skewness',skewness(self.quantity) ...
               ,'Kurtosis',kurtosis(self.quantity) ...
               ,'HjorthMobility',mobility ...
               ,'HjorthComplexity',complexity ...
            );
            features = Featurevector(fs);
        end
        function [activity,mobility,complexity] = hjorthparameters(self)
            x = self.time;
            y = self.quantity;
            y1 = diff(y)./diff(x);
            x1 = cumsum(diff(x))-diff(x);
            y2 = diff(y1)./diff(x1);
            x2 = cumsum(diff(x1))-diff(x1);
            activity = var(y);
            mobility = sqrt(var(y1)/var(y));
            complexity = sqrt(var(y)*var(y2)/(var(y)^2));
        end
    end
end
