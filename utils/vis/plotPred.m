function plotPred(X, y, y1, fig_title)
if ~exist('fig_title', 'var')
    fig_title = '';
end

X = X(:, 2 : 3);
x_true = X(:, 1);
y_true = X(:, 2);

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


plot(X(y1 ~= y, 1), X(y1 ~= y, 2), 'o',...
    'MarkerEdgeColor', 'g',...
    'MarkerSize', 9, 'LineWidth', 2);
hold on;


xlim([min(x_true), max(x_true)]);
ylim([min(y_true), max(y_true)]);

title(['Accuracy = ', fig_title, '\%']);
title(['Original Data']);
grid();

class = {'Class 1', 'Class 2', 'Class 3', 'Error samples'};
class = {'Class 1', 'Class 2', 'Class 3'};

lgd = legend(class, 'Location', 'best', 'NumColumns', 2);
lgd.BoxFace.ColorType = 'truecoloralpha';
lgd.BoxFace.ColorData = uint8(255 * [1 1 1 0.6]');

setFigPaper('Interpreter', 'latex', 'FontSize', 18, 'LineWidth', 1);

%% save fig.
filename = ['./res/example/orig', '.pdf'];
folder = fileparts(filename);

if ~exist(folder, 'dir')
    mkdir(folder);
end


exportgraphics(gcf, filename);
fprintf('Save [%s]\n', filename);