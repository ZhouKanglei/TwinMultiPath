function [F, G, H, trainDataSplit] = splitData(Data, class_i, class_j)
    %% Judge...
    if ~exist('class_i', 'var') | ~exist('class_j', 'var')
        class_i = 1;
        class_j = 2;
    end
    
    trainDataSplit = Data;
    y = Data(:, 1);
    ySplit(y == class_i) = 1;
    ySplit(y == class_j) = - 1;
    ySplit(y ~= class_i & y ~= class_j) = 0;
    trainDataSplit(:, 1) = ySplit;
    
    Data = [Data ones(size(Data, 1), 1)];
    
    %% Data Info.
    num_class = unique(Data(:, 1));
    [n, m] = size(Data);
    m = m - 2;
    
    %% Divid Data into F, G, H.
    global F G H;
    F = [];
    G = [];
    H = [];

    for i = 1 : length(num_class)
        class_idx = find(Data(:, 1) == num_class(i));
        if class_i == num_class(i)
            F = [F; Data(class_idx, 2 : end)];
        elseif class_j == num_class(i)
            G = [G; Data(class_idx, 2 : end)];
        else
            H = [H; Data(class_idx, 2 : end)];
        end
    end
    %% Calculate F_inv & G_inv
    global delta F_inv G_inv;
    I = eye(m + 1);
    F_inv = inv(F' * F + delta * I);
    G_inv = inv(G' * G + delta * I);
    
    %% Print Split results.
%     fprintf('---------------Split Training Set----------------\n');
%     fprintf(['Class %d & Class %d & Rest \n'],...
%         class_i, class_j);
%     fprintf(['Training set: %d + %d + %d = %d\n'],...
%         size(F, 1), size(G, 1), size(H, 1), size(trainDataSplit, 1));
%     fprintf('--------------------------------------------------\n');
end