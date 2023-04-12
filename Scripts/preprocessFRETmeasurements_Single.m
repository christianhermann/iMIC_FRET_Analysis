%btDF = struct2array(load('U:\Projekte an Analysis1\Christian\mTRPC5 Projekt\Auswertungen\FRET\BleedThrough\btFlAsHmTq2.mat'));
btDF = load('C:\Users\Christian\Documents\FRET\BleedThrough\btmTq2DonorFRET.mat');
btDF = btDF.btmTq2DonorFRET;
[file, folder] = uigetfile('*.mat'); %find file

[~, saveName, fileExtension] = fileparts(file);

folderSplit = regexp(folder, '\', 'split');
saveFolder = append(strjoin(folderSplit(1:(numel(folderSplit)-3)),'\'), '\Processed\', strjoin(folderSplit((numel(folderSplit)-2):numel(folderSplit)),'\'));

load(fullfile(folder,file)) % load the file
preprocessFRETmeasurementFunktion(measurementPlotData, saveFolder, saveName, btDF);


