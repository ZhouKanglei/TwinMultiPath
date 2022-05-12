close all; clear all; clc;
addpath(genpath('src/'));
addpath(genpath('utils'));
addpath(genpath('utils/vis'));

methods = {};
methods{1} = 'Ours';
methods{2} = 'OVOVR_TSVM';
plotAccFigs();