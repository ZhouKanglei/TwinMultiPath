%% Clear Window...
clc;
clear all;
close all;

%% Global variables...
globalVars();
methods = {};
methods{1} = 'Ours';
methods{2} = 'OVOVR_TSVM';

dataRange = [1:13];
times = 10;

%% Plot figs
if ~exist([resFolder, '/plots/Ours_vs_OVOVR-TSVM'], 'dir')
    mkdir([resFolder, '/plots/Ours_vs_OVOVR-TSVM']);
end
for dataSetNum = dataRange
    [trainData, testData, classNum, dataSetName] = loadData(dataSetNum);
    
    for methods_i = 1 : length(methods)
        filePath = [resFolder, '/mainExp/', methods{methods_i}, '/',...
            num2str(testRatio), '_',  num2str(dataSetNum), '.mat'];
        
        if exist(filePath, 'file')
            dataLog = load(filePath);
            corrPred = dataLog.corrPred;
            dataSetName = dataLog.dataSetName;

            plot(corrPred, markers{methods_i},...
             'MarkerSize',  10, 'MarkerFacecolor', 'w',...
             'LineWidth', 1.5);
            hold on;
        end
    end
    
    xlim([1 10]);
    title(['', dataSetName, '']);
    legend(['Ours (OVOVR)'], ['TSVM (OVOVR)'], ['TSVM (OVR)'], ['TSVM (OVO)'], ['SVM (OVR)'], ['SVM (OVO)'],...
     'Location', 'best');
    xlabel(['Times']);
    ylabel(['Accuracy (\%)']);
    set(gca, 'FontSize', 22, 'FontName', 'Times New Roman', 'LineWidth', 1.5);
    set(gcf, 'unit', 'centimeters', 'position', [dataSetNum 2 20 15]); 

    set(gcf, 'PaperPosition', [0 0 20 15]);
    set(gcf, 'PaperSize', [20 15]);
    %saveas(gcf, [resFolder, '/plots/Ours_vs_OVOVR-TSVM/acc_', num2str(testRatio * 100), '_',  num2str(dataSetNum), '.pdf']); 
    
    hold off;
    
    grid on;
    setFigPaper('Interpreter', 'latex', 'FontSize', 12, 'LineWidth', 1, 'Width', 12);
    filename = [resFolder, '/plots/Ours_vs_OVOVR-TSVM/acc_', num2str(testRatio * 100), '_',  num2str(dataSetNum), '.pdf'];
    folder = fileparts(filename);
    
    if ~exist(folder, 'dir')
        mkdir(folder);
    end
    
    exportgraphics(gcf, filename);
    fprintf('Save [%s]\n', filename);
end