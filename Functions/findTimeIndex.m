function index = findTimeIndex(timeData, timePoint)
    % findTimeIndex Finds the index in the timeData vector that is closest to the given timePoint.
    %   index = findTimeIndex(timeData, timePoint) returns the index in the timeData vector that is
    %   closest to the specified timePoint.
    %
    %   Inputs:
    %   - timeData: The vector of time data.
    %   - timePoint: The target time point.
    %
    %   Output:
    %   - index: The index in the timeData vector that is closest to the timePoint.
    
    [~, index] = min(abs(timeData - timePoint));
end