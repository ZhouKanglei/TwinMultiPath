close all; clear all; clc;
addpath(genpath('src/'));
addpath(genpath('utils'));
addpath(genpath('utils/vis'));

class_i = 1;
class_j = 2;
filename = ['res/mix/plot_dist_', num2str(class_i), '_', num2str(class_j), '.mat'];
% plotDist(filename, class_i, class_j);
filename = ['res/mix/valid_', num2str(class_i), '_', num2str(class_j), '.mat'];
load(filename);
% plotHeatmap(corrRatio, lambda_1, lambda_2, [num2str(class_i), '_', num2str(class_j)]);


filename = ['res/mix/pred.mat'];
load(filename);
plotPred(testData, y, y, num2str(corrPred))