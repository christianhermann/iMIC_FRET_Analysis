function [E] = calculateEFactor(tableDataDonor, tableDataAcceptor, tableDataComplete, bandwith, varargin)
%CALCULATEEFACTOR Calculate the E factor for FRET data
%   [E] = calculateEFactor(tableDataDonor, tableDataAcceptor, tableDataComplete, bandwith) calculates the E factor
%   for FRET data using the provided table data and bandwith value.

%   Inputs:%
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
%   See also RECTINTENSITIES, INDEXWBANDWITH.

% Create input parser
p = inputParser;
% Define optional inputs and their default values
addOptional(p, 'btDF', 0);
addOptional(p, 'btAF', 0);
addOptional(p, 'btAD', 0);
addOptional(p, 'btDA', 0);
addOptional(p, 'bgD', 0);
addOptional(p, 'bgF', 0);
addOptional(p, 'bgA', 0);


% Parse inputs
parse(p,  varargin{:});

% Retrieve input arguments
btDF = p.Results.btDF;
btAF = p.Results.btAF;
btAD = p.Results.btAD;
btDA = p.Results.btDA;
bgD = p.Results.bgD;
bgF = p.Results.bgF;
bgA = p.Results.bgA;

% correct intensities for the provided table data
tableDataDonor = correctIntensities(tableDataDonor, btDF, btDA, btAD, btAF, bgD, bgF, bgA);
tableDataAcceptor = correctIntensities(tableDataAcceptor, btDF, btDA, btAD, btAF, bgD, bgF, bgA);
tableDataComplete = correctIntensities(tableDataComplete, btDF, btDA, btAD, btAF, bgD, bgF, bgA);

fig = figure;
plot(tableDataDonor.Donor, '-o');
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
preDonor = indexWBandwith(dataIndex(1), bandwith);
postDonor = indexWBandwith(dataIndex(2), bandwith);

fig = figure;
plot(tableDataAcceptor.Acceptor, '-o');
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
preAcceptor = indexWBandwith(dataIndex(1), bandwith);
postAcceptor = indexWBandwith(dataIndex(2), bandwith);

fig = figure;
plot(tableDataComplete.FRET, '-o');
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
preComplete = indexWBandwith(dataIndex(1), bandwith);
postComplete = indexWBandwith(dataIndex(2), bandwith);

% Calculate E factor
df = (mean(tableDataDonor.Donor(postDonor)) - mean(tableDataDonor.Donor(preDonor))) / mean(tableDataDonor.Donor(preDonor));
af = (mean(tableDataAcceptor.Donor(postAcceptor)) - mean(tableDataAcceptor.Donor(preAcceptor))) / (mean(tableDataAcceptor.Acceptor(preAcceptor)) - mean(tableDataAcceptor.Acceptor(postAcceptor)));

dDcda = ((mean(tableDataComplete.Donor(postComplete)) - df * mean(tableDataComplete.Donor(preComplete)) - ...
    af * (mean(tableDataComplete.Acceptor(preComplete))  - mean(tableDataComplete.Acceptor(postComplete)))) - ...
    mean(tableDataComplete.Donor(preComplete))) / ...
    (1 - (mean(tableDataComplete.Acceptor(postComplete)) / mean(tableDataComplete.Acceptor(preComplete))));

E = dDcda / (mean(mean(tableDataComplete.Donor(preComplete))) + dDcda);
end