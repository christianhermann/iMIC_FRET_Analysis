dataTable = table('Size', [0 6], 'VariableTypes', {'string', 'double', 'string', 'logical', 'string', 'string'}, 'VariableNames', {'name', 'midi', 'date', 'BAL', 'protocol', 'type'});
dataTable = readtable('U:\Projekte an Analysis1\Christian\mTRPC5 Projekt\Auswertungen\FRET\Auswertung.xlsx');


folder = uigetdir();

files = dir(folder);
% Get a logical vector that tells which is a directory.
dirFlags = [files.isdir];
% Extract only those that are directories.
subDirs = files(dirFlags); % A structure with extra info.
% Get only the folder names into a cell array.
subDirsNames = {subDirs(3:end).name};
subDirsNames(strcmp(subDirsNames, 'Processed')) = [];

for i = 1:length(subDirsNames)
    subfiles = dir(fullfile(folder,subDirsNames{i}));
% Get a logical vector that tells which is a directory.
subdirFlags = [subfiles.isdir];
% Extract only those that are directories.
subsubDirs = subfiles(subdirFlags); % A structure with extra info.
% Get only the folder names into a cell array.
subsubDirsNames = {subsubDirs(3:end).name};

for k = 1:length(subsubDirsNames)
matFiles = dir(fullfile(folder,subDirsNames{i},subsubDirsNames{k},'*.mat')); % get a list of all .mat files in the folder


name = struct2table(matFiles).name;
midi = string(repmat(subsubDirsNames{k},size(struct2table(matFiles).name, 1),1));
date = regexp(name, '\d{2}\.\d{2}\.\d{4}', 'match');
BAL = contains(name, 'BAL');
if class(name) == 'cell'
protocol = cellfun(@(x) regexp(x, '.*-(\d{3,4})-(.*?)(-\d+-\d+\w*)?\.mat', 'tokens'), name, 'UniformOutput', false);
protocol = cellfun(@(x) x{1}{2}, protocol, 'UniformOutput', false);
end
if class(name) == 'char' 
    name = string(name);
    protocol = regexp(name, '.*-(\d{3,4})-(.*?)(-\d+-\d+\w*)?\.mat', 'tokens');
    protocol = protocol{1}{2};
    protocol = string(protocol);
end 

type = regexp(struct2table(matFiles).folder, 'FRET\\(.*?)\\', 'tokens', 'once');

newTable = table(name, midi, date, BAL, protocol, type);
newTable.timeStart = zeros(size(newTable,1),1);
newTable.Ok_ = NaN(size(newTable,1),1);

name1 = dataTable.name;
name2 = newTable.name;

newNames = name2(~ismember(name2, name1));
newTable = newTable(ismember(newTable.name, newNames), :);

dataTable = [dataTable; newTable];

end
end
writetable(dataTable, 'U:\Projekte an Analysis1\Christian\mTRPC5 Projekt\Auswertungen\FRET\Auswertung.xlsx');
