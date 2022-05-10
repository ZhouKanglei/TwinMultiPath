function plotPred(X, y, y1, acc, fig_title)
if ~exist('fig_title', 'var')
    fig_title = '';
end

if ~exist('acc', 'var')
    acc = '';
end

X = X(:, 2 : 3);
x_true = X(:, 1);
y_true = X(:, 2);

%% points
styles = ['o', '^', 'p'];
colors = {'#0072BD', '#D95319', '#EDB120', '#7E2F8E', '#77AC30', '#4DBEEE', '#A2142F'};


for i = 1 : length(styles)
    style = styles(i);
    color = char(colors(i));
    plot(X(y1 == i, 1), X(y1 == i, 2), style,...
        'MarkerFaceColor', color,'MarkerEdgeColor', color,...
        'MarkerSize', 12, 'LineWidth', 2);
    hold on;
end


plot(X(y1 ~= y, 1), X(y1 ~= y, 2), 'o',...
    'MarkerEdgeColor', char(colors(5)),...
    'MarkerSize', 12, 'LineWidth', 2);
hold on;


xlim([min(x_true), max(x_true)]);
ylim([min(y_true), max(y_true)]);


if contains(fig_title, "orig")
    title(['Original Data']);
else
    title(['Accuracy = ', acc, '\%']);
end
grid();

if contains(fig_title, "orig")
    class = {'Class 1', 'Class 2', 'Class 3'};
else
    class = {'Class 1', 'Class 2', 'Class 3', 'Error samples'};
end


lgd = legend(class, 'Location', 'best', 'NumColumns', 2);
lgd.BoxFace.ColorType = 'truecoloralpha';
lgd.BoxFace.ColorData = uint8(255 * [1 1 1 0.6]');

setFigPaper('Interpreter', 'latex', 'FontSize', 18, 'LineWidth', 1);

%% save fig.
filename = ['./res/example/', fig_title, '.pdf'];
folder = fileparts(filename);

if ~exist(folder, 'dir')
    mkdir(folder);
end


exportgraphics(gcf, filename);
fprintf('Save [%s]\n', filename);