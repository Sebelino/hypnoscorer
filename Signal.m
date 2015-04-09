classdef Signal
    properties(SetAccess='private')
        Graph
        Unit
    end
    methods
        function self = Signal(time,unit,recording)
            cellarray = num2cell([time,recording]);
            self.Graph = cell2struct(cellarray,{'Time','Quantity'},2);
            self.Unit = unit;
        end
        function time=time(self)
            time = [self.Graph.Time]';
        end
        function quantity=quantity(self)
            quantity = [self.Graph.Quantity]';
        end
        function segments=segment(self,len)
            m = mod([self.Graph.Time]',len);
            timeintervals = accumarray(cumsum([0;diff(m(:))] < 0)+1,m,[],@(x) {x});
            segmentlengths = cellfun(@length,timeintervals);
            segmentindices = cumsum(segmentlengths)-segmentlengths+1;
            quantities = [self.Graph.Quantity]';
            for i=1:size(segmentlengths,1)
                segmentquantities(i) = {quantities(segmentindices(i):segmentindices(i)+segmentlengths(i)-1)};
            end
            segmentquantities = segmentquantities';
            zip = num2cell([timeintervals,segmentquantities],2);
            segments = arrayfun(@(p){Segment(p{1}{1},self.Unit,p{1}{2})},zip);
            segments = [segments{:}]';
        end
        function features=features(self)
            features = [mean(self.quantity)];
        end
    end
end
