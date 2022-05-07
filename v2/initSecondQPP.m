function [lambda_2_0, mu_0, rho_0] = initSecondQPP(F, G, H)
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
    global G_inv;
    mu_0 = ones(size(F, 1), 1);
    rho_0 = ones(size(H, 1), 1);
    lambda_2_0 = 0;
    
    %% Initialize index sets.
    global L_A_2 E_A_2 R_A_2 L_C_2 E_C_2 R_C_2;
    L_A_2 = [1 : size(F, 1)]';
    E_A_2 = [];
    R_A_2 = [];
    L_C_2 = [1 : size(H, 1)]';
    E_C_2 = [];
    R_C_2 = [];

    %% For A
    lambda = F * G_inv * (F' * mu_0 + H' * rho_0);
    [lambda_max, idx_max] = max(lambda);
    if lambda_2_0 < lambda_max
        lambda_2_0 = lambda_max;
        L_A_2 = setdiff(L_A_2, idx_max);
        E_A_2 = sort([E_A_2; idx_max]);
    end
    
    %% For C
    global epsilon;
    lambda = 1 / (1 - epsilon) * H * G_inv * (F' * mu_0 + H' * rho_0);
    [lambda_max, idx_max] = max(lambda);
    if lambda_2_0 < lambda_max
        lambda_2_0 = lambda_max;
        L_C_2 = setdiff(L_C_2, idx_max);
        E_C_2 = sort([E_C_2; idx_max]);
        L_A_2 = [1 : size(F, 1)]';
        E_A_2 = [];
    end
    
    %% Print Info.
%     fprintf('-----------------Initialize QPP 2-----------------\n');
%     fprintf('lambda_2_0 = %.4f\n', lambda_2_0);
%     fprintf('--------------------------------------------------\n');
end