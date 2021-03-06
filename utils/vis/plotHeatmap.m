function plotHeatmap(ratio_z, lambda_1, lambda_2, fig_title)
%% Global variables.
if ~exist('show_max_num', 'var')
    show_max_num = 8;
end

if ~exist('fig_title', 'var')
    fig_title = '';
end

%% Large cross-validation matrix to small.
max_acc = max(max(ratio_z));

[lambda_1_opts, lambda_2_opts] = find(ratio_z == max_acc);

lambda_1_opt = lambda_1_opts(1);
lambda_2_opt = lambda_2_opts(1);

ratio_map = ratio_z;
if size(ratio_z, 1) >= show_max_num
    if lambda_1_opt < show_max_num / 2
        ratio_map = ratio_map(1:show_max_num, :);
        low = 1; high = size(ratio_map, 1);
    end
    
    if lambda_1_opt + show_max_num / 2 > size(ratio_z, 1)
        ratio_map = ratio_map(size(ratio_z, 1) - show_max_num + 1:end, :);
        low = 1; high = size(ratio_map, 1);
    end
    
    if lambda_1_opt > show_max_num / 2 && lambda_1_opt + show_max_num / 2 < size(ratio_z, 1)
        low = lambda_1_opt - show_max_num / 2;
        high = low + show_max_num - 1;
        ratio_map = ratio_map(low:high, :);
    end
end

if size(ratio_z, 2) >= show_max_num
    if lambda_2_opt > show_max_num / 2 && lambda_2_opt + show_max_num / 2 < size(ratio_z, 2)
        left = lambda_2_opt - show_max_num / 2;
        right = left + show_max_num - 1;
        ratio_map = ratio_map(:, left:right);
    else
        ratio_map = ratio_map(:, 1:show_max_num);
        left = 1; right = size(ratio_map, 2);
    end
end


%% Plot validation curve.
figure();
ratio_c = reshape(ratio_map, [], 1);

plot(ratio_c, 'r+-', 'MarkerSize',  8, 'LineWidth', 1.5);
hold on;
[c_max, c_idx] = max(ratio_c);
plot(c_idx, c_max, 'bs', 'MarkerSize',  8, 'MarkerFaceColor', 'b');

xlim([1 length(ratio_c)]);
min_r = min(ratio_c);
max_r = max(ratio_c);
%ylim([min_r(1) max_r(1)]);

title('Validation Accuracy Curve');

xlabel(['Regularization Parameter Combination Pairs ($\lambda_1$, $\lambda_2$)']);
ylabel(['Accuracy (\%)']);

grid on;

setFigPaper('FontName','Times New Roman', 'FontSize', 16, 'LineWidth', 1, 'Interpreter', 'latex');


filename = ['res/plots/valid/valid', fig_title, '.pdf'];
[path, ~] = fileparts(filename);
if ~exist(path, 'dir')
    mkdir(path);
end
exportgraphics(gcf, filename);

hold off;

%% Plot color map.
figure();


xvalues = {};
for i = left : right
    xvalues{length(xvalues) + 1} = num2str(lambda_2(i),'%.3f');
end

yvalues = {};
for i = low : high
    yvalues{length(yvalues) + 1} = num2str(lambda_1(i),'%.3f');
end

h = heatmap(xvalues, yvalues, ratio_map);

colorbar;

title('Validation Accuracy Heatmap');
xlabel(['$\lambda_2$']);
ylabel(['$\lambda_1$']);
setFigPaper('FontName','Times New Roman', 'FontSize', 16, 'LineWidth', 1, 'Interpreter', 'latex');

filename = ['res/valid/valid_map', fig_title, '.pdf'];
[path, ~] = fileparts(filename);
if ~exist(path, 'dir')
    mkdir(path);
end
exportgraphics(gcf, filename);
fprintf('save %s\n', filename);

end