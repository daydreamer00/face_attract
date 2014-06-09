function [ error_his ] = gridsearch(featurevector,quadraticflag)
%GRIDSEARCH Summary of this function goes here
%   Detailed explanation goes here
    badpoints = importdata('bad.txt');
	[train_x, train_y,test_x,test_y,valid_x,valid_y]=buildFeature(featurevector,3,quadraticflag,badpoints,0);
    bestcv = Inf;
    
    c_range = -4:4;
    g_range = -15:1;
    error_his = zeros(length(c_range),length(g_range));
    for log2c = c_range,
        for log2g = g_range
            cmd = ['-q -s 3 -t 2 -v 5 -c ', num2str(2^log2c), ' -g ', num2str(2^log2g)];
            cv = svmtrain(train_y, train_x, cmd);
            if (cv < bestcv),
                bestcv = cv; bestlog2c = log2c; bestlog2g = log2g;
            end
            i = log2c-c_range(1)+1;
            j = log2g-g_range(1)+1;
            error_his(i,j) = cv;
        end
    end
    fprintf('(best log2c=%g, log2g=%g, err_rate=%g)\n', bestlog2c, bestlog2g, bestcv);
end

