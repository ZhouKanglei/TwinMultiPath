function [optLambda_1, optAlpha, optBeta, ...
    optLambda_2, optMu, optRho] = validPath(...
    trainData, validData, classNum, ...
    Lambda_1, Alpha, Beta, ...
    Lambda_2, Mu, Rho)
    
    fprintf('Validating...\n');
    %% Vaild.
    numCnt = 0;
    for class_i = 1 : classNum
        for class_j = class_i + 1 : classNum
            numCnt = numCnt + 1;
            %% Divid Data.
            [F, G, H, trainDataSplit] = splitData(trainData, class_i, class_j);
            
            lambda_1 = Lambda_1{numCnt};
            alpha = Alpha{numCnt};
            beta = Beta{numCnt};
            lambda_2 = Lambda_2{numCnt};
            mu = Mu{numCnt};
            rho = Rho{numCnt};
            
            [optIdx_1, optIdx_2, optRatio] = validOpt(...
                trainDataSplit, lambda_1, alpha, beta, ...
                lambda_2, mu, rho);

            %% Logs
            optLambda_1(numCnt) = lambda_1(optIdx_1);
            optAlpha{numCnt} = alpha(:, optIdx_1);
            optBeta{numCnt} = beta(:, optIdx_1);
            optLambda_2(numCnt) = lambda_2(optIdx_2);
            optMu{numCnt} = mu(:, optIdx_2);
            optRho{numCnt} = rho(:, optIdx_2);
	    
	    fprintf('\t%d - %d, max_acc = %.4f, opt = (%d, %d)\n', class_i, class_j, optRatio, optIdx_1, optIdx_2);
        end
    end
    fprintf('Done!\n');
end


function [optIdx_1, optIdx_2, corrMaxRatio, corrRatio] = validOpt(...
    vaildData, lambda_1, alpha, beta, ...
    lambda_2, mu, rho)
   %% Iteration
   corrMaxRatio = 0;
   step_1 = 1;
   step_2 = 1;

   if length(lambda_1) > 500 || length(lambda_2) > 500
    step_1 = round(2);
    step_2 = round(2);
   end

   if length(lambda_1) > 600 || length(lambda_2) > 600
    step_1 = round(3);
    step_2 = round(3);
   end

   for one = 1 : step_1 : length(lambda_1)
       for two = 1 : step_2 : length(lambda_2)
           corrRatio(one, two) = predictData(vaildData, ...
               lambda_1(one), alpha(:, one), beta(:, one), ...
               lambda_2(two), mu(:, two), rho(:, two));
           if corrMaxRatio < corrRatio(one, two)
               corrMaxRatio = corrRatio(one, two);
               optIdx_1 = one;
               optIdx_2 = two;
           end
       end
   end
end
