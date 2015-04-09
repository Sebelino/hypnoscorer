classdef Segment < Signal
    methods
        function self = Segment(time,unit,recording)
            self = self@Signal(time,unit,recording)
        end
    end
end
