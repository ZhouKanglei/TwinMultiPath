function [corrRatio, y_pred] = predictData(...
    data, lambda_1, alpha, beta, lambda_2, mu, rho, id)
    
    if ~exist('id', 'var')
        id = '';
    end

    %% Global vars.
    global F G H F_inv G_inv;
    numTrainingSum = size([F; G; H], 1);
    
    y = data(:, 1);
    X = data(:, 2 : end);
    X = [X ones(size(data, 1), 1)];
    
    %% Calculate.
    u = - 1 / lambda_1 * F_inv * (G' * alpha + H' * beta);
    f_1 = X * u;
    w_1 = u(1 : end - 1);
    b_1 = u(end);
    
    v = 1 / lambda_2 * G_inv * (F' * mu + H' * rho);
    f_2 = X * v;
    w_2 = v(1 : end - 1);
    b_2 = v(end);
    
    %% Global
    global epsilon;
    
    c_1 = abs(f_1) ./ sqrt(w_1' * w_1);
    c_2 = abs(f_1 + 1 - epsilon) ./ sqrt(w_1' * w_1);
    c_3 = abs(f_1 + 1) ./ sqrt(w_1' * w_1);
    
    d_1 = abs(f_2) ./ sqrt(w_2' * w_2);
    d_2 = abs(f_2 - 1 + epsilon) ./ sqrt(w_2' * w_2);
    d_3 = abs(f_2 - 1) ./ sqrt(w_2' * w_2);
    
    dist = [c_1 c_2 c_3 d_1 d_2 d_3];
    [~, pos] = min(dist');

    y_pred = zeros(size(y, 1), 2);
    
    global distOpt;
    if distOpt == 1
        y_pred = zeros(size(y, 1), 2);
        y_pred((f_1 > -1 + epsilon), 1) = 1;
        y_pred((f_2 < 1 - epsilon), 2) = 1;
        
        y_pred((y_pred(:, 1) == 1 & y_pred(:, 2) == 1), 1) = 0;
        y_pred((y_pred(:, 1) == 1 & y_pred(:, 2) == 1), 2) = 0;
        
    end
        
    if distOpt == 2
        y_pred = zeros(size(y, 1), 2);
        y_pred((pos' == 1), 1) = 1;
        y_pred((pos' == 4), 2) = 1;
        
        y_pred((y_pred(:, 1) == y_pred(:, 2)), 1) = 0;
        y_pred((y_pred(:, 1) == y_pred(:, 2)), 2) = 0;
        
    end

    if distOpt == 3
        y_pred = zeros(size(y, 1), 2);
        y_pred((pos' == 1), 1) = 1;
        y_pred((pos' == 4), 2) = 1;
        
        y_pred((y_pred(:, 1) == y_pred(:, 2)), 1) = -0.5;
        y_pred((y_pred(:, 1) == y_pred(:, 2)), 2) = -0.5;

        y_pred((pos' == 2 & d_1 < c_1), 1) = -1;
        y_pred((pos' == 5 & d_1 > c_1), 2) = -1;
    end
    
    corrRatio = sum(y_pred(:, 1) - y_pred(:, 2) == y) / length(y) * 100;
    if strlength(id) ~= 0
        save(['res/mix/plot_dist_', id, '.mat']);
        fprintf('save %s', ['plot_dist_', id, '.mat']);
    end
end
