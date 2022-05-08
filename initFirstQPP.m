function [lambda_1_0, alpha_0, beta_0] = initSecondQPP(F, G, H)
    %% Judging...
    if ~exist('F', 'var')
        global F;
    end

    if ~exist('G', 'var')
        global G;
    end

    if ~exist('H', 'var')
        global H;
    end

    %% Variable...
    global F_inv;
    alpha_0 = ones(size(G, 1), 1);
    beta_0 = ones(size(H, 1), 1);
    lambda_1_0 = 0;
    
    %% Initialize index sets.
    global L_B_1 E_B_1 R_B_1 L_C_1 E_C_1 R_C_1;
    L_B_1 = [1 : size(G, 1)]';
    E_B_1 = [];
    R_B_1 = [];
    L_C_1 = [1 : size(H, 1)]';
    E_C_1 = [];
    R_C_1 = [];

    %% For B
    lambda = G * F_inv * (G' * alpha_0 + H' * beta_0);
    [lambda_max, idx_max] = max(lambda);
    if lambda_1_0 < lambda_max
        lambda_1_0 = lambda_max;
        L_B_1 = setdiff(L_B_1, idx_max);
        E_B_1 = sort([E_B_1; idx_max]);
    end
    
    %% For C
    global epsilon;
    lambda = 1 / (1 - epsilon) * H * F_inv * (G' * alpha_0 + H' * beta_0);
    [lambda_max, idx_max] = max(lambda);
    if lambda_1_0 < lambda_max
        lambda_1_0 = lambda_max;
        L_C_1 = setdiff(L_C_1, idx_max);
        E_C_1 = sort([E_C_1; idx_max]);
        L_B_1 = [1 : size(G, 1)]';
        E_B_1 = [];
    end

    %% Print Info.
%     fprintf('-----------------Initialize QPP 1-----------------\n');
%     fprintf('lambda_1_0 = %.4f\n', lambda_1_0);
%     fprintf('--------------------------------------------------\n');
end