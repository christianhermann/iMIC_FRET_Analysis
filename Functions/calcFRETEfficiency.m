function [FRET_Rel, FRET_Abs, FRET_Bef, FRET_Aft] = calcFRETEfficiency(data, indexWithBandwith1, indexWithBandwith2)
%CALCFRETEFFICIENCY Calculate FRET efficiency
%   [FRET_Rel, FRET_Abs] = calcFRETEfficiency(data, indexWithBandwith1, indexWithBandwith2) calculates
%   the FRET efficiency using the provided data and indices for the bandwidth regions.
%
%   Inputs:
%   - data: The FRET data from which to calculate the efficiency.
%   - indexWithBandwith1: The indices corresponding to the first bandwidth region.
%   - indexWithBandwith2: The indices corresponding to the second bandwidth region.
%
%   Outputs:
%   - FRET_Rel: The relative FRET efficiency, calculated as FRET_Abs / FRET_Bef.
%   - FRET_Abs: The absolute change in FRET intensity, calculated as FRET_Bef - FRET_Aft.
%   - FRET_Bef: The FRET value at the first timepoint
%   - FRET_Aft: The FRET value at the second timepoint
%   Example:
%   [FRET_Rel, FRET_Abs] = calcFRETEfficiency(data, [1:10], [11:20]);
%
%   See also MEAN.

%Check if index is in measurement Data
if max(indexWithBandwith2) > numel(data)
    FRET_Bef = NaN;
    FRET_Aft = NaN;
    FRET_Abs = NaN;
    FRET_Rel = NaN;
    return
end


% Calculate the mean FRET intensity before and after the bandwidth regions
FRET_Bef = mean(data(indexWithBandwith1));
FRET_Aft = mean(data(indexWithBandwith2));

%
% Calculate the absolute and relative FRET efficiency
FRET_Abs = FRET_Bef - FRET_Aft;
FRET_Rel = FRET_Abs / FRET_Bef;
end