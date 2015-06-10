classdef Signal
    % Signal Class for processing an arbitarary signal in the form of a set of discrete graph points.

    properties(SetAccess='private')
        Header = {'Time','Quantity'}
        Units % The unit of the time and physical quantity (e.g. (s, mV), (s, Hz), ...)
        Graph % A matrix of (Time,Quantity) pairs
    end
    methods
        function self = Signal(time,units,recording)
            self.Graph = [time,recording];
            self.Units = units;
            % TODO unit as 3rd argument
            % TODO invariant: struct array sorted by time
            % TODO allow input vectors both in row form and column form
            % TODO PSG?
        end
        function time=time(self)
            % List of all times
            time = self.Graph(:,1);
        end
        function quantity=quantity(self)
            % List of all quantities sorted by their respective point in time
            quantity = self.Graph(:,2);
        end
        function segments=segment(self,len)
            % Divide the signal into several segments for further analysis
            m = mod(self.time(),len);
            timeintervals = accumarray(cumsum([0;diff(m(:))] < 0)+1,m,[],@(x){x});
            segmentlengths = cellfun(@length,timeintervals);
            segmentindices = cumsum(segmentlengths)-segmentlengths+1;
            for i=1:size(segmentlengths,1)
                segmentgraphs(i) = {self.Graph(segmentindices(i):segmentindices(i)+segmentlengths(i)-1,:)};
            end
            segmentgraphs = segmentgraphs';
            segments = arrayfun(@(p){Segment(p{1}(:,1),self.Units,p{1}(:,2))},segmentgraphs);
            segments = [segments{:}]';
            % TODO default behavior: provide number of segments parameter rather than time
        end
    end
end
