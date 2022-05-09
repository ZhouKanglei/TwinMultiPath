%% Clear Window...
clc;
clear all;
close all;

dataRange_tab = [2 3 6 7 8 9 10 12 13];
% dataRange_tab = [1 2 3 4 5 6 7 8 9 10 11 12 13 14];
times = 10;

%% Global variables...
globalVars();

%% Print Info.
fprintf('------------------Average Events----------------\n');
for dataSetNum = dataRange_tab
	filePath = [resFolder, '/mainExp/', methods{1}, '/',...
        num2str(testRatio), '_',  num2str(dataSetNum), '.mat'];
    if exist(filePath, 'file')
        dataLog = load(filePath);
        event_1_all = dataLog.event_1_all;
        event_2_all = dataLog.event_2_all;
        dataSetName = dataLog.dataSetName;
        
        fprintf([' %s ', interval], dataSetName);
        
        fprintf([' %d ', interval]);
        for i = 1 : 9
            if i ~= 9
                fprintf([' %.0f ', interval],...
                    event_1_all(i) / times ...
                    + event_2_all(i) / times);
            else
                fprintf([' %.0f ', '\\\\\n'],...
                    event_1_all(i) / times ...
                    + event_2_all(i) / times);
            end
        end
        
    end
end
fprintf('--------------------------------------------------\n');

fprintf('------------------Average Time-----------------\n');
for dataSetNum = dataRange_tab
    filePath = [resFolder, '/mainExp/', methods{1}, '/',...
        num2str(testRatio), '_',  num2str(dataSetNum), '.mat'];
    
    if exist(filePath, 'file')
        dataLog = load(filePath);
        event_1_all = dataLog.event_1_all;
        event_2_all = dataLog.event_2_all;
        time = dataLog.time;
        dataSetName = dataLog.dataSetName;
        
        fprintf([' %s ', interval], dataSetName);
        fprintf([' %.0f ', interval], event_1_all(9) / times);
        fprintf([' %.0f ', interval], event_2_all(9) / times);
        fprintf([' %.0f ', interval],...
            event_1_all(9) / times + event_2_all(9) / times);
        fprintf([' %.4f ', interval], mean(time));
        fprintf([' %.4f ', interval], mean(time) ...
            / (event_1_all(9) / times + event_2_all(9) / times));
    end
    
    for methods_idx = 2 : length(methods)
        filePath = [resFolder, '/mainExp/', methods{methods_idx}, '/',...
            num2str(testRatio), '_',  num2str(dataSetNum), '.mat'];
        if exist(filePath, 'file')
            dataLog = load(filePath);
            time = dataLog.time;
            if methods_idx ~= length(methods)
                fprintf([' %.4f ', interval], mean(time));
            else
                fprintf([' %.4f \\\\\n'], mean(time));
            end
        end
    end
end
fprintf('\n--------------------------------------------------\n');

%% Print Info.
fprintf('----------------Average Accuray----------------\n');
for dataSetNum = dataRange_tab
    for methods_idx = 1 : length(methods)
        filePath = [resFolder, '/mainExp/', methods{methods_idx}, '/',...
            num2str(testRatio), '_',  num2str(dataSetNum), '.mat'];
        if exist(filePath, 'file')
            dataLog = load(filePath);
            corrPred = dataLog.corrPred;
            dataSetName = dataLog.dataSetName;
            if methods_idx == 1
                fprintf([' %s ', interval], dataSetName);
            end
            fprintf([' %.2f ', '$\\pm$'], mean(corrPred));
            if methods_idx ~= length(methods)
                fprintf([' %.2f ', interval], std(corrPred));
            else
                fprintf([' %.2f ', '\\\\\n'], std(corrPred));
            end
            
        end
    end
end
fprintf('--------------------------------------------------\n');

