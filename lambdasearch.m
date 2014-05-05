function [  ] = lambdasearch(featurevector,quadraticflag)
%GRIDSEARCH Summary of this function goes here
%   Detailed explanation goes here
    badpoints = importdata('bad.txt');
    
    bestcv = Inf;
    
    for log2lambda = 1:10,
        [train_error_rate, test_error_rate, cv_error_rate]=Run(featurevector,2,quadraticflag,'bad.txt',2^log2lambda);
        if (cv_error_rate < bestcv),
                bestcv = cv_error_rate;
                bestlog2lambda = log2lambda;
        end
    end
    fprintf('best log2lambda=%g, err_rate=%g)\n', bestlog2lambda, bestcv);
end

