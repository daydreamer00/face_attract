function [ plotData  ] = plotLearningCurve(featurevector,modeltype,quadraticflag,badpoints_filename,log2lambda )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
    badpoints = importdata(badpoints_filename);
    [train_x, train_y,test_x,test_y,valid_x,valid_y]=buildFeature(featurevector,modeltype,quadraticflag,badpoints,0);
    trainsize = length(train_y);
    i_begin = 50;
    plotData = zeros(trainsize-i_begin+1,3);
    
    for i = i_begin:trainsize
        [predict]=trainAndPredict(train_x,train_y,i,test_x,test_y,length(test_y),modeltype,log2lambda);
        [error_rate,error_count,count,wrongpair,test_mse]=evaluation(test_y,predict);
        test_error_rate=error_rate
        test_error_count=error_count;
        test_count=count;
        
        [predict]=trainAndPredict(train_x,train_y,i,train_x,train_y,i,modeltype,log2lambda);
        [error_rate,error_count,count,wrongpair,train_mse]=evaluation(train_y(1:i),predict);
        train_error_rate=error_rate
        train_error_count=error_count;
        train_count=count;
        
        plotData(i-i_begin+1,:) = [i train_error_rate test_error_rate];
%         plotData(i-i_begin+1,:) = [i train_mse test_mse];
    end
    plot(plotData(1:end,1),plotData(1:end,2:3));
end