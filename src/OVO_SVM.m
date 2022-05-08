%% Clear Window...
clc;
clear all;
close all;

dataRange = [12:14];

%% Global variables...
globalVars();

if ~exist([resFolder, '/mainExp'], 'dir')
    mkdir([resFolder, '/mainExp']);
end

if ~exist([resFolder, '/mainExp/OVO_SVM'], 'dir')
    mkdir([resFolder, '/mainExp/OVO_SVM']);
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
            for classNum_j = classNum_i + 1 : classNum  
                X_ij = [X(y == classNum_i, :); X(y == classNum_j, :)];
                y_ij = [zeros(sum(y == classNum_i), 1) + 1; 
                    zeros(sum(y == classNum_j), 1) - 1];

                SVMModels{classNum_i, classNum_j} = fitcsvm(X_ij, y_ij, ...
                 'ClassName', [1 -1], 'Standardize', norm);
            end
        end
        time(times) = toc;

        %% Test.
        testX = testData(:, 2 : end);
        testY = testData(:, 1);
        testNum = size(testX, 1);
        Scores = zeros(testNum, classNum);
        for classNum_i = 1 : classNum
            for classNum_j = classNum_i + 1 : classNum
                [labels, score] = predict(SVMModels{classNum_i, classNum_j} , testX);
                
                pre_score_i = zeros(testNum, 1);
                pre_score_i(labels == 1) = 1;
                
                pre_score_j = zeros(testNum, 1);
                pre_score_j(labels == -1) = 1;   
                
                Scores(:, classNum_i) = Scores(:, classNum_i) + pre_score_i; 
                Scores(:, classNum_j) = Scores(:, classNum_j) + pre_score_j; 
            end
        end
        [~, maxScore] = max(Scores'); 

        corrPred(times) = sum(testY == maxScore') / testNum * 100;
    end
    %% Save data.
    dataFullPath = [resFolder, '/mainExp/OVO_SVM/',...
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