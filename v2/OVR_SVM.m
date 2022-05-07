%% Clear Window...
clc;
clear all;
close all;

dataRange = [6];

%% Global variables...
globalVars();

if ~exist([resFolder, '/mainExp'], 'dir')
    mkdir([resFolder, '/mainExp']);
end

if ~exist([resFolder, '/mainExp/OVR_SVM'], 'dir')
    mkdir([resFolder, '/mainExp/OVR_SVM']);
end

%% Iteration.
for dataSetNum = dataRange
    for times = 1 : 10
        [trainData, testData, classNum, dataSetName] = loadData(dataSetNum);
        
        tic;
        %% Training.
        X = trainData(:, 2 : end);
        y = trainData(:, 1);
        for classNum_i = 1 : classNum
            y(trainData(:, 1) == classNum_i) = 1;
            y(trainData(:, 1) ~= classNum_i) = -1;

            SVMModels{classNum_i} = fitcsvm(X, y, ...
             'ClassName', [1 -1], 'Standardize', norm);
        end
        time(times) = toc;

        %% Test.
        testX = testData(:, 2 : end);
        testY = testData(:, 1);
        testNum = size(testX, 1);
        Scores = zeros(testNum, classNum);
        for classNum_i = 1 : classNum
            [labels, score] = predict(SVMModels{classNum_i}, testX);
            Scores(:, classNum_i) = score(:, 1); 
        end
        [~, maxScore] = max(Scores'); 

        corrPred(times) = sum(testY == maxScore') / testNum * 100;
    end
    %% Save data.
    dataFullPath = [resFolder, '/mainExp/OVR_SVM/',...
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