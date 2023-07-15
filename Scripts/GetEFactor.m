
addpath(genpath('C:\Users\Christian\OneDrive\Dokumente\FRET\Scripts\'))

folder = uigetdir(); % replace with the actual path to the folder

files = dir(fullfile(folder, '**\*.*'));
% Get a logical vector that tells which is a directory.
dirFlags = [files.isdir];
% Extract only those that are files
files = files(~dirFlags); % A structure with extra info.


for i = 1:numel(files)
    filename = fullfile(files(i).folder, files(i).name);
    dataDonor{i} = load(filename); % replace this with the appropriate loading function for your file type
end
folder = uigetdir(); % replace with the actual path to the folder

files = dir(fullfile(folder, '**\*.*'));
% Get a logical vector that tells which is a directory.
dirFlags = [files.isdir];
% Extract only those that are files
files = files(~dirFlags); % A structure with extra info.


for i = 1:numel(files)
    filename = fullfile(files(i).folder, files(i).name);
    dataAcceptor{i} = load(filename); % replace this with the appropriate loading function for your file type
end
folder = uigetdir(); % replace with the actual path to the folder

files = dir(fullfile(folder, '**\*.*'));
% Get a logical vector that tells which is a directory.
dirFlags = [files.isdir];
% Extract only those that are files
files = files(~dirFlags); % A structure with extra info.


for i = 1:numel(files)
    filename = fullfile(files(i).folder, files(i).name);
    dataComplete{i} = load(filename); % replace this with the appropriate loading function for your file type
end

windowSize = 15;
downsampleFrequency = 15;
bandwith = 100;

for i = 1:numel(files)
    tableDataDonor{i} = downsampleMeasData(dataDonor{i}.measurementPlotData, windowSize, downsampleFrequency);
    tableDataAcceptor{i} = downsampleMeasData(dataAcceptor{i}.measurementPlotData, windowSize, downsampleFrequency);
    tableDataComplete{i} = downsampleMeasData(dataComplete{i}.measurementPlotData, windowSize, downsampleFrequency);
    EFactor(i) = calculateEFactor(tableDataDonor{i}, tableDataAcceptor{i}, tableDataComplete{i},bandwith);
end

MeanEFactor = mean(EFactor);
SDEFactor = std(EFactor);



