function [lambda_1, alpha, beta, event_1] = pathFirstQPP(...
    lambda_1_0, alpha_0, beta_0, F, G, H)
    %% Index sets
    global L_B_1 E_B_1 R_B_1 L_C_1 E_C_1 R_C_1;
    
    %% global vars
    global l_max lambda_min F_inv;
    global epsilon delta;
    
    %% 1st step paras.
    l = 1;
    lambda_1(l, 1) = lambda_1_0;
    alpha(:, l) = alpha_0;
    beta(:, l) = beta_0;
    
    f_B(:, l) = - 1 / lambda_1(l, 1) * G * F_inv * (G' * alpha(:, l) + H' * beta(:, l));
    f_C(:, l) = - 1 / lambda_1(l, 1) * H * F_inv * (G' * alpha(:, l) + H' * beta(:, l));
    
    %% Iteration.
    while l <= l_max && lambda_1(l) >= lambda_min
        E_BC = [G(E_B_1, :); H(E_C_1, :)] * F_inv * [G(E_B_1, :); H(E_C_1, :)]';
        
        n_EB = length(E_B_1);
        n_EC = length(E_C_1);
        
%         if n_EB ~= 0 | n_EC ~= 0
            theta = inv(E_BC + delta * eye(size(E_BC, 1))) ...
                * [ones(n_EB, 1); (1 - epsilon) * ones(n_EC, 1)];
            
            theta_B = theta(1 : n_EB);
            theta_C = theta(n_EB + 1 : n_EC + n_EB);
%         end
        
        f_B_1(:, l) = - 1 / lambda_1(l, 1) *  G * F_inv * (G' * alpha(:, l) + H' * beta(:, l));
        f_C_1(:, l) = - 1 / lambda_1(l, 1) *  H * F_inv * (G' * alpha(:, l) + H' * beta(:, l));

        g(:, l) = [G; H] * F_inv * [G(E_B_1, :); H(E_C_1, :)]' * theta;
        g_B(:, l) = G * F_inv * [G(E_B_1, :); H(E_C_1, :)]' * theta;
        g_C(:, l) = H * F_inv * [G(E_B_1, :); H(E_C_1, :)]' * theta;
             
        %% Events
        pos = zeros(8, 1);
        % Event 1
        if n_EB ~= 0
            lambda_1_1_all = lambda_1(l) - (alpha(E_B_1, l) - 1) ./ theta_B;
            lambda_1_1_1 = lambda_1_1_all;
            lambda_1_1_1(lambda_1_1_1 >= lambda_1(l)) = 0;
            [lambda_1_1, idx] = max(lambda_1_1_1);
            
            pos(1) = E_B_1(idx);
        else
            lambda_1_1 = 0;
        end
        
        % Event 2
        if n_EB ~= 0
            lambda_1_2_all = lambda_1(l) - alpha(E_B_1, l) ./ theta_B;
            lambda_1_2_1 = lambda_1_2_all;
            lambda_1_2_1(lambda_1_2_1 >= lambda_1(l)) = 0;
            [lambda_1_2, idx] = max(lambda_1_2_1);
            
            pos(2) = E_B_1(idx);
        else
            lambda_1_2 = 0;
        end
        
        % Event 3
        if length(L_B_1) ~= 0
            lambda_1_3_all = lambda_1(l) *  (f_B(L_B_1, l) + g_B(L_B_1, l))...
                ./ -1 + g_B(L_B_1, l);
            lambda_1_3_1 = lambda_1_3_all;
            lambda_1_3_1(lambda_1_3_1 >= lambda_1(l)) = 0;
            [lambda_1_3, idx] = max(lambda_1_3_1);
            
            pos(3) = L_B_1(idx);
        else
            lambda_1_3 = 0;
        end
        
        % Event 4
        if length(R_B_1) ~= 0
            lambda_1_4_all = lambda_1(l) *  (f_B(R_B_1, l) + g_B(R_B_1, l))...
                ./ -1 + g_B(R_B_1, l);
            lambda_1_4_1 = lambda_1_4_all;
            lambda_1_4_1(lambda_1_4_1 >= lambda_1(l)) = 0;
            [lambda_1_4, idx] = max(lambda_1_4_1);
            
            pos(4) = R_B_1(idx);
        else
            lambda_1_4 = 0;
        end     
        
        % Event 5
        if n_EC ~= 0
            lambda_1_5_all = lambda_1(l) - (beta(E_C_1, l) - 1) ./ theta_C;
            lambda_1_5_1 = lambda_1_5_all;
            lambda_1_5_1(lambda_1_5_1 >= lambda_1(l)) = 0;
            [lambda_1_5, idx] = max(lambda_1_5_1);
            
            pos(5) = E_C_1(idx);
        else
            lambda_1_5 = 0;
        end
        
        % Event 6
        if n_EC ~= 0
            lambda_1_6_all = lambda_1(l) - beta(E_C_1, l) ./ theta_C;
            lambda_1_6_1 = lambda_1_6_all;
            lambda_1_6_1(lambda_1_6_1 >= lambda_1(l)) = 0;
            [lambda_1_6, idx] = max(lambda_1_6_1);
            
            pos(6) = E_C_1(idx);
        else
            lambda_1_6 = 0;
        end
        
        % Event 7
        if length(L_C_1) ~= 0
            lambda_1_7_all = lambda_1(l) *  (f_C(L_C_1, l) + g_C(L_C_1, l))...
                ./ - (1 - epsilon) + g_C(L_C_1, l);
            lambda_1_7_1 = lambda_1_7_all;
            lambda_1_7_1(lambda_1_7_1 >= lambda_1(l)) = 0;
            [lambda_1_7, idx] = max(lambda_1_7_1);
            
            pos(7) = L_C_1(idx);
        else
            lambda_1_7 = 0;
        end
        
        % Event 8
        if length(R_C_1) ~= 0
            lambda_1_8_all = lambda_1(l) *  (f_C(R_C_1, l) + g_C(R_C_1, l))...
                ./ - (1 - epsilon) + g_C(R_C_1, l);
            lambda_1_8_1 = lambda_1_8_all;
            lambda_1_8_1(lambda_1_8_1 >= lambda_1(l)) = 0;
            [lambda_1_8, idx] = max(lambda_1_8_1);
            
            pos(8) = R_C_1(idx);
        else
            lambda_1_8 = 0;
        end      
        
        %% First Event
        lambda_1_to_8(:, l) = [lambda_1_1, lambda_1_2, ...
            lambda_1_3, lambda_1_4, lambda_1_5, lambda_1_6, ...
            lambda_1_7, lambda_1_8]';
        [lambda_1_max, e_start(l, 1)] = max(lambda_1_to_8(:, l));
        
        if lambda_1_max < lambda_min
%             fprintf('\nStep %d: Can''t find the next step!\n', l);
            break;
        end
        %% Update
        lambda_1(l + 1, 1) = lambda_1_max;
        
        alpha(:, l + 1) = alpha(:, l);
        beta(:, l + 1) = beta(:, l);
       
        alpha(E_B_1, l + 1) = alpha(E_B_1, l) - ...
            (lambda_1(l) - lambda_1(l + 1)) * theta_B;
        beta(E_C_1, l + 1) = beta(E_C_1, l) - ...
            (lambda_1(l) - lambda_1(l + 1)) * theta_C;
        
        alpha = round(alpha * 100000) / 100000;
        beta = round(beta * 100000) / 100000;
        alpha(alpha > 1) = 1;
        alpha(alpha < 0) = 0;
        beta(beta > 1) = 1;
        beta(beta < 0) = 0;
        
        f_B(:, l + 1) = 1 / lambda_1(l + 1) * (lambda_1(l) * f_B(:, l)...
            + (lambda_1(l) - lambda_1(l + 1)) * g_B(:, l));
        f_C(:, l + 1) = 1 / lambda_1(l + 1) * (lambda_1(l) * f_C(:, l)...
            + (lambda_1(l) - lambda_1(l + 1)) * g_C(:, l));
        
        idx_max(l) = pos(e_start(l));
        
   		% Event 1
        if e_start(l) == 1
            E_B_1 = setdiff(E_B_1, idx_max(l));
            L_B_1 = sort([L_B_1; idx_max(l)]);
        end
 
        % Event 2
        if e_start(l) == 2
            E_B_1 = setdiff(E_B_1, idx_max(l));
            R_B_1 = sort([R_B_1; idx_max(l)]);
        end

        % Event 3
        if e_start(l) == 3
            L_B_1 = setdiff(L_B_1, idx_max(l));
            E_B_1 = sort([E_B_1; idx_max(l)]);
        end
 
        % Event 4
        if e_start(l) == 4
            R_B_1 = setdiff(R_B_1, idx_max(l));
            E_B_1 = sort([E_B_1; idx_max(l)]);
        end
        
        % Event 5
        if e_start(l) == 5
            E_C_1 = setdiff(E_C_1, idx_max(l));
            L_C_1 = sort([L_C_1; idx_max(l)]);
        end
 
        % Event 6
        if e_start(l) == 6
            E_C_1 = setdiff(E_C_1, idx_max(l));
            R_C_1 = sort([R_C_1; idx_max(l)]);
        end

        % Event 7
        if e_start(l) == 7
            L_C_1 = setdiff(L_C_1, idx_max(l));
            E_C_1 = sort([E_C_1; idx_max(l)]);
        end
 
        % Event 8
        if e_start(l) == 8
            R_C_1 = setdiff(R_C_1, idx_max(l));
            E_C_1 = sort([E_C_1; idx_max(l)]);
        end
        
        l = l + 1;
    end
    
    %% Print Events.
%     global interval;
%     fprintf('--------------------------------------------------\n');
%     for e = 1 : 8
%         fprintf([' Event %d ', interval], e);
%     end
%     fprintf(' Total\n');
   
    event_1 = zeros(9, 1);
    for e = 1 : 8
        event_1(e) = length(find(e_start == e));
%         fprintf([' %d ', interval], event_1(e));
    end
    event_1(9) = length(e_start);
%     fprintf(' %d\n', event_1(9));
%     fprintf('--------------------------------------------------\n');
end