addpath 'C:\Users\Christian\Documents\FRET\Scripts\Functions'

bt = load('C:\Users\Christian\Documents\FRET\BleedThrough\btmTq2FlAsH.mat');
fns = fieldnames(bt);
bt = bt.(fns{1});
btData.btDF = bt.DF;
btData.btAF = bt.AF;
btData.btAD = bt.AD;
btData.btDA = bt.DA;


Gfactor  = load('C:\Users\Christian\Documents\FRET\G-Factor\G-Factor_mTq2-FlAsH.mat');
Gfactor = Gfactor.MeanGFactor;

[file, folder] = uigetfile('*.mat'); %find file

[~, fileName, fileExtension] = fileparts(file);

folderSplit = regexp(folder, '\', 'split');
saveFolder = append(strjoin(folderSplit(1:(numel(folderSplit)-4)),'\'), '\Processed\', strjoin(folderSplit((numel(folderSplit)-3):numel(folderSplit)),'\'));

load(fullfile(folder,file)) % load the file
tableData = downsampleMeasData(measurementPlotData, 50, 10);

FretData = FRETdata(tableData, btData, Gfactor, fileName, folder, saveFolder);
FretData = FretData.cutMeasurement("rawData");
FretData = FretData.correctIntensities("cutData");
FretData = FretData.correctBleaching("btCorrectedData", 200);
FretData = FretData.calculateRatio("btPbCorrectedData");
FretData = FretData.calculateNFRET("btCorrectedData");
FretData = FretData.calculateEFRET("cutData");
FretData = FretData.normFRETtoOne("btPbCorrectedData", 100,500);
FretData = FretData.calculateRatio("normFRET");

FretData.saveMatFile
