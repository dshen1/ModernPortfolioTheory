function interestDailised = readInterestDailised()
%readInterestDailised read in interest rates from csv file
%
% Output:
%   interestDailised    table with two columns of interest rates and dates
%                       as rownames

filename='data/interestDailised.csv';

%% Initialize variables.
delimiter = ',';
if nargin<=2
    startRow = 2;
    endRow = inf;
end

%% Format string for each line of text:
%   column1: double (%f)
%	column2: double (%f)
%   column3: double (%f)
% For more information, see the TEXTSCAN documentation.
formatSpec = '%f%f%f%[^\n\r]';

%% Open the text file.
fileID = fopen(filename,'r');

%% Read columns of data according to format string.
% This call is based on the structure of the file used to generate this
% code. If an error occurs for a different file, try regenerating the code
% from the Import Tool.

dataArray = textscan(fileID, formatSpec, endRow(1)-startRow(1)+1, ...
    'Delimiter', delimiter, 'EmptyValue' ,NaN,'HeaderLines', ...
    startRow(1)-1, 'ReturnOnError', false);

for block=2:length(startRow)
    frewind(fileID);
    dataArrayBlock = textscan(fileID, formatSpec, endRow(block)-...
        startRow(block)+1, 'Delimiter', delimiter, 'EmptyValue' ...
        ,NaN,'HeaderLines', startRow(block)-1, 'ReturnOnError', false);
    for col=1:length(dataArray)
        dataArray{col} = [dataArray{col};dataArrayBlock{col}];
    end
end

%% Close the text file.
fclose(fileID);

%% Post processing for unimportable data.
% No unimportable data rules were applied during the import, so no post
% processing code is included. To generate code which works for
% unimportable data, select unimportable cells in a file and regenerate the
% script.

%% Create output variable

interestDailised = table(dataArray{1:end-1}, 'VariableNames', ...
    {'Var1','liborDailised','primeDailised'});

%dates as row names
interestDailised.Properties.RowNames = cellstr(datestr(interestDailised.Var1));
interestDailised.Var1 = [];

end