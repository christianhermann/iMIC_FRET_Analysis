function [tableData] = correctIntensities(tableData,btDF,btDA,btAD, btAF)
%correctIntensitys Correct the Intensitys with the corresponding
%bleedthrough values
%   Detailed explanation goes here
DonorCor = (tableData.Donor - btAD * tableData.Acceptor) / (1 - btDA * btAD);
AcceptorCor = (tableData.Acceptor - btDA * tableData.Donor) / (1 - btDA * btAD);
FRETCor = tableData.FRET - btDF * DonorCor - btAF * AcceptorCor;

tableData.DonorCor = DonorCor;
tableData.AcceptorCor = AcceptorCor;
tableData.FRETCor = FRETCor;
end