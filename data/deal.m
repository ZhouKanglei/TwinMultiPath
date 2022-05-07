%% Clear Window...
clc;
clear all;
close all;
%% Global data path...
global dataPath interval;
dataPath = 'E:\Code_Files\Matlab\SVM\TwinMultiPath\data';
[tab, str] = xlsread([dataPath, '\dataName.xlsx']);
interval = '\t';

% Default interval char between cells of table.
if ~exist('interval', 'var')
    interval = '\t';
end

%% Obtain all the # Datasets in the fileFolder.
fileFolder = fullfile(dataPath);
dirOutput = dir(fullfile(fileFolder, '*.mat'));
fileNames = {dirOutput.name};

%% Print data info...
fprintf('-----------------Tab. of Datasets----------------\n');
fprintf([' # ', interval]);
fprintf([' Name ', interval]);
fprintf([' Total ', interval]);
fprintf([' Dimension ', interval]);
fprintf([' # Classes ', interval]);
fprintf([' # Each Class\n']);
for i = 1 : size(fileNames, 2)
    fullFilename = char(fileNames(i));
    filename = fullFilename(1 : size(fullFilename, 2) - 4);
    load([dataPath, '\', filename]);
    Data = eval(filename);
    [m, n] = size(Data);
    num_class = unique(Data(:, 1));
    fprintf([' %d ', interval], i);
    fprintf([' %s ', interval], filename);
    fprintf([' %d ', interval], m);
    fprintf([' %d ', interval], n);
    fprintf([' %d ', interval], length(num_class));
    for j = 1 : length(num_class)
        num_class_j = length(find(Data(:, 1) == num_class(j)));
        fprintf([' %d'], num_class_j);
        if j ~= length(num_class)
            fprintf(',');
        end
    end
    fprintf('\n');
end
fprintf('--------------------------------------------------\n');
