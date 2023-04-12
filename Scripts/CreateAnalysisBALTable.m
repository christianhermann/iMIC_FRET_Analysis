%dataTable = table('Size', [0 9], 'VariableTypes', {'string','double','string', 'double', 'double', 'double','double', 'double', 'double'}, ...
%    'VariableNames', {'name', 'midi', 'date', 'timeBef', 'timeAft','BAL_FRETCor','BAL_FRETCorNorm' , 'BAL_FRETCorNormBleachCor', 'BAL_FRETXia'});
%dataTable = readtable('U:\Projekte an Analysis1\Christian\mTRPC5 Projekt\Auswertungen\FRET\AnalysisBAL.xlsx');
dataTable = readtable('C:\Users\Christian\Documents\FRET\AnalysisBAL.xlsx');

bandwith = 100;

folder = uigetdir(); % replace with the actual path to the folder

files = dir(fullfile(folder, '**\*.*'));
% Get a logical vector that tells which is a directory.
dirFlags = [files.isdir];
% Extract only those that are files
files = files(~dirFlags); % A structure with extra info.



filesBAL = files(contains({files.name}, 'BAL_processed.mat'));

for i = 1:numel(filesBAL)
    filename = fullfile(filesBAL(i).folder, filesBAL(i).name);
    data{i} = load(filename); % replace this with the appropriate loading function for your file type
end

for i = 1:numel(data)
   figData = data{1,i}.tableData;
 fig = figure;
plot(figData.("time (s)"), figData.FRETCorNormBleachCor,  '-o');
fig.WindowState = 'maximized';
for j = 1:2
    shg
    dcm_obj = datacursormode(1);
    set(dcm_obj,'DisplayStyle','window',...
    'SnapToDataVertex','off','Enable','on')
    waitforbuttonpress
    c_info{j} = getCursorInfo(dcm_obj);
    dataIndex(i,j) = c_info{j}.DataIndex;
end

tableData = data{1,i}.tableData;

if dataIndex(i,2) + bandwith > size(tableData.Acceptor, 1)
    dataIndex(i,2) = size(tableData.Acceptor, 1) - bandwith;
end

BAL_FRETCor_Bef(i,1) = mean(tableData.FRETCor((dataIndex(i,1) - bandwith):(dataIndex(i,1) + bandwith)));
BAL_FRETCor_Aft(i,1) = mean(tableData.FRETCor((dataIndex(i,2) - bandwith):(dataIndex(i,2) + bandwith)));
BAL_FRETCor_Abs(i,1) = BAL_FRETCor_Bef(i,1) - BAL_FRETCor_Aft(i,1);
BAL_FRETCor_Rel(i,1) = BAL_FRETCor_Abs(i,1) / BAL_FRETCor_Bef(i,1);

BAL_FRETCorNorm_Bef(i,1) = mean(tableData.FRETCorNorm((dataIndex(i,1) - bandwith):(dataIndex(i,1) + bandwith)));
BAL_FRETCorNorm_Aft(i,1) = mean(tableData.FRETCorNorm((dataIndex(i,2) - bandwith):(dataIndex(i,2) + bandwith)));
BAL_FRETCorNorm_Abs(i,1) = BAL_FRETCorNorm_Bef(i,1) - BAL_FRETCorNorm_Aft(i,1);
BAL_FRETCorNorm_Rel(i,1) = BAL_FRETCorNorm_Abs(i,1) / BAL_FRETCorNorm_Bef(i,1);

BAL_FRETCorNormBleachCor_Bef(i,1) = mean(tableData.FRETCorNormBleachCor((dataIndex(i,1) - bandwith):(dataIndex(i,1) + bandwith)));
BAL_FRETCorNormBleachCor_Aft(i,1) = mean(tableData.FRETCorNormBleachCor((dataIndex(i,2) - bandwith):(dataIndex(i,2) + bandwith)));
BAL_FRETCorNormBleachCor_Abs(i,1) = BAL_FRETCorNormBleachCor_Bef(i,1) - BAL_FRETCorNormBleachCor_Aft(i,1);
BAL_FRETCorNormBleachCor_Rel(i,1) = BAL_FRETCorNormBleachCor_Abs(i,1) / BAL_FRETCorNormBleachCor_Bef(i,1);

BAL_FRETXia_Bef(i,1) = mean(tableData.FRETXia((dataIndex(i,1) - bandwith):(dataIndex(i,1) + bandwith)));
BAL_FRETXia_Aft(i,1) = mean(tableData.FRETXia((dataIndex(i,2) - bandwith):(dataIndex(i,2) + bandwith)));
BAL_FRETXia_Abs(i,1) = BAL_FRETXia_Bef(i,1) - BAL_FRETXia_Aft(i,1);
BAL_FRETXia_Rel(i,1) = BAL_FRETXia_Abs(i,1) / BAL_FRETXia_Bef(i,1);

BAL_FRETRatio_Bef(i,1) = mean(tableData.RatioFRETCorNormBleachCorDonorCorNormBleachCor((dataIndex(i,1) - bandwith):(dataIndex(i,1) + bandwith)));
BAL_FRETRatio_Aft(i,1) = mean(tableData.RatioFRETCorNormBleachCorDonorCorNormBleachCor((dataIndex(i,2) - bandwith):(dataIndex(i,2) + bandwith)));
BAL_FRETRatio_Abs(i,1) = BAL_FRETRatio_Bef(i,1) - BAL_FRETRatio_Aft(i,1);
BAL_FRETRatio_Rel(i,1) = BAL_FRETRatio_Abs(i,1) / BAL_FRETRatio_Bef(i,1);

timeBef(i,1) = tableData.("time (s)")(dataIndex(i,1));
timeAft(i,1) = tableData.("time (s)")(dataIndex(i,2));
% BAL_FRETCor(i,1) = 1 - mean(figData.FRETCor((dataIndex(i,2) - bandwith):(dataIndex(i,2) + bandwith)) / mean(figData.FRETCor((dataIndex(i,1) - bandwith):(dataIndex(i,1) + bandwith))));
% BAL_FRETCorNorm(i,1) = 1 - mean(figData.FRETCorNorm((dataIndex(i,2) - bandwith):(dataIndex(i,2) + bandwith)) / mean(figData.FRETCorNorm((dataIndex(i,1) - bandwith):(dataIndex(i,1) + bandwith))));
% BAL_FRETCorNormBleachCor(i,1) = 1 - mean(figData.FRETCorNormBleachCor((dataIndex(i,2) - bandwith):(dataIndex(i,2) + bandwith)) / mean(figData.FRETCorNormBleachCor((dataIndex(i,1) - bandwith):(dataIndex(i,1) + bandwith))));
% BAL_FRETXia(i,1) = 1 - mean(figData.FRETXia((dataIndex(i,2) - bandwith):(dataIndex(i,2) + bandwith)) / mean(figData.FRETXia((dataIndex(i,1) - bandwith):(dataIndex(i,1) + bandwith))));
% BAL_FRETRatio(i,1) = 1 - mean(figData.RatioFRETDonor((dataIndex(i,2) - bandwith):(dataIndex(i,2) + bandwith)) / mean(figData.RatioFRETDonor((dataIndex(i,1) - bandwith):(dataIndex(i,1) + bandwith))));
close(fig);
end


name = struct2table(filesBAL).name;
splitnames = split(name, '-');
midi = str2double(splitnames(:,4));
date = splitnames(:,1);
newTable = table(name, midi, date, timeBef, timeAft, ...
    BAL_FRETCor_Bef, BAL_FRETCor_Aft, BAL_FRETCor_Abs,BAL_FRETCor_Rel, ...
    BAL_FRETCorNorm_Bef, BAL_FRETCorNorm_Aft, BAL_FRETCorNorm_Abs,BAL_FRETCorNorm_Rel, ...
    BAL_FRETCorNormBleachCor_Bef, BAL_FRETCorNormBleachCor_Aft, BAL_FRETCorNormBleachCor_Abs,BAL_FRETCorNormBleachCor_Rel, ...
    BAL_FRETXia_Bef, BAL_FRETXia_Aft, BAL_FRETXia_Abs,BAL_FRETXia_Rel, ...
    BAL_FRETRatio_Bef, BAL_FRETRatio_Aft, BAL_FRETRatio_Abs,BAL_FRETRatio_Rel);

name1 = dataTable.name;
name2 = newTable.name;
newNames = name2(~ismember(name2, name1));
newTable = newTable(ismember(newTable.name, newNames), :);
dataTable = [dataTable; newTable];

writetable(dataTable, 'C:\Users\Christian\Documents\FRET\AnalysisBAL.xlsx');



