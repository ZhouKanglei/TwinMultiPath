function [trainData, testData, classNum, filename] = loadData(...
    dataSetNum)
    %% Global data path...
    global dataPath dataSetName interval testRatio norm;

    % Default interval char between cells of table.
    if ~exist('interval', 'var')
        interval = '\t';
    end
    
    if ~exist('dataSetNum', 'var')
        dataSetNum = 1;
    end
    
    if size(dataSetNum, 1) ~= 1 | size(dataSetNum, 2) ~= 1 | rem(dataSetNum, 1) ~= 0
        fprintf('Error------dataSetNum must be a positive integer.\n');
        Data = [];
        filename = '';
        return;
    end
    
    %% Obtain all the # Datasets in the fileFolder.
    fileFolder = fullfile(dataPath);
    dirOutput = dir(fullfile(fileFolder, '*.mat'));
    fileNames = {dirOutput.name};

    %% Print data info...
    fprintf('-----------------Tab. of Datasets----------------\n');
    fprintf([' # ', interval]);
    fprintf([' Name ', interval]);
    fprintf([' Total ', interval]);
    fprintf([' Dimension ', interval]);
    fprintf([' # Classes ', interval]);
    fprintf([' # Each Class\n']);
    for i = 1 : size(fileNames, 2)
        fullFilename = char(fileNames(i));
        filename = fullFilename(1 : size(fullFilename, 2) - 4);
        load([dataPath, '\', filename]);
        Data = eval(filename);
        [n, m] = size(Data);
        m = m - 1;
        num_class = unique(Data(:, 1));
        fprintf([' %d ', interval], i);
        fprintf([' %s ', interval], filename);
        fprintf([' %d ', interval], n);
        fprintf([' %d ', interval], m);
        fprintf([' %d ', interval], length(num_class));
        for j = 1 : length(num_class)
            num_class_j = length(find(Data(:, 1) == num_class(j)));
            fprintf([' %d'], num_class_j);
            if j ~= length(num_class)
                fprintf(',');
            end
        end
        fprintf('\n');
    end
    fprintf('--------------------------------------------------\n');
    
    %% Error.
    if dataSetNum < 1 | dataSetNum > size(fileNames, 2)
        fprintf('Error------dataSetNum must in (1, %d).\n', size(fileNames, 2));
        Data = [];
        filename = '';
        return;
    end
    
    %% Load dataSetNum...
    fprintf('-----------------Tab. of Dataset %d---------------\n', dataSetNum);
    fprintf([' # ', interval]);
    fprintf([' Name ', interval]);
    fprintf([' Total ', interval]);
    fprintf([' Dimension ', interval]);
    fprintf([' # Classes ', interval]);
    fprintf([' # Each Class\n']);
    for i = dataSetNum : dataSetNum
        fullFilename = char(fileNames(i));
        filename = fullFilename(1 : size(fullFilename, 2) - 4);
        load([dataPath, '\', filename]);
        Data = eval(filename);
        [n, m] = size(Data);
        m = m - 1;
        num_class = unique(Data(:, 1));
        fprintf([' %d ', interval], i);
        fprintf([' %s ', interval], filename);
        fprintf([' %d ', interval], n);
        fprintf([' %d ', interval], m);
        fprintf([' %d ', interval], length(num_class));
        for j = 1 : length(num_class)
            num_class_j = length(find(Data(:, 1) == num_class(j)));
            fprintf([' %d'], num_class_j);
            if j ~= length(num_class)
                fprintf(',');
            end
        end
        fprintf('\n');
    end
    fprintf('--------------------------------------------------\n');
    
    % Normalization.
    if norm == 1
        dataNorm = mapminmax(Data(:, 2 : end)', 0, 1);
        data = dataNorm';
        data = round(data * 10000) / 10000;
        Data(:, 2 : end) = data;
    end
    
    %% Update dataSetName.
    dataSetName = filename;
    
    classNum = length(num_class);
   
    trainData = [];
    testData = [];
    %% training set & test set.
    for i = 1 : classNum
        class_idx = find(Data(:, 1) == num_class(i));
        trainIndices = crossvalind('HoldOut', length(class_idx), testRatio);
        testIndices = ~trainIndices;

        trainData = [trainData; Data(class_idx(trainIndices), :)];
        testData = [testData; Data(class_idx(testIndices), :)];
    end
    
    %% Print info.
    fprintf('-------------------Traing & Test----------------\n');
    fprintf(['Traing Set: ']);
    for i = 1 : length(num_class)
        class_idx = find(trainData(:, 1) == num_class(i));
        if i == classNum
            fprintf(' %d = ', length(class_idx));
        else
            fprintf(' %d + ', length(class_idx));
        end
    end
    fprintf([' %d \n'], size(trainData, 1));
    
    fprintf(['Test Set: ']);
    for i = 1 : length(num_class)
        class_idx = find(testData(:, 1) == num_class(i));
        if i == classNum
            fprintf(' %d = ', length(class_idx));
        else
            fprintf(' %d + ', length(class_idx));
        end
    end
    fprintf([' %d \n'], size(testData, 1));
    
    fprintf(['Test ratio: %.4f \n'], testRatio);
    fprintf('--------------------------------------------------\n');
end