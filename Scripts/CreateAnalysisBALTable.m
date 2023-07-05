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



filesBAL = files(contains({files.name}, 'BAL.mat'));

for i = 1:numel(filesBAL)
    filename = fullfile(filesBAL(i).folder, filesBAL(i).name);
    data{i} = load(filename); % replace this with the appropriate loading function for your file type
end

for i = 1:numel(data)
FretData = data{1,i}.obj;
fig = figure;
plot(FretData.cutTime, FretData.btCorrectedData.FRET,  '-o');
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
iwB1 = indexWBandwith(dataIndex(i,1), bandwith);
iwB2 = indexWBandwith(dataIndex(i,2), bandwith);

dataTypes = ["cutData", "btCorrectedData", "btPbCorrectedData", "Ratio", "NFRET", "EFRET", "normFRET", "normRatio"];

tableData = table();

for l = 1:numel(dataTypes)
    dataType = dataTypes(l);
    
    % Generate variable name based on data type
    variableName = genvarname(dataType);
    
    % Call calcFRETEfficiency function and get output values
    [FRET_Rel, FRET_Abs, FRET_Bef, FRET_Aft] = calcFRETEfficiency(FretData.(dataType).FRET, iwB1, iwB2);
    
    % Add output values as columns to the table
    tableData.(variableName + "_Rel") = FRET_Rel;
    tableData.(variableName + "_Abs") = FRET_Abs;
    tableData.(variableName + "_Bef") = FRET_Bef;
    tableData.(variableName + "_Aft") = FRET_Aft;
end


timeBef(i,1) = FretData.cutTime(dataIndex(i,1));
timeAft(i,1) = FretData.cutTime(dataIndex(i,2));
close(fig);
end


name = struct2table(filesBAL).name;
splitnames = cell(size(name));


for i = 1:numel(name)
    splitnames{i} = split(name{i}, '-');
    midi(i,1) = str2double(splitnames{i}{4});
    midiCo(i,1) = NaN;
    if length(splitnames{i}) == 9 
        midiCo(i,1) = str2double(splitnames{i}{6});
    end
dateMeas(i,1) = string(splitnames{i}{1});
end

newTable = table(name, midi, midiCo,dateMeas, timeBef, timeAft, ...
    tableData);

name1 = dataTable.name;
name2 = newTable.name;
newNames = name2(~ismember(name2, name1));
newTable = newTable(ismember(newTable.name, newNames), :);
dataTable = [dataTable; newTable];

writetable(dataTable, 'C:\Users\Christian\Documents\FRET\AnalysisBAL.xlsx');



