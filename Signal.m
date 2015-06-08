classdef Signal
    % Signal Class for processing an arbitarary signal in the form of a set of discrete graph points.

    properties(SetAccess='private')
        Graph % A struct array of (Time,Quantity) pairs
        Unit % The unit of the physical quantity (e.g. mV, Hz, ...)
    end
    methods
        function self = Signal(time,unit,recording)
            cellarray = num2cell([time,recording]);
            self.Graph = cell2struct(cellarray,{'Time','Quantity'},2);
            self.Unit = unit;
            % TODO unit as 3rd argument
            % TODO invariant: struct array sorted by time
            % TODO allow input vectors both in row form and column form
            % TODO PSG?
        end
        function time=time(self)
            % List of all times
            time = [self.Graph.Time]';
        end
        function quantity=quantity(self)
            % List of all quantities sorted by their respective point in time
            quantity = [self.Graph.Quantity]';
        end
        function segments=segment(self,len)
            % Divide the signal into several segments for further analysis
            m = mod([self.Graph.Time]',len);
            timeintervals = accumarray(cumsum([0;diff(m(:))] < 0)+1,m,[],@(x){x});
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
            % TODO default behavior: provide number of segments parameter rather than time
        end
    end
end
