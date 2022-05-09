close all; clear all; clc;
addpath(genpath('src/'));
addpath(genpath('utils/vis'));

%% Global variables...
globalVars();
dataSetNum = 15;

%% plot.
filePath = [resFolder, '/mainExp/', methods{1}, '/',...
    num2str(testRatio), '_',  num2str(dataSetNum), '.mat'];

if exist(filePath, 'file')
    load(filePath);
    
end