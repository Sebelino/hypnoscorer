classdef Segment < Signal
    % Segment Basically a continuous subset of a signal

    methods
        function self = Segment(time,unit,recording)
            self = self@Signal(time,unit,recording)
        end
        % Extract a set of features
        function features=features(self)
            features = [mean(self.quantity)];
        end
    end
end
