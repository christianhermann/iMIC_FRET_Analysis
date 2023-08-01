dataTable = readtable('C:\Users\Christian\OneDrive\Dokumente\FRET\AuswertungProcessed.xlsx');

bandwith = 100;

dataTypes = ["cutData", "btCorrectedData", "btPbCorrectedData", "Ratio", "NFRET", "EFRET", "DFRET", "normFRET", "normRatio"];

folder = uigetdir(); % replace with the actual path to the folder

files = dir(fullfile(folder, '**\*.*'));
% Get a logical vector that tells which is a directory.
dirFlags = [files.isdir];
% Extract only those that are files
files = files(~dirFlags); % A structure with extra info.



filesWoBAL= files(~contains({files.name}, 'BAL.mat'));
filesSel= filesWoBAL(~contains({filesWoBAL.name}, 'Bleach.mat'));

name = struct2table(filesSel).name;
splitnames = cell(size(name));
if exist("dataTable", "var")
    tableNames = dataTable.name;
else
    tableNames = "0";
end
for i = 1:numel(name)
    isThere(i) = ~any(strcmp(tableNames, name{i}));
end
filesSel = filesSel(isThere);

f = waitbar(0, "This seems like an incredibly long placeholder, like really not usefull,but it needs to be this way, because the filenames are incredibly long, trust me it is better like this...");
                f.Children(1).Title.Interpreter = 'none';

for i = 1:numel(filesSel)
    filename = fullfile(filesSel(i).folder, filesSel(i).name);
    waitbar(i/numel(filesSel),f, append("Loading: ", filename), 'Interpreter', 'none');
    load(filename); % replace this with the appropriate loading function for your file type

    protocolStructure = prepareProtocolStructure(obj.protocolStructure, obj.protocolStartTimeAC, obj.protocol);
    if isnan(obj.protocolStartTime)
        continue
    end
    for l = 1:numel(dataTypes)
        dataType = dataTypes(l);
        for row = 1:height(protocolStructure)
            for col = 6:width(protocolStructure)
                [FRET_Rel, FRET_Abs, FRET_Bef, FRET_Aft] = calcFRETEfficiency(obj.(dataType).FRET, ...
                    indexWBandwith(findTimeIndex(obj.cutTime, protocolStructure.TimeBef(row)), bandwith), ...
                    indexWBandwith(findTimeIndex(obj.cutTime, protocolStructure{row, col}), bandwith));

                tableData.(dataType + "_" +protocolStructure.Properties.VariableNames{col} + "_Rel")(i) = FRET_Rel;
                tableData.(dataType + "_" +protocolStructure.Properties.VariableNames{col} +  "_Abs")(i) = FRET_Abs;
                tableData.(dataType + "_" +protocolStructure.Properties.VariableNames{col} +  "_Bef")(i) = FRET_Bef;
                tableData.(dataType + "_" +protocolStructure.Properties.VariableNames{col} +  "_Aft")(i) = FRET_Aft;

            end
        end
    end

 nameTable(i,1) = string(name(i));
 splitnames{i} = split(name{i}, '-');
    midi(i,1) = str2double(splitnames{i}{4});
    midiCo(i,1) = NaN;
    if length(splitnames{i}) == 9
        midiCo(i,1) = str2double(splitnames{i}{6});
    end
    dateMeas(i,1) = string(splitnames{i}{1});
    quality(i,1) = 1;
end

name = nameTable;
newTable = [table(name, midi, midiCo,dateMeas,  quality) struct2table(structfun(@(x) x', tableData, 'UniformOutput', false))];
newTable = rmmissing(newTable, 'DataVariables',{'name'});
newTable = standardizeMissing(newTable, 0);
close(f)

name1 = dataTable.name;
name2 = newTable.name;
newNames = name2(~ismember(name2, name1));  
newTable = newTable(ismember(newTable.name, newNames), :);
dataTable = [dataTable; newTable];

writetable(dataTable, 'C:\Users\Christian\OneDrive\Dokumente\FRET\AuswertungProcessed.xlsx');
