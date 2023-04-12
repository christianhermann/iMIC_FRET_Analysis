btDF = struct2array(load('U:\Projekte an Analysis1\Christian\mTRPC5 Projekt\Auswertungen\FRET\BleedThrough\btFlAsHmTq2.mat'));


folder = uigetdir(); % replace with the actual path to the folder

files = dir(folder);
% Get a logical vector that tells which is a directory.
dirFlags = [files.isdir];
% Extract only those that are directories.
subDirs = files(dirFlags); % A structure with extra info.
% Get only the folder names into a cell array.
subDirsNames = {subDirs(3:end).name};


for k = 1:length(subDirsNames)
    %matFiles = dir(fullfile(folder,subDirsNames{k},'*.mat')); % get a list of all .mat files in the folder
    subfolder = dir(fullfile(folder,subDirsNames{k}));
    % Get a logical vector that tells which is a directory.
    subdirFlags = [subfolder.isdir];
    % Extract only those that are directories.
    subsubDirs = subfolder(subdirFlags); % A structure with extra info.
    % Get only the folder names into a cell array.
    subsubDirsNames = {subsubDirs(3:end).name};

    for l = 1:length(subsubDirsNames)
        matFiles = dir(fullfile(folder,subDirsNames{k},subsubDirsNames{l},'*.mat')); % get a list of all .mat files in the folder

        for i = 1:length(matFiles) % iterate through the list
            file = matFiles(i);
            if file.isdir == 0 % check if the file is not a directory
                disp(append('Loading: ', fullfile(folder,subDirsNames{k},subsubDirsNames{l},file.name)));
                load(fullfile(folder,subDirsNames{k},subsubDirsNames{l},file.name)) % load the file
                disp('Finished');
                [~, saveName, fileExtension] = fileparts(file.name);
                saveFolder = fullfile(folder,'Processed',subDirsNames{k},subsubDirsNames{l});                
                preprocessFRETmeasurementFunktion(measurementPlotData, saveFolder, saveName, btDF);
            end
        end
    end
end