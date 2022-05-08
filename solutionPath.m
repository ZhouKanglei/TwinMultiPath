function [lambda_1, alpha, beta, event_1, ...
    lambda_2, mu, rho, event_2] = solutionPath(F, G, H)
    %% Initialization
    [lambda_1_0, alpha_0, beta_0] = initFirstQPP(F, G, H);
    [lambda_2_0, mu_0, rho_0] = initSecondQPP(F, G, H);
    
    %% QPP solving.
    [lambda_1, alpha, beta, event_1] = pathFirstQPP(...
        lambda_1_0, alpha_0, beta_0, F, G, H);
    [lambda_2, mu, rho, event_2] = pathSecondQPP(...
        lambda_2_0, mu_0, rho_0, F, G, H);
    
end