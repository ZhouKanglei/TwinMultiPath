close all; clear all; clc;
addpath(genpath('utils/'));
addpath(genpath('src/'));

%% Global variables...      
globalVars();

dataRange = [1 2 3 4 5 6 7 8 9 10 11 12 13 14];
distOpt = 1;
epsilon = 0.5;
testRatio = 0.25;

if ~exist([resFolder, '/mainExp'], 'dir')
    mkdir([resFolder, '/mainExp']);
end

if ~exist([resFolder, '/mainExp/Ours'], 'dir')
    mkdir([resFolder, '/mainExp/Ours']);
end

event_1_all = zeros(9, 13);
event_2_all = zeros(9, 13);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% OVOVR TSVM
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for dataSetNum = dataRange
    for times = 1 : 10
        [trainData, testData, classNum] = loadData(dataSetNum);
        %% Training...
        tic;
        [Lambda_1, Alpha, Beta, ...
            Lambda_2, Mu, Rho, ...
            event_1, event_2] = trainPath(trainData, classNum);
        time(times) = toc;
        event_1_all = event_1_all + mean(event_1')';
        event_2_all = event_2_all + mean(event_2')';
        
        %% Validation...
        tic;
        [optLambda_1, optAlpha, optBeta, ...
            optLambda_2, optMu, optRho] = validPath(...
            trainData, trainData, classNum, ...
            Lambda_1, Alpha, Beta, ...
            Lambda_2, Mu, Rho);
        time_valid(times) = toc;
        
        %% Test..
        [corrPred(times), corrPreds(times, :)] = testPath(...
            trainData, testData, classNum,...
            optLambda_1, optAlpha, optBeta, ...
            optLambda_2, optMu, optRho);
    end
    
    %% Save data.
    dataFullPath = [resFolder, '/mainExp/Ours/',...
            num2str(testRatio), '_',  num2str(dataSetNum), '.mat'];
    
    if exist(dataFullPath, 'file')
        old_corrPred = load(dataFullPath, 'corrPred');
        
        if mean(corrPred) > mean(old_corrPred.corrPred)
            save(dataFullPath);
            fprintf(' %.4f  -->  %.4f\n', mean(old_corrPred.corrPred), mean(corrPred));
        else
            fprintf(' %.4f  ---  %.4f\n', mean(old_corrPred.corrPred), mean(corrPred));
        end
    else
        fprintf(' --> %.4f\n', mean(corrPred));
        save(dataFullPath);
    end
end
