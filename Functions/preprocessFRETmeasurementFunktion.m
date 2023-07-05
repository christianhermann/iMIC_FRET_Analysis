function preprocessFRETmeasurementFunktion(measurementPlotData, savefolder, saveName, varargin)
%preprocessFRETmeasurementFunktion Summary of this function goes here
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

%Fixed Values
windowSize = 50;
downsampleFrequency = 10;
setto1meanlength = 500;
setto1meanstart = 100;
bandwith = 100;

tableData = downsampleMeasData(measurementPlotData, windowSize, downsampleFrequency);


fig = figure;
plot(tableData.('time (s)'), tableData.Donor,  '-o');
grid on
grid minor
fig.WindowState = 'maximized';


shg
dcm_obj = datacursormode(1);
set(dcm_obj,'DisplayStyle','window',...
    'SnapToDataVertex','off','Enable','on')
waitforbuttonpress
c_info_start = getCursorInfo(dcm_obj);
dataIndex_start = c_info_start.DataIndex;
close;

tableData = tableData(dataIndex_start(1):size(tableData,1),:);
tableData.rawTime = tableData.("time (s)");
tableData.("time (s)") = tableData.("time (s)") - tableData.("time (s)")(1);

fig = figure;
plot( tableData.Donor,  '-o');
grid on
grid minor
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
grid off;
close;

if(dataIndex(1)) < bandwith
    dif = bandwith - dataIndex(1);
    dataIndex(1) = bandwith + 1;
    dataIndex(2) = dataIndex(2)+dif;
end

disp('Calculating....Correction...')


tableData = correctIntensities(tableData,btDF,btDA,btAD, btAF);

disp('Calculating....FRET and norming...')

FRETXia = FRETCor ./ sqrt(tableData.DonorCor .* tableData.AcceptorCor);
tableData.FRETXia = FRETXia;

DonorCorNorm = tableData.DonorCor ./ mean(tableData.DonorCor(setto1meanstart:setto1meanlength));
tableData.DonorCorNorm = DonorCorNorm;

FRETCorNorm = tableData.FRETCor ./ mean(tableData.FRETCor(setto1meanstart:setto1meanlength));
tableData.FRETCorNorm = FRETCorNorm;

AcceptorCorNorm = tableData.AcceptorCor ./ mean(tableData.AcceptorCor(setto1meanstart:setto1meanlength));
tableData.AcceptorCor = AcceptorCorNorm;


disp('Calculating....Bleaching correction...')

dIwB1 = indexWBandwith(dataIndex(1), bandwith);
dIwB2 = indexWBandwith(dataIndex(2), bandwith);

DonorCorNormBleachCor = DonorCorNorm - tableData.("time (s)") *...
    (mean(DonorCorNorm(dIwB1))-mean(DonorCorNorm(dIwB2))) / ...
    (tableData.("time (s)")(dataIndex(2)) - tableData.("time (s)")(dataIndex(1)));
tableData.DonorCorNormBleachCor = DonorCorNormBleachCor;

FRETCorNormBleachCor = FRETCorNorm - tableData.("time (s)") *...
    (mean(FRETCorNorm((dataIndex(2) - bandwith):(dataIndex(2) + bandwith)))...
    -mean(FRETCorNorm((dataIndex(1) - bandwith):(dataIndex(1) + bandwith))))...
    / (tableData.("time (s)")(dataIndex(2)) - tableData.("time (s)")(dataIndex(1)));
tableData.FRETCorNormBleachCor = FRETCorNormBleachCor;

AcceptorCorNormBleachCor = AcceptorCor - tableData.("time (s)") *...
    (mean(AcceptorCor((dataIndex(2) - bandwith):(dataIndex(2) + bandwith)))...
    -mean(AcceptorCor((dataIndex(1) - bandwith):(dataIndex(1) + bandwith))))...
    / (tableData.("time (s)")(dataIndex(2)) - tableData.("time (s)")(dataIndex(1)));
tableData.AcceptorCorNormBleachCor = AcceptorCorNormBleachCor;

RatioFRETCorNormBleachCorDonorCorNormBleachCor = FRETCorNormBleachCor ./DonorCorNormBleachCor;
tableData.RatioFRETCorNormBleachCorDonorCorNormBleachCor = RatioFRETCorNormBleachCorDonorCorNormBleachCor;


tableData = changeTableDataUnits(tableData);

mkdir(fullfile(savefolder));
fullsafeName = fullfile(savefolder, saveName);
writetable(tableData,append(fullsafeName,'.xlsx'));
save(append(fullsafeName,'_processed','.mat'),'tableData');


fig = createFRETplot(tableData, ...
    repelem("time (s)", 4), ...
    ["Donor" "Empty" "FRET" "Acceptor" ], ...
    ["Donor" "Empty" "FRET" "Akzeptor"], ...
    repelem("t (s)", 4), ...
    ["Intensity (µA)" "Intensity (µA)" "Intensity (mV)" "Intensity (mV)"], ...
    saveName);
savePlotFigPng(fig, fullsafeName, "Raw");
close;


disp(append('Finished: ', saveName));
end