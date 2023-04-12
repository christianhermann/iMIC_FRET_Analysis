function [tableData] = downsampleMeasData(measurementPlotData, windowSize, downsampleFrequency)
%downsampleMeasData downsample Data and put it in a table
%   Detailed explanation goes here
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

tableData = [downsampledData{1} downsampledData{2} downsampledData{3} downsampledData{4}];
tableData(:,[3 5 7]) = [];

tableData = renamevars(tableData, {'time_1', 'value_1', 'value_2', 'value_3', 'value_4'}, {'time (s)', 'Donor', 'Empty', 'FRET', 'Acceptor'});
end