function [corrPred, corrPreds] = testPath(trainData, testData, classNum,...
    optLambda_1, optAlpha, optBeta, ...
    optLambda_2, optMu, optRho)
    %% Test.
    numCnt = 0;
    Y = zeros(size(testData, 1), classNum);
    y = testData(:, 1);
    ySplit = zeros(size(y));
    for class_i = 1 : classNum
        for class_j = class_i + 1 : classNum
            numCnt = numCnt + 1;
            testDataSplit = testData;
            ySplit(y == class_i) = 1;
            ySplit(y == class_j) = -1;
            ySplit(y ~= class_i & y ~= class_j) = 0;
            testDataSplit(:, 1) = ySplit;

            [F, G, H, trainDataSplit] = splitData(trainData, class_i, class_j);
            %% Predict.
            [corrRatio, ySplit_pred] = predictData(testDataSplit, ...
                optLambda_1(numCnt), optAlpha{numCnt}, optBeta{numCnt}, ...
                optLambda_2(numCnt), optMu{numCnt}, optRho{numCnt});

            Y(:, class_i) = Y(:, class_i) + ySplit_pred(:, 1);
            Y(:, class_j) = Y(:, class_j) + ySplit_pred(:, 2);
        end
    end
    %% Calculate the final prediction acc.
    [~, y_pred] = max(Y');
    for class_i =  1 : classNum
        class_i_idx = find(y == class_i);
        corrPreds(class_i) = ...
            sum(y_pred(class_i_idx)' == y(class_i_idx)) ...
            / length(class_i_idx) * 100;
    end
    corrPred = sum(y_pred' == y) / length(y) * 100;
    
    %% Print Info.
    fprintf('-------------------Prediction--------------------\n');
    fprintf('Prediction accruary: %.4f\n', corrPred);
    fprintf('--------------------------------------------------\n');
end
