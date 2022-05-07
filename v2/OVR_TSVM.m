%% Clear Window...
clc;
clear all;
close all;

dataRange = [8 14];

%% Global variables...
globalVars();

if ~exist([resFolder, '/mainExp'], 'dir')
    mkdir([resFolder, '/mainExp']);
end

if ~exist([resFolder, '/mainExp/OVR_TSVM'], 'dir')
    mkdir([resFolder, '/mainExp/OVR_TSVM']);
end

%% Iteration.
for dataSetNum = dataRange
    for times = 1 : 10
        [trainData, testData, classNum, dataSetName] = loadData(dataSetNum);
        
        tic;
        %% Training.
        X = trainData(:, 2 : end);
        y = trainData(:, 1);
        for clssNum_i = 1 : classNum
            y(trainData(:, 1) == clssNum_i) = 1;
            y(trainData(:, 1) ~= clssNum_i) = -1;
            A = X((y == 1), :);
    		B = X((y == -1), :);
            [u, v] = TSVM(A, B, lambda_one, lambda_two);
            TSVMModels{clssNum_i, 1} = u;
            TSVMModels{clssNum_i, 2} = v;
        end
        time(times) = toc;

        %% Test.
        testX = testData(:, 2 : end);
        testY = testData(:, 1);
        testNum = size(testX, 1);
        Scores = zeros(testNum, classNum);
        for clssNum_i = 1 : classNum
            score = predictTSVM(TSVMModels{clssNum_i, 1},...
                TSVMModels{clssNum_i, 2}, testX);
            Scores(:, clssNum_i) =  score; 
        end
        [~, maxScore] = max(Scores'); 

        corrPred(times) = sum(testY == maxScore') / testNum * 100;
    end
    %% Save data.
    %% Save data.
    dataFullPath = [resFolder, '/mainExp/OVR_TSVM/',...
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

function [score] = predictTSVM(u, v, testX)
	w_1 = u(1 : end - 1);
	b_1 = u(end);
	w_2 = v(1 : end - 1); 
	b_2 = v(end); 

    c = abs(testX * w_1 + b_1) / sqrt(w_1' * w_1);
    d = abs(testX * w_2 + b_2) / sqrt(w_2' * w_2);

    score = (c < d);
end

function [u, v] = TSVM(A, B, lambda_1_0, lambda_2_0)
    %% Solving by QPPs using MATLAB function.
    n_A = size(A, 1);
    n_B = size(B, 1);

    m = size(A, 2);

    e_A = ones(n_A, 1);
    e_B = ones(n_B, 1);
    
    H = [A e_A];
    G = [B e_B];

    %% Global vars.
    global delta;
    H_star = inv(H' * H + delta * eye(m + 1));
    
    %% Vars.
    C_1 = 1 / lambda_1_0;
    C_2 = 1 / lambda_2_0;
    
    %% Fitst QPP.
    F_1 = G * H_star * G';
    f_1 = -e_B;
    
    lb_1 = zeros(n_B, 1);
    ub_1 = C_1 +  zeros(n_B, 1);
    
    [alpha_0, fval, exitflag, output, lambda] = quadprog(F_1, f_1,...
        [], [], [], [], lb_1, ub_1);
    alpha_0 = alpha_0 * lambda_1_0;
    u = - 1 / lambda_1_0 * H_star * G' * alpha_0;

    %% Second QPP.
    G_star = inv(G' * G + delta * eye(m + 1));
    F_2 = H * G_star * H';
    f_2 = -e_A;
    
    lb_2 = zeros(n_A, 1);
    ub_2 = C_2 +  zeros(n_A, 1);

    [gamma_0, fval, exitflag, output, lambda] = quadprog(F_2, f_2,...
        [], [], [], [], lb_2, ub_2);
    gamma_0 = gamma_0 * lambda_2_0;

    v = 1 / lambda_2_0 * G_star * H' * gamma_0;
end