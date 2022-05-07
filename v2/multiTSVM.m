function [Lambda_1, Alpha, Beta, ...
    Lambda_2, Mu, Rho] = multiTSVM(trainData, classNum, lambda_one, lambda_two)
    %% Train.
    numCnt = 0;
    
    for class_i = 1 : classNum
        for class_j = class_i + 1 : classNum
            numCnt = numCnt + 1;
            
            %% Divid Data.
            [F, G, H] = splitData(trainData, class_i, class_j);
        
            %% Solution path for Twin Multi-class support vector
            [alpha, beta, mu, rho] = TSVMSplit(F, G, H, lambda_one, lambda_two);
            
            %% Logs
            Lambda_1(numCnt) = lambda_one;
            Alpha{numCnt}= alpha;
            Beta{numCnt} = beta;
            Lambda_2(numCnt) = lambda_two;
            Mu{numCnt} = mu;
            Rho{numCnt} = rho;
        end
    end
end

function [alpha, beta, mu, rho] = TSVMSplit(F, G, H, lambda_one, lambda_two)
    %% Global vars.
    global F_inv G_inv epsilon;
    
    c_1 = 1 / lambda_one;
    c_2 = 1 / lambda_two;
    
    e_A = ones(size(F, 1), 1);
    e_B = ones(size(G, 1), 1);
    e_C = ones(size(H, 1), 1);
    
    %% QPP 1
    GH = [G; H];
    H_one = GH * F_inv * GH';
    f_one = - [e_B; e_C * (1 - epsilon)];
    
    ub_one = c_1 * [e_B; e_C];
    lb_one = 0 * ub_one;
    
    eta_one = quadprog(H_one, f_one, [], [], [], [], lb_one, ub_one);
    eta_one = eta_one * lambda_one;
    alpha = eta_one(1 : length(e_B));
    beta = eta_one(length(e_B) + 1 : end);
    
    %% QPP 2
    FH = [F; H];
    H_two = FH * G_inv * FH';
    f_two = - [e_A; e_C * (1 - epsilon)];
    
    ub_two = c_2 * [e_A; e_C];
    lb_two = 0 * ub_two;
    
    eta_two = quadprog(H_two, f_two, [], [], [], [], lb_two, ub_two);
    eta_two = eta_two * lambda_two;
    mu = eta_two(1 : length(e_A));
    rho = eta_two(length(e_A) + 1 : end);
end

function [alpha_one, beta_one] = ...
    Opt(F, G, H, lambda_one, lambda_two)
    
    global epsilon delta;
    
    c1 = 1 / lambda_one;
    c2 = 1 / lambda_two;

    %%
    e1 = ones(size(F, 1), 1);
    e2 = ones(size(G, 1), 1);
    e3 = ones(size(H, 1), 1);

    N = [G; H];
    I = eye(size(F' * F));
    %%
    H_one = N * inv(F' * F + delta * I) * N';
    f_one = - [e2;  e3 * (1 - epsilon)];
    b = [c1 * e2; c2 * e3];
    lb_one = 0 * b;
    ub_one = b;

    eta = quadprog(H_one, f_one, [], [], [], [], lb_one, ub_one);
    eta = lambda_one * eta;
    alpha_one = eta(1 : length(e2));
    beta_one = eta(length(e2) + 1 : end);

end