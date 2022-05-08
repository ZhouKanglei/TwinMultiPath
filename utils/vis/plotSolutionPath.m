function plot_solution_path(lambda_1, alpha_1, beta_1, num)
	colors = {'#0072BD', '#D95319', '#EDB120', '#7E2F8E', '#77AC30', '#4DBEEE', '#A2142F'};
	styles = {'-', '--', ':', '-.'};
    %% Plot lambda_1
    fig = figure('Visible', 'off', 'Position', [10 10 600 250]);
    
    plot(log(lambda_1), '-', 'Color', char(colors{1}), 'LineWidth', 1.5);
    
    xlim([1 length(lambda_1)]); 
    ylim([min(log(lambda_1)) max(log(lambda_1))]);
    
    title(['\lambda_', num2str(num), ' Variation Diagram']);
    xlabel(['Step \itl']);
    ylabel(['log(\lambda_', num2str(num), ')']);
    
    set(gca, 'FontSize', 12, 'FontName', 'Times New Roman', 'LineWidth', 1.5);
    grid on;
    
    filename = ['res/piecewise/QPP_', num2str(num), '/', 'lambda_' , num2str(num), '.pdf'];
    folder = fileparts(filename);
    
    if ~exist(folder, 'dir')
        mkdir(folder);
    end
    
    exportgraphics(gcf, filename);
    fprintf('Save [%s]\n', filename);
    close(fig);
    
    %% Plot alpha_1
    fig = figure('Visible', 'off', 'Position', [10 10 600 250]);
    
    plot(alpha_1', 'LineWidth', 1.5);
    
    xlim([1 length(lambda_1)]); 
    ylim([0 1]);
    
    if num == 2
        title(['\mu', ' Variation Diagram']);
        ylabel(['\mu']);
    else
        title(['\alpha', '  Variation Diagram']);
        ylabel(['\alpha']);
    end
    
    xlabel(['Step \itl']);
    set(gca, 'FontSize', 12, 'FontName', 'Times New Roman', 'LineWidth', 1.5);
    grid on;
 
    filename = ['res/piecewise/QPP_', num2str(num), '/', 'alpha_' , num2str(num), '.pdf'];
    folder = fileparts(filename);
    
    if ~exist(folder, 'dir')
        mkdir(folder);
    end
    
    exportgraphics(gcf, filename);
    fprintf('Save [%s]\n', filename);
    close(fig);
    
    %% Plot several alpha_1s
    fig = figure('Visible', 'off', 'Position', [10 10 600 250]);
    idx = [5, 10, 15, 20, 25, 30, 35, 40, 45, 50];
    lgds = {};
    for i = idx
        if i < size(alpha_1, 1)
            col = mod(find(idx == i), length(colors)) + 1;
            color = char(colors{col});
            col = mod(find(idx == i), length(styles)) + 1;
            style = char(styles{col});
            plot(alpha_1(i, :)', style, 'LineWidth', 1.5, 'Color', color);
            lgds{length(lgds) + 1} = num2str(i);
            hold on;
        end
    end
    hold off;
    lgd = legend(lgds, 'NumColumns', 2);
    lgd.BoxFace.ColorType = 'truecoloralpha';
    lgd.BoxFace.ColorData = uint8(255 * [1 1 1 0.9]');
    
    xlim([1 length(lambda_1)]); 
    ylim([0 1]);
    
    if num == 2
        title(['\mu', ' Variation Diagram']);
        ylabel(['\mu']);
    else
        title(['\alpha', '  Variation Diagram']);
        ylabel(['\alpha']);
    end
    
    xlabel(['Step \itl']);
    set(gca, 'FontSize', 12, 'FontName', 'Times New Roman', 'LineWidth', 1.5);
    grid on;
 
    filename = ['res/piecewise/QPP_', num2str(num), '/', 'alpha_sub_' , num2str(num), '.pdf'];
    folder = fileparts(filename);
    
    if ~exist(folder, 'dir')
        mkdir(folder);
    end
    
    exportgraphics(gcf, filename);
    fprintf('Save [%s]\n', filename);
    close(fig);
    
    %% Plot beta_1
    fig = figure('Visible', 'off', 'Position', [10 10 600 250]);
    
    plot(beta_1', 'LineWidth', 1.5);
    
    xlim([1 length(lambda_1)]); 
    ylim([0 1]);
    
    if num == 2
        title(['\rho', ' Variation Diagram']);
        ylabel(['\rho']);
    else
        title(['\beta', '  Variation Diagram']);
        ylabel(['\beta']);
    end
    
    xlabel(['Step \itl']);
    set(gca, 'FontSize', 12, 'FontName', 'Times New Roman', 'LineWidth', 1.5);
    grid on;
 
    filename = ['res/piecewise/QPP_', num2str(num), '/', 'beta_' , num2str(num), '.pdf'];
    folder = fileparts(filename);
    
    if ~exist(folder, 'dir')
        mkdir(folder);
    end
    
    exportgraphics(gcf, filename);
    fprintf('Save [%s]\n', filename);
    close(fig);
    
    %% Plot several beta_1s
    fig = figure('Visible', 'off', 'Position', [10 10 600 250]);
    idx = [5, 10, 15, 20, 25, 30, 35, 40, 45, 50];
    lgds = {};
    for i = idx
        if i < size(beta_1, 1)
            col = mod(find(idx == i), length(colors)) + 1;
            color = char(colors{col});
            col = mod(find(idx == i), length(styles)) + 1;
            style = char(styles{col});
            plot(beta_1(i, :)', style, 'LineWidth', 1.5, 'Color', color);
            lgds{length(lgds) + 1} = num2str(i);
            hold on;
        end
    end
    hold off;
    lgd = legend(lgds, 'NumColumns', 2);
    lgd.BoxFace.ColorType = 'truecoloralpha';
    lgd.BoxFace.ColorData = uint8(255 * [1 1 1 0.9]');
    
    xlim([1 length(lambda_1)]); 
    ylim([0 1]);
    
    if num == 2
        title(['\rho', ' Variation Diagram']);
        ylabel(['\rho']);
    else
        title(['\beta', '  Variation Diagram']);
        ylabel(['\beta']);
    end
    
    xlabel(['Step \itl']);
    set(gca, 'FontSize', 12, 'FontName', 'Times New Roman', 'LineWidth', 1.5);
    grid on;
 
    filename = ['res/piecewise/QPP_', num2str(num), '/', 'beta_sub_' , num2str(num), '.pdf'];
    folder = fileparts(filename);
    
    if ~exist(folder, 'dir')
        mkdir(folder);
    end
    
    exportgraphics(gcf, filename);
    fprintf('Save [%s]\n', filename);
    close(fig);
    
end