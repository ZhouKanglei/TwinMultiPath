clear all;
clc;

data = load('Iris.mat');
data = data.Iris;
y = data(:, 1);
x = data(:, 2:end);

i = 2;
j = 3;


y(x(:, j) >= 5.3) = 3;
y(x(:, j) < 5.3) = 2;
y(x(:, j) <= 2) = 1;
x(y == 3, j) = x(y == 3, j) + 0.5;
x(y == 3, i) = x(y == 3, i) + 0.5;

scatter(x(:, i)', x(:, j)', [], y')


my = [y, x(:, i), x(:, j)];
save(['my.mat'], 'my');