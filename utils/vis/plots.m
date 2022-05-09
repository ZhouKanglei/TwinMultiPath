close all; clear all; clc;
addpath(genpath('src/'));
addpath(genpath('utils/vis'));

%% Global variables...
globalVars();
dataSetNum = 13;

%% plot.
filePath = [resFolder, '/mainExp/', methods{1}, '/',...
    num2str(testRatio), '_',  num2str(dataSetNum), '.mat'];

if exist(filePath, 'file')
    load(filePath);
	
	plotSolutionPath(Lambda_1{1}, Alpha{1}, Beta{1}, 1);
    plotSolutionPath(Lambda_2{1}, Mu{1}, Rho{1}, 2);
end