function [lambda_2, mu, rho, event_2] = pathSecondQPP(...
    lambda_2_0, mu_0, rho_0, F, G, H)
    %% Index sets
    global L_A_2 E_A_2 R_A_2 L_C_2 E_C_2 R_C_2;
    
    %% global vars
    global l_max lambda_min G_inv;
    global epsilon delta;
    
    %% 1st step paras.
    l = 1;
    lambda_2(l, 1) = lambda_2_0;
    mu(:, l) = mu_0;
    rho(:, l) = rho_0;
    
    f_A(:, l) = 1 / lambda_2(l, 1) * F * G_inv * (F' * mu(:, l) + H' * rho(:, l));
    f_C(:, l) = 1 / lambda_2(l, 1) * H * G_inv * (F' * mu(:, l) + H' * rho(:, l));
    
    %% Iteration.
    while l <= l_max && lambda_2(l) >= lambda_min
        E_BC = [F(E_A_2, :); H(E_C_2, :)] * G_inv * [F(E_A_2, :); H(E_C_2, :)]';
        
        n_EA = length(E_A_2);
        n_EC = length(E_C_2);
        
%         if n_EA ~= 0 | n_EC ~= 0
            vartheta = inv(E_BC + delta * eye(size(E_BC, 1))) ...
                * [ones(n_EA, 1); (1 - epsilon) * ones(n_EC, 1)];
            
            vartheta_A = vartheta(1 : n_EA);
            vartheta_C = vartheta(n_EA + 1 : n_EC + n_EA);
%         end
        
        f_A_2(:, l) = 1 / lambda_2(l, 1) *  F * G_inv * (F' * mu(:, l) + H' * rho(:, l));
        f_C_2(:, l) = 1 / lambda_2(l, 1) *  H * G_inv * (F' * mu(:, l) + H' * rho(:, l));

        h(:, l) = [F; H] * G_inv * [F(E_A_2, :); H(E_C_2, :)]' * vartheta;
        h_A(:, l) = F * G_inv * [F(E_A_2, :); H(E_C_2, :)]' * vartheta;
        h_C(:, l) = H * G_inv * [F(E_A_2, :); H(E_C_2, :)]' * vartheta;
             
        %% Events
        pos = zeros(8, 1);
        % Event 1
        if n_EA ~= 0
            lambda_2_1_all = lambda_2(l) - (mu(E_A_2, l) - 1) ./ vartheta_A;
            lambda_2_1_1 = lambda_2_1_all;
            lambda_2_1_1(lambda_2_1_1 >= lambda_2(l)) = 0;
            [lambda_2_1, idx] = max(lambda_2_1_1);
            
            pos(1) = E_A_2(idx);
        else
            lambda_2_1 = 0;
        end
        
        % Event 2
        if n_EA ~= 0
            lambda_2_2_all = lambda_2(l) - mu(E_A_2, l) ./ vartheta_A;
            lambda_2_2_1 = lambda_2_2_all;
            lambda_2_2_1(lambda_2_2_1 >= lambda_2(l)) = 0;
            [lambda_2_2, idx] = max(lambda_2_2_1);
            
            pos(2) = E_A_2(idx);
        else
            lambda_2_2 = 0;
        end
        
        % Event 3
        if length(L_A_2) ~= 0
            lambda_2_3_all = lambda_2(l) *  (f_A(L_A_2, l) - h_A(L_A_2, l))...
                ./ 1 - h_A(L_A_2, l);
            lambda_2_3_1 = lambda_2_3_all;
            lambda_2_3_1(lambda_2_3_1 >= lambda_2(l)) = 0;
            [lambda_2_3, idx] = max(lambda_2_3_1);
            
            pos(3) = L_A_2(idx);
        else
            lambda_2_3 = 0;
        end
        
        % Event 4
        if length(R_A_2) ~= 0
            lambda_2_4_all = lambda_2(l) *  (f_A(R_A_2, l) - h_A(R_A_2, l))...
                ./ 1 - h_A(R_A_2, l);
            lambda_2_4_1 = lambda_2_4_all;
            lambda_2_4_1(lambda_2_4_1 >= lambda_2(l)) = 0;
            [lambda_2_4, idx] = max(lambda_2_4_1);
            
            pos(4) = R_A_2(idx);
        else
            lambda_2_4 = 0;
        end     
        
        % Event 5
        if n_EC ~= 0
            lambda_2_5_all = lambda_2(l) - (rho(E_C_2, l) - 1) ./ vartheta_C;
            lambda_2_5_1 = lambda_2_5_all;
            lambda_2_5_1(lambda_2_5_1 >= lambda_2(l)) = 0;
            [lambda_2_5, idx] = max(lambda_2_5_1);
            
            pos(5) = E_C_2(idx);
        else
            lambda_2_5 = 0;
        end
        
        % Event 6
        if n_EC ~= 0
            lambda_2_6_all = lambda_2(l) - rho(E_C_2, l) ./ vartheta_C;
            lambda_2_6_1 = lambda_2_6_all;
            lambda_2_6_1(lambda_2_6_1 >= lambda_2(l)) = 0;
            [lambda_2_6, idx] = max(lambda_2_6_1);
            
            pos(6) = E_C_2(idx);
        else
            lambda_2_6 = 0;
        end
        
        % Event 7
        if length(L_C_2) ~= 0
            lambda_2_7_all = lambda_2(l) *  (f_C(L_C_2, l) - h_C(L_C_2, l))...
                ./ (1 - epsilon) - h_C(L_C_2, l);
            lambda_2_7_1 = lambda_2_7_all;
            lambda_2_7_1(lambda_2_7_1 >= lambda_2(l)) = 0;
            [lambda_2_7, idx] = max(lambda_2_7_1);
            
            pos(7) = L_C_2(idx);
        else
            lambda_2_7 = 0;
        end
        
        % Event 8
        if length(R_C_2) ~= 0
            lambda_2_8_all = lambda_2(l) *  (f_C(R_C_2, l) - h_C(R_C_2, l))...
                ./ (1 - epsilon) - h_C(R_C_2, l);
            lambda_2_8_1 = lambda_2_8_all;
            lambda_2_8_1(lambda_2_8_1 >= lambda_2(l)) = 0;
            [lambda_2_8, idx] = max(lambda_2_8_1);
            
            pos(8) = R_C_2(idx);
        else
            lambda_2_8 = 0;
        end      
        
        %% First Event
        lambda_1_to_8(:, l) = [lambda_2_1, lambda_2_2, ...
            lambda_2_3, lambda_2_4, lambda_2_5, lambda_2_6, ...
            lambda_2_7, lambda_2_8]';
        [lambda_2_max, e_start(l, 1)] = max(lambda_1_to_8(:, l));
        
        if lambda_2_max < lambda_min
%             fprintf('\nStep %d: Can''t find the next step!\n', l);
            break;
        end
        %% Update
        lambda_2(l + 1, 1) = lambda_2_max;
        
        mu(:, l + 1) = mu(:, l);
        rho(:, l + 1) = rho(:, l);
       
        mu(E_A_2, l + 1) = mu(E_A_2, l) - ...
            (lambda_2(l) - lambda_2(l + 1)) * vartheta_A;
        rho(E_C_2, l + 1) = rho(E_C_2, l) - ...
            (lambda_2(l) - lambda_2(l + 1)) * vartheta_C;
        
        mu = round(mu * 100000) / 100000;
        rho = round(rho * 100000) / 100000;
        mu(mu > 1) = 1;
        mu(mu < 0) = 0;
        rho(rho > 1) = 1;
        rho(rho < 0) = 0;
        
        f_A(:, l + 1) = 1 / lambda_2(l + 1) * (lambda_2(l) * f_A(:, l)...
            - (lambda_2(l) - lambda_2(l + 1)) * h_A(:, l));
        f_C(:, l + 1) = 1 / lambda_2(l + 1) * (lambda_2(l) * f_C(:, l)...
            - (lambda_2(l) - lambda_2(l + 1)) * h_C(:, l));
        
        idx_max(l) = pos(e_start(l));
        
   		% Event 1
        if e_start(l) == 1
            E_A_2 = setdiff(E_A_2, idx_max(l));
            L_A_2 = sort([L_A_2; idx_max(l)]);
        end
 
        % Event 2
        if e_start(l) == 2
            E_A_2 = setdiff(E_A_2, idx_max(l));
            R_A_2 = sort([R_A_2; idx_max(l)]);
        end

        % Event 3
        if e_start(l) == 3
            L_A_2 = setdiff(L_A_2, idx_max(l));
            E_A_2 = sort([E_A_2; idx_max(l)]);
        end
 
        % Event 4
        if e_start(l) == 4
            R_A_2 = setdiff(R_A_2, idx_max(l));
            E_A_2 = sort([E_A_2; idx_max(l)]);
        end
        
        % Event 5
        if e_start(l) == 5
            E_C_2 = setdiff(E_C_2, idx_max(l));
            L_C_2 = sort([L_C_2; idx_max(l)]);
        end
 
        % Event 6
        if e_start(l) == 6
            E_C_2 = setdiff(E_C_2, idx_max(l));
            R_C_2 = sort([R_C_2; idx_max(l)]);
        end

        % Event 7
        if e_start(l) == 7
            L_C_2 = setdiff(L_C_2, idx_max(l));
            E_C_2 = sort([E_C_2; idx_max(l)]);
        end
 
        % Event 8
        if e_start(l) == 8
            R_C_2 = setdiff(R_C_2, idx_max(l));
            E_C_2 = sort([E_C_2; idx_max(l)]);
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
   
    event_2 = zeros(9, 1);
    for e = 1 : 8
        event_2(e) = length(find(e_start == e));
%         fprintf([' %d ', interval], event_2(e));
    end
    event_2(9) = length(e_start);
%     fprintf(' %d\n', event_2(9));
%     fprintf('--------------------------------------------------\n');
end