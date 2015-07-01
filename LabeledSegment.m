classdef LabeledSegment < Segment
    % LabeledSegment A segment paired with a label

    properties
        Label
    end
    methods
        function self = LabeledSegment(time,unit,recording,label)
            self@Segment(time,unit,recording)
            self.Label = label;
        end
        function labeledfeatures = features(self)
            featurevector = features@Segment(self);
            labeledfeatures = LabeledFeaturevector(featurevector.Vector,self.Label);
        end
    end
end
