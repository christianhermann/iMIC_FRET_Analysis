function [fig] = addApplicationLines(fig,appTime, appName, appColor)
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here
    for i = 1:numel(fig.Children.Children)
        yRange(i) = diff(fig.Children.Children(i).YLim);
        yStep(i) = yRange(i) / 100;
        maxY(i) = max(fig.Children.Children(i).Children.YData);
        lineY(i) = maxY(i) + yStep(i) * 5;
    end
for j = 1:numel(appName)

    for i = 1:numel(fig.Children.Children)

        line(fig.Children.Children(i), appTime(j,:), [lineY(i) lineY(i)], 'color', appColor(j), 'LineWidth', 1)
        txt = text(fig.Children.Children(i), mean(appTime(j,:)), lineY(i)+ yStep(i)*15, ...
            appName(j),'color', appColor(j), 'FontSize',5, 'FontWeight', 'normal', ...
            'HorizontalAlignment', 'center');
        ext = get(txt,'Extent');
upperPosition = sum(ext(:,[2,4]),2);                       % Step 2
fig.Children.Children(i).YLim = ([min(fig.Children.Children(i).YLim()),max(max(fig.Children.Children(i).YLim()),max(upperPosition))]);
       
end
end