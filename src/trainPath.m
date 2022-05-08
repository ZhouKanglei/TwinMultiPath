function [Lambda_1, Alpha, Beta, ...
    Lambda_2, Mu, Rho,...
    event_1, event_2] = trainPath(trainData, classNum)

    %% Train.
    numCnt = 0;
    for class_i = 1 : classNum
        for class_j = class_i + 1 : classNum
            numCnt = numCnt + 1;
            %% Divid Data.
            [F, G, H, trainDataSplit] = splitData(trainData, class_i, class_j);

            %% Solution path for Twin Multi-class support vector
            [lambda_1, alpha, beta, event_1(:, numCnt), ...
                lambda_2, mu, rho, event_2(:, numCnt)] = solutionPath(F, G, H);

            %% Logs
            Lambda_1{numCnt} = lambda_1;
            Alpha{numCnt}= alpha;
            Beta{numCnt} = beta;
            Lambda_2{numCnt} = lambda_2;
            Mu{numCnt} = mu;
            Rho{numCnt} = rho;
        end
    end
    
    %% Print Info
    global interval;
    fprintf('------------------Training path-------------------\n');
    for e = 1 : 8
        fprintf([' Event %d ', interval], e);
    end
    fprintf(' Total\n');
   
    for e = 1 : 8
        fprintf([' %d ', interval], sum(event_1(e, :)));
    end
    fprintf(' %d\n', sum(event_1(9, :)));
    
    for e = 1 : 8
        fprintf([' %d ', interval], sum(event_2(e, :)));
    end
    fprintf(' %d\n', sum(event_2(9, :)));
    fprintf('--------------------------------------------------\n');
end