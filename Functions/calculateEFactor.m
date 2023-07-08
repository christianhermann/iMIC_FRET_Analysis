function [E] = calculateEFactor(tableDataDonor, tableDataAcceptor, tableDataComplete, bandwith, varargin)
%CALCULATEEFACTOR Calculate the E factor for FRET data
%   [E] = calculateEFactor(tableDataDonor, tableDataAcceptor, tableDataComplete, bandwith) calculates the E factor
%   for FRET data using the provided table data and bandwith value.
%
%   Inputs:
%   - tableDataDonor: Table data for the donor channel.
%   - tableDataAcceptor: Table data for the acceptor channel.
%   - tableDataComplete: Complete table data with both donor and acceptor channels.
%   - bandwith: Bandwidth value for index calculations.
%
%   Outputs:
%   - E: The calculated E factor.
%
%   Example:
%   E = calculateEFactor(tableDataDonor, tableDataAcceptor, tableDataComplete, 5);
%
%   See also CORRECTINTENSITIES, INDEXWBANDWITH.

% Create input parser
p = inputParser;
% Define optional inputs and their default values
addOptional(p, 'btDF', 0);
addOptional(p, 'btAF', 0);
addOptional(p, 'btAD', 0);
addOptional(p, 'btDA', 0);

% Parse inputs
parse(p,  varargin{:});

% Retrieve input arguments
btDF = p.Results.btDF;
btAF = p.Results.btAF;
btAD = p.Results.btAD;
btDA = p.Results.btDA;

% Correct intensities for the provided table data
tableDataDonor = correctIntensities(tableDataDonor, btDF, btDA, btAD, btAF);
tableDataAcceptor = correctIntensities(tableDataAcceptor, btDF, btDA, btAD, btAF);
tableDataComplete = correctIntensities(tableDataComplete, btDF, btDA, btAD, btAF);

fig = figure;
plot(tableData.FRETCor, '-o');
fig.WindowState = 'maximized';

% Select data points using data cursor
for j = 1:2
    shg
    dcm_obj = datacursormode(1);
    set(dcm_obj, 'DisplayStyle', 'window', 'SnapToDataVertex', 'off', 'Enable', 'on')
    waitforbuttonpress
    c_info{j} = getCursorInfo(dcm_obj);
    dataIndex(j) = c_info{j}.DataIndex;
end
close;

% Calculate indices with bandwidth
pre = indexWBandwith(dataIndex(1), bandwith);
post = indexWBandwith(dataIndex(2), bandwith);

% Calculate E factor
df = (mean(tableDataDonor.DonorCor(post)) - mean(tableDataDonor.DonorCor(pre))) / mean(tableDataDonor.DonorCor(pre));
af = (mean(tableDataAcceptor.DonorCor(post)) - mean(tableDataAcceptor.DonorCor(pre))) / (mean(tableDataAcceptor.Acceptor(pre)) - mean(tableDataAcceptor.Acceptor(post)));

dDcda = ((mean(tableDataComplete.DonorCor(post)) - df * mean(tableDataComplete.DonorCor(pre)) - ...
    af * (mean(tableDataComplete.AcceptorCor(pre))  - mean(tableDataComplete.AcceptorCor(post)))) - ...
    mean(tableDataComplete.DonorCor(pre))) / ...
    (1 - (mean(tableDataComplete.AcceptorCor(post)) / mean(tableDataComplete.AcceptorCor(pre))));

E = dDcda / (mean(mean(tableDataComplete.DonorCor(pre))) + dDcda);
end