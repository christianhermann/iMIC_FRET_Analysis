function differentEntries = findDifferentRows(struct1, struct2, column1)
    %FINDDIFFERENTROWS Find entries in two structs with differing values in specified column
    %   differentEntries = findDifferentRows(struct1, struct2, column1) compares the values
    %   in the specified column of struct1 and struct2. It returns a struct array differentEntries
    %   containing the entries from struct1 where the column values differ from those in struct2.
    %   The column name is specified by column1. If column1 is not provided, it defaults to 'name'.
    %
    %   Example:
    %   struct1 = struct('name', 'John', 'age', 25, 'city', 'New York');
    %   struct2 = struct('city', 'Los Angeles', 'age', 30, 'name', 'Alice', 'extra', 'data');
    %   differentEntries = findDifferentRows(struct1, struct2, 'name');
    %
    %   See also TABLE, STRUCT2TABLE, UNIQUE.

    % Set default values for column1 and column2
    if nargin < 3
        column1 = 'name';
    end

    % Get the values of column1 for each struct
    col1_struct1 = {struct1.(column1)};
    col1_struct2 = {struct2.(column1)};

    % Initialize an empty array to store differing entries
    differentEntries = [];

    % Iterate over each value in col1_struct1
    for i = 1:numel(col1_struct1)
        % Check if the value in col1_struct1 differs from any value in col1_struct2
        if ~any(strcmp(col1_struct2, col1_struct1{i}))
            % Append the differing entry to the result
            differentEntries = [differentEntries; struct1(i)];
        end
    end
    
    if ~isempty(differentEntries)
    % Convert the struct to a table for easy filtering
    dataTable = struct2table(differentEntries);

    % Use the unique function to get unique rows
    uniqueData = unique(dataTable, 'rows');

    % Convert the table back to a struct
    differentEntries = table2struct(uniqueData);
    end
end