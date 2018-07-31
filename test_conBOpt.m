clear;
myDefs;
addpath('../gpml/');
addpath('problems/');
startup;

%% options
problem = 'prob2d'; % 'prob1d', 'prob3d'
seed = 1;
e = 0;
bOffset = 0.1;
bThreshold = 0.55;
verbose = 1;
optM = 2;

%% init algorithm
randn('seed',seed)
eval(problem);
n = length(x0);
cbo = conBOpt(n,t,e,bOffset,bThreshold,verbose,optM,ellC,sf2C,ellR,sf2R,snR);
cbo.y_gt = fun(t);
y = fun(x0);
ys = safety(x0);

cbo.addDataPoint(x0,y,ys);

%% run algorithm
while (true)
    [x, isConv] = cbo.selectNextPoint();
    if isConv
        break;
    end
    y = funNoise(x);
    ys = safety(x);
    cbo.addDataPoint(x,y,ys);
    cbo.stats();
    cbo.plot();
end