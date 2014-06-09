function [ error_his ] = lambdasearch(featurevector,quadraticflag)
%GRIDSEARCH Summary of this function goes here
%   Detailed explanation goes here
    badpoints = importdata('bad.txt');
    
    bestcv = Inf;
    
    lambda_range =[ -8:8];
    error_his = zeros(length(lambda_range),1);    
    
    for log2lambda = lambda_range,
        fprintf('log2lambda=%g\n',log2lambda);
        [train_error_rate, test_error_rate, cv_error_rate,train_mse,test_mse,cv_mse]=Run(featurevector,2,quadraticflag,'bad.txt',log2lambda);
        
%         if (cv_error_rate < bestcv),
%             bestcv = cv_error_rate;
%             bestlog2lambda = log2lambda;
%         end
%         error_his(log2lambda-lambda_range(1)+1) = cv_mse;
        
        if (cv_mse < bestcv),
            bestcv = cv_mse;
            bestlog2lambda = log2lambda;
        end   
        error_his(log2lambda-lambda_range(1)+1) = cv_mse;
    end
    fprintf('best log2lambda=%g, err_rate=%g\n', bestlog2lambda, bestcv);
end

