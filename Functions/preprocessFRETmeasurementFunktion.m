function preprocessFRETmeasurementFunktion(measurementPlotData, savefolder, saveName, varargin)
%UNTITLED2 Summary of this function goes here
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
windowSize = 15;
downsampleFrequency = 15;
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


tableData = correctIntensitys(tableData,btDF,btDA,btAD, btAF);

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


DonorCorNormBleachCor = DonorCorNorm - tableData.("time (s)") *...
    (mean(DonorCorNorm((dataIndex(2) - bandwith):(dataIndex(2) + bandwith)))...
    -mean(DonorCorNorm((dataIndex(1) - bandwith):(dataIndex(1) + bandwith))))...
    / (tableData.("time (s)")(dataIndex(2)) - tableData.("time (s)")(dataIndex(1)));
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


tableData.Donor = tableData.Donor*10^6;
tableData.Empty = tableData.Empty*10^6;
tableData.FRET =  tableData.FRET*10^3;
tableData.Acceptor =  tableData.Acceptor*10^3;
tableData.FRETCor =  tableData.FRET*10^3;


mkdir(fullfile(savefolder));
fullsafeName = fullfile(savefolder, saveName);
writetable(tableData,append(fullsafeName,'.xlsx'));
save(append(fullsafeName,'_processed','.mat'),'tableData');


fig = figure;
fig.Units = 'centimeters';
fig.OuterPosition = [0.25 0.25 10 10];
ax1 = subplot(2,2,1);
plot(tableData.("time (s)"), tableData.Donor,'b')
title("Donor")
xlabel('t (s)')
ylabel('Intensity (µA)')
box off
ax2 = subplot(2,2,2);
plot(tableData.("time (s)"),tableData.Empty, 'b')
xlabel('t (s)')
ylabel('Intensity (µA)')
box off
ax3 = subplot(2,2,3);
plot(tableData.("time (s)"),tableData.FRET, 'g')
title("FRET")
xlabel('t (s)')
ylabel('Intensity (mV)')
box off
ax4 = subplot(2,2,4);
plot(tableData.("time (s)"),tableData.Acceptor, 'g')
xlabel('t (s)')
ylabel('Intensity (mV)')
title("Akzeptor")
box off
sgtitle(sprintf(saveName, '\n Raw'),'Interpreter', 'none', 'FontSize', 10)
savefig(fig,append(fullsafeName,'_Raw.fig'));
exportgraphics(fig,append(fullsafeName,'_Raw.png'),'Resolution',600)
close;

fig = figure;
fig.Units = 'centimeters';
fig.OuterPosition = [0.25 0.25 10 10];
ax1 = subplot(2,2,1);
plot(tableData.("time (s)"), tableData.Donor,'b')
title("Donor")
xlabel('t (s)')
ylabel('Intensity (µA)')
box off
ax2 = subplot(2,2,2);
plot(tableData.("time (s)"),tableData.Acceptor, 'g')
xlabel('t (s)')
ylabel('Intensity (mV)')
title("Akzeptor")
box off
ax3 = subplot(2,2,3);
plot(tableData.("time (s)"),tableData.FRETXia, 'g')
xlabel('t (s)')
ylabel('N_{FRET}')
title("FRET^X^i^a")
box off
sgtitle(sprintf(append(saveName, '\n FRETXia')),'Interpreter', 'none', 'FontSize', 10)
savefig(fig,append(fullsafeName,'_FRETXia.fig'));
exportgraphics(fig,append(fullsafeName,'_FRETXia.png'),'Resolution',600)
close;

fig = figure;
fig.Units = 'centimeters';
fig.OuterPosition = [0.25 0.25 10 10];
ax1 = subplot(2,2,1);
plot(tableData.("time (s)"), tableData.DonorCorNormBleachCor,'b')
title("Donor_{norm}")
xlabel('t (s)')
ylabel('Intensity_{norm}')
box off
ax2 = subplot(2,2,2);
plot(tableData.("time (s)"),tableData.AcceptorCorNormBleachCor, 'g')
xlabel('t (s)')
ylabel('Intensity_{norm}')
title("Akzeptor_{norm}")
box off
ax3 = subplot(2,2,3);
plot(tableData.("time (s)"),tableData.FRETCorNormBleachCor, 'g')
xlabel('t (s)')
ylabel('Intensity_{norm}')
title("FRET_{norm}")
box off
sgtitle(sprintf(append(saveName, '\n FRETCh')),'Interpreter', 'none', 'FontSize', 10)
savefig(fig,append(fullsafeName,'_FRETCh.fig'));
exportgraphics(fig,append(fullsafeName,'_FRETCh.png'),'Resolution',600)
close;


fig = figure;
fig.Units = 'centimeters';
fig.OuterPosition = [0.25 0.25 10 10];
ax1 = subplot(2,2,1);
plot(tableData.("time (s)"), tableData.DonorCorNormBleachCor,'b')
title("Donor_{norm}")
xlabel('t (s)')
ylabel('Intensity_{norm}')
box off
ax2 = subplot(2,2,2);
plot(tableData.("time (s)"),tableData.FRETCorNormBleachCor, 'g')
xlabel('t (s)')
ylabel('Intensity_{norm}')
title("FRET{norm}")
box off
ax3 = subplot(2,2,3);
plot(tableData.("time (s)"),tableData.RatioFRETCorNormBleachCorDonorCorNormBleachCor, 'g')
xlabel('t (s)')
ylabel('Intensity_{norm}')
title("FRET-Ratio_{norm}")
box off
sgtitle(sprintf(append(saveName, '\n FRETRatio')),'Interpreter', 'none', 'FontSize', 10)
savefig(fig,append(fullsafeName,'_FRETRatio.fig'));
exportgraphics(fig,append(fullsafeName,'_FRETRatio.png'),'Resolution',600)
close;
disp(append('Finished: ', saveName));
end