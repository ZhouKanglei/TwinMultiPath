%% Clear Window...
clc;
clear all;
close all;

%% Global variables...
globalVars();

dataSetNum = 13;

if ~exist([resFolder, '/Piecewise'], 'dir')
    mkdir([resFolder, '/Piecewise']);
end


%% Iteration.
filePath = [resFolder, '/mainExp/', methods{1}, '/',...
    num2str(testRatio), '_',  num2str(dataSetNum), '.mat'];
if exist(filePath, 'file')
    load(filePath);
    
    figure();
    lambda_min = 10000;
    lambda_max = 0;
    %% alpha
    numCnt = 0;
    for class_i = 1 : classNum
        for class_j = class_i + 1 : classNum
            numCnt = numCnt + 1;
            
            lambda_1 = Lambda_1{numCnt};
            alpha = Alpha{numCnt};
            beta = Beta{numCnt};
            lambda_2 = Lambda_2{numCnt};
            mu = Mu{numCnt};
            rho = Rho{numCnt};
            
            plot(log(lambda_1), alpha', 'LineWidth', 1);
%             plot(log(lambda_1), beta');
            hold on;
            
            if max(log(lambda_1)) > lambda_max
                lambda_max = max(log(lambda_1));
            end
            
            if min(log(lambda_1)) < lambda_min
                lambda_min = min(log(lambda_1));
            end
        end
    end
    
    xlim([lambda_min lambda_max]); 
    ylim([0 1]);
    title(['Piecewise Linear Solution Path']);
    xlabel(['{\rm ln} \lambda_1']);
    ylabel(['\alpha_i']);
    
    set(gca, 'FontSize', 14, 'FontName', 'Times New Roman', 'LineWidth', 1.5);
    set(gcf, 'unit', 'centimeters', 'position', [1 1 24 8]); 
    
    set(gcf, 'PaperPosition', [0 0 24 8]);
    set(gcf, 'PaperSize', [24 8]);
    fileFullPath = [resFolder, '/Piecewise/Piecewise_',...
        num2str(testRatio * 100), '_', num2str(dataSetNum), '_alpha_.pdf'];
    saveas(gcf, fileFullPath); 
    
    lambda_min = 10000;
    lambda_max = 0;
    %% beta
    hold off;
    figure();
    numCnt = 0;
    for class_i = 1 : classNum
        for class_j = class_i + 1 : classNum
            numCnt = numCnt + 1;
            
            lambda_1 = Lambda_1{numCnt};
            alpha = Alpha{numCnt};
            beta = Beta{numCnt};
            lambda_2 = Lambda_2{numCnt};
            mu = Mu{numCnt};
            rho = Rho{numCnt};
            
%             plot(log(lambda_1), alpha');
            plot(log(lambda_1), beta', 'LineWidth', 1);
            hold on;
            
            if max(log(lambda_1)) > lambda_max
                lambda_max = max(log(lambda_1));
            end
            
            if min(log(lambda_1)) < lambda_min
                lambda_min = min(log(lambda_1));
            end
        end
    end
    
    xlim([lambda_min lambda_max]); 
    ylim([0 1]);
    title(['Piecewise Linear Solution Path']);
    xlabel(['{\rm ln} \lambda_1']);
    ylabel(['\beta_k']);
    
    set(gca, 'FontSize', 14, 'FontName', 'Times New Roman', 'LineWidth', 1.5);
    set(gcf, 'unit', 'centimeters', 'position', [1 1 24 8]); 
    
    set(gcf, 'PaperPosition', [0 0 24 8]);
    set(gcf, 'PaperSize', [24 8]);
    fileFullPath = [resFolder, '/Piecewise/Piecewise_',...
        num2str(testRatio * 100), '_', num2str(dataSetNum), '_beta_.pdf'];
    saveas(gcf, fileFullPath); 

    figure();
    lambda_min = 10000;
    lambda_max = 0;
    %% mu
    numCnt = 0;
    for class_i = 1 : classNum
        for class_j = class_i + 1 : classNum
            numCnt = numCnt + 1;
            
            lambda_1 = Lambda_1{numCnt};
            alpha = Alpha{numCnt};
            beta = Beta{numCnt};
            lambda_2 = Lambda_2{numCnt};
            mu = Mu{numCnt};
            rho = Rho{numCnt};
            
            plot(log(lambda_2), mu', 'LineWidth', 1);
%             plot(log(lambda_1), beta');
            hold on;
            
            if max(log(lambda_2)) > lambda_max
                lambda_max = max(log(lambda_2));
            end
            
            if min(log(lambda_2)) < lambda_min
                lambda_min = min(log(lambda_2));
            end
        end
    end
    
    xlim([lambda_min lambda_max]); 
    ylim([0 1]);
    title(['Piecewise Linear Solution Path']);
    xlabel(['{\rm ln} \lambda_2']);
    ylabel(['\mu_i']);
    
    set(gca, 'FontSize', 14, 'FontName', 'Times New Roman', 'LineWidth', 1.5);
    set(gcf, 'unit', 'centimeters', 'position', [1 1 24 8]); 
    
    set(gcf, 'PaperPosition', [0 0 24 8]);
    set(gcf, 'PaperSize', [24 8]);
    fileFullPath = [resFolder, '/Piecewise/Piecewise_',...
        num2str(testRatio * 100), '_', num2str(dataSetNum), '_mu_.pdf'];
    saveas(gcf, fileFullPath); 
    
    lambda_min = 10000;
    lambda_max = 0;
    %% beta
    hold off;
    figure();
    numCnt = 0;
    for class_i = 1 : classNum
        for class_j = class_i + 1 : classNum
            numCnt = numCnt + 1;
            
            lambda_1 = Lambda_1{numCnt};
            alpha = Alpha{numCnt};
            beta = Beta{numCnt};
            lambda_2 = Lambda_2{numCnt};
            mu = Mu{numCnt};
            rho = Rho{numCnt};
            
            plot(log(lambda_2), rho', 'LineWidth', 1);
            hold on;
            
            if max(log(lambda_2)) > lambda_max
                lambda_max = max(log(lambda_2));
            end
            
            if min(log(lambda_2)) < lambda_min
                lambda_min = min(log(lambda_2));
            end
        end
    end
    
    xlim([lambda_min lambda_max]); 
    ylim([0 1]);
    title(['Piecewise Linear Solution Path']);
    xlabel(['{\rm ln} \lambda_2']);
    ylabel(['\rho_k']);
    
    set(gca, 'FontSize', 14, 'FontName', 'Times New Roman', 'LineWidth', 1.5);
    set(gcf, 'unit', 'centimeters', 'position', [1 1 24 8]); 
    
    set(gcf, 'PaperPosition', [0 0 24 8]);
    set(gcf, 'PaperSize', [24 8]);
    fileFullPath = [resFolder, '/Piecewise/Piecewise_',...
        num2str(testRatio * 100), '_', num2str(dataSetNum), '_rho_.pdf'];
    saveas(gcf, fileFullPath); 
end