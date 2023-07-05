folder = uigetdir(); % replace with the actual path to the folder

files = dir(fullfile(folder, '**\*.*'));
% Get a logical vector that tells which is a directory.
dirFlags = [files.isdir];
% Extract only those that are files
files = files(~dirFlags); % A structure with extra info.


for i = 1:numel(files)
    filename = fullfile(files(i).folder, files(i).name);
    data{i} = load(filename); % replace this with the appropriate loading function for your file type
end

btDF = load('C:\Users\Christian\Documents\FRET\BleedThrough\btmTq2DonorFRET.mat');
btDF = btDF.btmTq2DonorFRET;

windowSize = 15;
downsampleFrequency = 15;
bandwith = 100;

for i = 1:numel(data)
tableData{i} = downsampleMeasData(data{i}.measurementPlotData, windowSize, downsampleFrequency);
GFactor(i) = calculateGFactor(tableData{i}, bandwith, btDF);
end

MeanGFactor = mean(GFactor);
SDGFactor = std(GFactor);




folder = uigetdir(); % replace with the actual path to the folder

files = dir(fullfile(folder, '**\*.*'));
% Get a logical vector that tells which is a directory.
dirFlags = [files.isdir];
% Extract only those that are files
files = files(~dirFlags); % A structure with extra info.


for i = 1:numel(files)
    filename = fullfile(files(i).folder, files(i).name);
    data{i} = load(filename); % replace this with the appropriate loading function for your file type
end

btDF = load('C:\Users\Christian\Documents\FRET\BleedThrough\btcpmTq2DonorFRET.mat');
btDF = btDF.btcpmTq2DonorFRET;

windowSize = 50;
downsampleFrequency = 10;
bandwith = 100;

for i = 1:numel(data)
tableData{i} = downsampleMeasData(data{i}.measurementPlotData, windowSize, downsampleFrequency);
GFactor(i) = calculateGFactor(tableData{i}, bandwith, btDF);
end

MeanGFactor = mean(GFactor);
SDGFactor = std(GFactor);

