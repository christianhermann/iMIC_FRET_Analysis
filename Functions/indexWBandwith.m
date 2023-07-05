function [bandwithIndex] = indexWBandwith(dataIndex, bandwith)
%INDEXWBANDWITH Generate an index range around a central data index with specified bandwith
%   bandwithIndex = indexWBandwith(dataIndex, bandwith) generates an index range around a central
%   data index, specified by dataIndex, with a specified bandwith. The bandwithIndex is a vector
%   containing the indices from (dataIndex - bandwith) to (dataIndex + bandwith), inclusive.
%
%   Inputs:
%   - dataIndex: The central data index around which the bandwith is generated.
%   - bandwith: The bandwith value that determines the size of the index range.
%
%   Output:
%   - bandwithIndex: A vector containing the index range from (dataIndex - bandwith) to
%     (dataIndex + bandwith), inclusive.
%
%   Example:
%   dataIndex = 10;
%   bandwith = 3;
%   bandwithIndex = indexWBandwith(dataIndex, bandwith);
%
%   See also COLON.

bandwithIndex = (dataIndex - bandwith):(dataIndex + bandwith);
end