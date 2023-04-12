function [bleedthrough] = bleedthroughFunction(folder)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
windowSize = 15;
downsampleFrequency = 15;

files = dir(folder);
dirFlags = [files.isdir];
% Extract only those that are directories.
files = files(~dirFlags); % A structure with extra info.
files = files(contains({files.name}, '.mat'));


for i = 1:size(files)
load(fullfile(files(i).folder, files(i).name))
downsampledData = cell(4,1) ;
    rows = zeros(4,1);
    for j = 1:4 
        dataCell = struct2cell(struct(measurementPlotData(j)));
        dataMat = cell2mat(dataCell)';
        rollingMean = movmean(dataMat, windowSize);
    downsampledData{j} = array2table(rollingMean(1:downsampleFrequency:end,:), 'VariableNames',{append('time_',num2str(j)), append('value_',num2str(j))});
        rows(j) = size(downsampledData{j} ,1);
    end

    minRows = min(rows);
    downsampledData{1} = downsampledData{1}(1:minRows,:);
    downsampledData{2} = downsampledData{2}(1:minRows,:);
    downsampledData{3} = downsampledData{3}(1:minRows,:);
    downsampledData{4} = downsampledData{4}(1:minRows,:);

    bleedthrough(i).SexSemSexLem = mean(downsampledData{3}.value_3./downsampledData{1}.value_1);
    bleedthrough(i).LexLemSexLem = mean(downsampledData{3}.value_3./downsampledData{4}.value_4);
    bleedthrough(i).SexSemLexLem = mean(downsampledData{4}.value_4./downsampledData{1}.value_1);
    bleedthrough(i).LexLemSexSem = mean(downsampledData{1}.value_1./downsampledData{4}.value_4);

end

end