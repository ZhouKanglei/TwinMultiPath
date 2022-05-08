%% Global data path...
global dataPath dataSetNum dataSetName interval norm;
dataPath = 'E:\Code_Files\Matlab\SVM\TwinMultiPath\data';
interval = '&';
dataSetNum = 6;
dataSetName = '';
norm = false;

global resFolder;
resFolder = 'res';

global testRatio kFold;
kFold = 1;
testRatio = 0.25;

global epsilon delta l_max lambda_min;
epsilon = 0.05;
delta = 0.0001;
l_max = 1000;
lambda_min = 0.05;

global F G H F_test G_test H_test;
F = [];
G = [];
H = [];
F_test = [];
G_test = [];
H_test = [];

global trainData testData trainDataSplit;
trainData = [];
testData = [];
trainDataSplit = [];

global F_inv G_inv;
F_inv = [];
G_inv = [];

global L_B_1 E_B_1 R_B_1 L_C_1 E_C_1 R_C_1;
L_B_1 = [];
E_B_1 = [];
R_B_1 = [];
L_C_1 = [];
E_C_1 = [];
R_C_1 = [];

global L_A_2 E_A_2 R_A_2 L_C_2 E_C_2 R_C_2;
L_A_2 = [];
E_A_2 = [];
R_A_2 = [];
L_C_2 = [];
E_C_2 = [];
R_C_2 = [];

global lambda_one lambda_two;
lambda_one = 2;
lambda_two = 2;

global markers methods;

methods{1} = 'Ours';
methods{2} = 'OVOVR_TSVM';
methods{3} = 'OVR_TSVM';
methods{4} = 'OVO_TSVM';
methods{5} = 'OVR_SVM';
methods{6} = 'OVO_SVM';

markers{1} = 'or-';
markers{2} = 'sb:';
markers{3} = '^m--';
markers{4} = 'pg-.';
markers{5} = 'dc--';
markers{6} = '*y-.';

global distOpt;
distOpt = 1;