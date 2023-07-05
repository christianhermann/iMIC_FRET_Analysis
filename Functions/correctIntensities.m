function [tableData] = correctIntensities(tableData, btDF, btDA, btAD, btAF)
%CORRECTINTENSITIES Correct the intensities with the corresponding bleedthrough values
%   tableData = correctIntensities(tableData, btDF, btDA, btAD, btAF) corrects the intensities in
%   the input tableData using the provided bleedthrough values. The corrected intensities are stored
%   in additional columns of the tableData.
%
%   Inputs:
%   - tableData: The input table containing the intensity data.
%   - btDF: The bleedthrough coefficient for FRET channel with respect to the donor channel.
%   - btDA: The bleedthrough coefficient for donor channel with respect to the acceptor channel.
%   - btAD: The bleedthrough coefficient for acceptor channel with respect to the donor channel.
%   - btAF: The bleedthrough coefficient for acceptor channel with respect to the FRET channel.
%
%   Output:
%   - tableData: The updated table containing the corrected intensities.
%
%   Example:
%   tableData = correctIntensities(tableData, 0.1, 0.2, 0.3, 0.4);
%
%   See also TABLE.

% Calculate the corrected intensities
DonorCor = (tableData.Donor - btAD * tableData.Acceptor) / (1 - btDA * btAD);
AcceptorCor = (tableData.Acceptor - btDA * tableData.Donor) / (1 - btDA * btAD);
FRETCor = tableData.FRET - btDF * DonorCor - btAF * AcceptorCor;

% Add the corrected intensities as new columns in the table
tableData.Donor = DonorCor;
tableData.Acceptor = AcceptorCor;
tableData.FRET = FRETCor;
end