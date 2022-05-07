%% Clear Window...
clc;
clear all;
close all;

%% Global variables...
globalVars();

dataRange = [8 14];
distOpt = 1;
epsilon = 0.1;

if ~exist([resFolder, '/mainExp'], 'dir')
    mkdir([resFolder, '/mainExp']);
end

if ~exist([resFolder, '/mainExp/OVOVR_TSVM'], 'dir')
    mkdir([resFolder, '/mainExp/OVOVR_TSVM']);
end

event_1_all = zeros(9, 13);
event_2_all = zeros(9, 13);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% OVOVR TSVM
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for dataSetNum = dataRange
    for times = 1 : 10
        [trainData, testData, classNum] = loadData(dataSetNum);
        %% OVOVR TSVM Training...
        tic;
        [QPPLambda_1, QPPAlpha, QPPBeta, ...
            QPPLambda_2, QPPMu, QPPRho] = multiTSVM(trainData, ...
            classNum, lambda_one, lambda_two);
        time(times) = toc;
        
        %% Test..
        corrPred(times) = testPath(...
            trainData, testData, classNum,...
            QPPLambda_1, QPPAlpha, QPPBeta, ...
            QPPLambda_2, QPPMu, QPPRho);
    end
    
    %% Save data.
    dataFullPath = [resFolder, '/mainExp/OVOVR_TSVM/',...
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

