function [bleedthrough] = bleedthroughFunction(folder)
%BLEEDTHROUGHFUNCTION Calculate bleedthrough values from measurement data
%   bleedthrough = bleedthroughFunction(folder) calculates the bleedthrough values from measurement
%   data files located in the specified folder. The function reads .mat files in the folder and
%   performs calculations to estimate the bleedthrough values.
%
%   Inputs:
%   - folder: The folder path containing the measurement data files.
%
%   Output:
%   - bleedthrough: A structure array containing the calculated bleedthrough values for each data file.
%
%   Example:
%   folder = 'C:\MeasurementData';
%   bleedthrough = bleedthroughFunction(folder);
%
%   See also DIR, STRUCT2CELL, CELL2MAT, MOVMEAN.

% Define parameters
windowSize = 15;
downsampleFrequency = 15;

% Get a list of .mat files in the specified folder
files = dir(folder);
dirFlags = [files.isdir];
files = files(~dirFlags);
files = files(contains({files.name}, '.mat'));

% Process each data file
for i = 1:size(files)
    % Load data from the .mat file
    load(fullfile(files(i).folder, files(i).name))
    
    downsampledData = cell(4, 1);
    rows = zeros(4, 1);
    
    % Process each measurement plot
    for j = 1:4 
        % Extract data from the measurement plot
        dataCell = struct2cell(struct(measurementPlotData(j)));
        dataMat = cell2mat(dataCell)';
        
        % Calculate rolling mean of the data
        rollingMean = movmean(dataMat, windowSize);
        
        % Downsample the data
        downsampledData{j} = array2table(rollingMean(1:downsampleFrequency:end, :), ...
            'VariableNames', {append('time_', num2str(j)), append('value_', num2str(j))});
        
        rows(j) = size(downsampledData{j}, 1);
    end
    
    % Determine the minimum number of rows in the downsampled data
    minRows = min(rows);
    
    % Trim the downsampled data to the minimum number of rows
    downsampledData{1} = downsampledData{1}(1:minRows, :);
    downsampledData{2} = downsampledData{2}(1:minRows, :);
    downsampledData{3} = downsampledData{3}(1:minRows, :);
    downsampledData{4} = downsampledData{4}(1:minRows, :);
    
    % Calculate the bleedthrough values
    bleedthrough(i).SexSemSexLem = mean(downsampledData{3}.value_3 ./ downsampledData{1}.value_1);
    bleedthrough(i).LexLemSexLem = mean(downsampledData{3}.value_3 ./ downsampledData{4}.value_4);
    bleedthrough(i).SexSemLexLem = mean(downsampledData{4}.value_4 ./ downsampledData{1}.value_1);
    bleedthrough(i).LexLemSexSem = mean(downsampledData{1}.value_1 ./ downsampledData{4}.value_4);
end

end