function plotDist(filename, class_i, class_j)


load(filename);
class_k = num2str(6 - class_i - class_j);

X = X(:, 1 : 2);
x_true = X(:, 1);
y_true = X(:, 2);
y1 = 2 + y_pred(:, 1) - y_pred(:, 2);

figure();

%% fill
% y3
h = fill([min(x_true), min(x_true), max(x_true), max(x_true)],...
    [min(y_true), max(y_true), max(y_true), min(y_true)], ...
    [0.85 0.9 0.85]);
set(h, 'edgealpha', 0, 'facealpha', 1);
hold on;

% y1
y_pred_1 = (- b_1 - x_true * w_1(1)) / w_1(2);
delta = -0.5 / w_1(2);

h = fill([min(x_true), min(x_true), max(x_true), max(x_true)],...
    [y_pred_1(x_true == min(x_true)) - delta, y_pred_1(x_true == min(x_true)) + delta, ...
    y_pred_1(x_true == max(x_true)) + delta, y_pred_1(x_true == min(x_true)) - delta], ...
    [0.8 0.95 0.95]);
set(h, 'edgealpha', 0, 'facealpha', 1);
hold on;

% y2
y_pred_2 = (- b_2 - x_true * w_2(1)) / w_2(2);
delta = 0.5 / w_2(2);

h = fill([min(x_true), min(x_true), max(x_true), max(x_true)],...
    [y_pred_2(x_true == min(x_true)) - delta, y_pred_2(x_true == min(x_true)) + delta, ...
    y_pred_2(x_true == max(x_true)) + delta, y_pred_2(x_true == min(x_true)) - delta], ...
    [0.95 0.95 0.8]);
set(h, 'edgealpha', 0, 'facealpha', 1);
hold on;

%% lines
plot(x_true, y_pred_1, 'b-', 'LineWidth', 2);
plot(x_true, y_pred_2, 'r-', 'LineWidth', 2);

%% points
styles = ['+', 'p', 'x'];
colors = ['r', 'm', 'b'];

for i = 1 : length(styles)
    style = styles(i);
    color = colors(i);
    plot(X(y1 == i, 1), X(y1 == i, 2), style,...
        'MarkerFaceColor', color,'MarkerEdgeColor', color,...
        'MarkerSize', 9, 'LineWidth', 2);
    hold on;
end


plot(X(y1 ~= y + 2, 1), X(y1 ~= y + 2, 2), 'o',...
    'MarkerEdgeColor', 'g',...
    'MarkerSize', 9, 'LineWidth', 2);
hold on;


xlim([min(x_true), max(x_true)]);
ylim([min(y_true), max(y_true)]);

% title(['Class $(K_', class_i, ', K_', class_j, '$)']);
title(['Accuracy = ', num2str(corrRatio), '\%']);

if class_i == 1 & class_j == 2
    class = {'~~0 area', '$+1$ area', '$-1$ area', '$x_1 w_1 + b_1 = 0$', '$x_2 w_2 + b_2 = 0$', ...
    '$-1$ samples', '$+1$ samples', 'Error samples'};
else
    class = {'~~0 area', '$+1$ area', '$-1$ area', '$x_1 w_1 + b_1 = 0$', '$x_2 w_2 + b_2 = 0$', ...
    '$-1$ samples', '~~$0$ samples', '$+1$ samples', 'Error samples'};
end
lgd = legend(class, 'Location', 'best', 'NumColumns', 2);
lgd.BoxFace.ColorType = 'truecoloralpha';
lgd.BoxFace.ColorData = uint8(255 * [1 1 1 0.6]');

setFigPaper('Interpreter', 'latex', 'FontSize', 18, 'LineWidth', 1);

%% save fig.
filename = ['./res/example/', num2str(class_i), '_', num2str(class_j), '.pdf'];
folder = fileparts(filename);

if ~exist(folder, 'dir')
    mkdir(folder);
end


exportgraphics(gcf, filename);
fprintf('Save [%s]\n', filename);
end