addpath(genpath('C:\Users\Christian\OneDrive\Dokumente\FRET\Scripts\'))

bt = load('C:\Users\Christian\OneDrive\Dokumente\FRET\BleedThrough\btmTq2FlAsH.mat');
fns = fieldnames(bt);
bt = bt.(fns{1});
btData.btDF = bt.DF;
btData.btAF = bt.AF;
btData.btAD = bt.AD;
btData.btDA = bt.DA;

bgData = getBackground;



Gfactor  = load('C:\Users\Christian\OneDrive\Dokumente\FRET\G-Factor\G-Factor_mTq2-FlAsH.mat');
Gfactor = Gfactor.MeanGFactor;

Efactor = 0;

infoTable = readtable("C:\Users\Christian\OneDrive\Dokumente\FRET\Auswertung.xlsx",  "UseExcel", false);


[file, folder] = uigetfile('*.mat'); %find file

[~, fileName, fileExtension] = fileparts(file);

folderSplit = regexp(folder, '\', 'split');
saveFolder = append(strjoin(folderSplit(1:(numel(folderSplit)-4)),'\'), '\Processed\', strjoin(folderSplit((numel(folderSplit)-3):numel(folderSplit)),'\'));

                fullName = fullfile(folder,file);
                disp(append('Loading: ', fullName));
                        load(fullName) % load the file
                disp('Finished');
                [folder, fileName, fileExtension] = fileparts(fullName);
                folderSplit = regexp(folder, '\', 'split');
                saveFolder = append(strjoin(folderSplit(1:(numel(folderSplit)-3)),'\'), '\Processed\', strjoin(folderSplit((numel(folderSplit)-2):numel(folderSplit)),'\'));
                tableData = downsampleMeasData(measurementPlotData, 50, 10);
                FretData = FRETdata(tableData, bgData, btData, Gfactor, Efactor, fileName, folder, saveFolder);
                FretData.protocolStartTime = infoTable.timeStart(find(contains (infoTable.name,fileName)));
                fileNameSplit = split(fileName, '-');
                FretData.protocol = fileNameSplit{length(fileNameSplit) - 2};
                FretData = FretData.getProtocolData;
                FretData = FretData.cutMeasurement("rawData");
                FretData = FretData.correctIntensities("cutData");
                FretData = FretData.correctBleaching("btCorrectedData", 200);
                FretData = FretData.calculateRatio("btPbCorrectedData", 0);
                FretData = FretData.calculateNFRET("btCorrectedData");
                FretData = FretData.calculateEFRET("cutData");
                FretData = FretData.calculateDFRET("cutData");
                FretData = FretData.normFRETtoOne("btPbCorrectedData", 100,500);
                FretData = FretData.calculateRatio("normFRET", 1);
                FretData.saveMatFile
                close(f)