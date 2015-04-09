classdef Segment < Signal
    methods
        function self = Segment(time,unit,recording)
            self = self@Signal(time,unit,recording)
        end
        function features=features(self)
            features = [mean(self.quantity)];
        end
    end
end
