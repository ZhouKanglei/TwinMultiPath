close all; clear all; clc;
addpath(genpath('src/'));
addpath(genpath('utils'));
addpath(genpath('utils/vis'));

class_i = 1;
class_j = 2;
filename = ['res/mix/plot_dist_', num2str(class_i), '_', num2str(class_j), '.mat'];
% plotDist(filename, class_i, class_j);
filename = ['res/mix/valid_', num2str(class_i), '_', num2str(class_j), '.mat'];
%load(filename);
% plotHeatmap(corrRatio, lambda_1, lambda_2, [num2str(class_i), '_', num2str(class_j)]);


filename = ['res/mix/pred.mat'];
%load(filename);
% plotPred(testData, y, y, num2str(corrPred), 'orig');
% close all;
% plotPred(testData, y, y_pred', num2str(corrPred), 'pred');

%% Global variables...
close all; clear all; clc;
globalVars();
dataSetNum = 13;

%% plot.
filePath = [resFolder, '/mainExp/', methods{1}, '/',...
    num2str(testRatio), '_',  num2str(dataSetNum), '.mat'];

if exist(filePath, 'file')
    load(filePath);
	
	% plotSolutionPath(Lambda_1{1}, Alpha{1}, Beta{1}, 1);
    % plotSolutionPath(Lambda_2{1}, Mu{1}, Rho{1}, 2);


    %% Global vars.
    testDataSplit = [trainData; testData];
    y = testDataSplit(:, 1);
    ySplit = y;
    
    class_i = 1;
    class_j = 2;
    lambda_1 = Lambda_1{1};
    lambda_2 = Lambda_2{1};
    
    alpha = Alpha{1};
    beta = Beta{1};
    mu = Mu{1};
    rho = Rho{1};
    
    [F, G, H, trainDataSplit] = splitData(trainData, class_i, class_j);
    

    ySplit(y == class_i) = 1;
    ySplit(y == class_j) = -1;
    ySplit(y ~= class_i & y ~= class_j) = 0;
    testDataSplit(:, 1) = ySplit;
    data = testDataSplit;
    
    numTrainingSum = size([F; G; H], 1);
    
    y = data(:, 1);
    X = data(:, 2 : end);
    X = [X ones(size(data, 1), 1)];
    
    %% Calculate.
    for i = 1 : size(lambda_1, 1)
        u(:, i) = - 1 / lambda_1(i, 1) * F_inv * (G' * alpha(:, i) + H' * beta(:, i));
        f_1(:, i) = X * u(:, i);
        w_1(:, i) = u(1 : end - 1, i);
        b_1(:, i) = u(end, i);
    end
    
    for i = 1 : size(lambda_2, 1)
        v(:, i) = 1 / lambda_2(i, 1) * G_inv * (F' * mu(:, i) + H' * rho(:, i));
        f_2(:, i) = X * v(:, i);
        w_2(:, i) = v(1 : end - 1, i);
        b_2(:, i) = v(end, i);
    end
    
    plotSolutionPath(lambda_1, alpha, beta, f_1, w_1, b_1, 1);
    plotSolutionPath(lambda_2, mu, rho, f_2, w_2, b_2, 2);
    
end
