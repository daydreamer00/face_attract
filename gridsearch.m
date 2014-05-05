function [  ] = gridsearch(featurevector,quadraticflag)
%GRIDSEARCH Summary of this function goes here
%   Detailed explanation goes here
    badpoints = importdata('bad.txt');
	[train_x, train_y,test_x,test_y,valid_x,valid_y]=buildFeature(featurevector,3,quadraticflag,badpoints,0);
    bestcv = Inf;
    for log2c = -4:4,
        for log2g = -15:1
            cmd = ['-q -s 3 -t 2 -v 5 -c ', num2str(2^log2c), ' -g ', num2str(2^log2g)];
            cv = svmtrain(train_y, train_x, cmd);
            if (cv < bestcv),
                bestcv = cv; bestlog2c = log2c; bestlog2g = log2g;
            end
        end
    end
    fprintf('(best log2c=%g, log2g=%g, err_rate=%g)\n', bestlog2c, bestlog2g, bestcv);
end

