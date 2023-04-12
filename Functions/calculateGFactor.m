function [G] = calculateGFactor(tableData, bandwith, varargin)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

% Create input parser
p = inputParser;
% Define required input
%addRequired(p, 'measurementPlotData', 'savefolder', 'saveName');
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

tableData = correctIntensitys(tableData,btDF,btDA,btAD, btAF);

fig = figure;
plot( tableData.FRETCor,  '-o');
fig.WindowState = 'maximized';

for j = 1:2
    shg
    dcm_obj = datacursormode(1);
    set(dcm_obj,'DisplayStyle','window',...
        'SnapToDataVertex','off','Enable','on')
    waitforbuttonpress
    c_info{j} = getCursorInfo(dcm_obj);
    dataIndex(j) = c_info{j}.DataIndex;
end
close;

dIwB1 = indexWBandwith(dataIndex(1), bandwith);
dIwB2 = indexWBandwith(dataIndex(2), bandwith);
G = (mean(tableData.FRETCor(dIwB1)) - mean(tableData.FRETCor(dIwB2))) / ...
(mean(tableData.FRET(dIwB2)) - mean(tableData.Donor(dIwB1)));

end