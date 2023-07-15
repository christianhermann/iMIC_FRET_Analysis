function [tableData] = correctIntensities(tableData, btDF, btDA, btAD, btAF, bgD, bgF, bgA)
%CORRECTINTENSITIES Correct the intensities with the corresponding bleedthrough values and background values.
% tableData = correctIntensities(tableData, btDF, btDA, btAD, btAF, bgD, bgF, bgA) corrects the intensities in
% the input tableData using the provided bleedthrough coefficients and background values. The corrected intensities
% are stored in additional columns of the tableData.
%
% Inputs:
% - tableData: The input table containing the intensity data.
% - btDF: The bleedthrough coefficient for the FRET channel with respect to the donor channel.
% - btDA: The bleedthrough coefficient for the donor channel with respect to the acceptor channel.
% - btAD: The bleedthrough coefficient for the acceptor channel with respect to the donor channel.
% - btAF: The bleedthrough coefficient for the acceptor channel with respect to the FRET channel.
% - bgD: The background value for the donor channel.
% - bgF: The background value for the FRET channel.
% - bgA: The background value for the acceptor channel.
%
% Output:
% - tableData: The updated table containing the corrected intensities.
%
% Example:
% tableData = correctIntensities(tableData, 0.1, 0.2, 0.3, 0.4, 100, 200, 50);
%
% See also TABLE.

% Subtract background values
DonorBgCor = tableData.Donor - bgD;
FRETBgCor = tableData.FRET - bgF;
AcceptorBgCor = tableData.Acceptor - bgA;

% Calculate the corrected intensities
DonorCor = (DonorBgCor - btAD * AcceptorBgCor) / (1 - btDA * btAD);
AcceptorCor = (AcceptorBgCor - btDA * DonorBgCor) / (1 - btDA * btAD);
FRETCor = FRETBgCor - btDF * DonorCor - btAF * AcceptorCor;

% Update the table with corrected intensities
tableData.Donor = DonorCor;
tableData.Acceptor = AcceptorCor;
tableData.FRET = FRETCor;
end