function [ predicted ] = Predict(model,test_x_all,test_y_all,test_size,modeltype)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    predicted = zeros(test_size,1);
	test_x = test_x_all(1:test_size,:);
	test_y = test_y_all(1:test_size,:);
	%xsize = size(train_x)
	%ysize = size(train_y)
	if modeltype==1%baseline
		
		%thetasize = size(theta)
% 		predicted = test_x*model;
        predicted = predict(model,test_x(:,2:end));
	end
	if modeltype==2%ridge
	
% 		lmmdl = ridge( train_y,train_x(:,2:end),2^log2lambda,0);
		
		predicted = test_x(:,1:end)*model;

	end
	if modeltype==3%livsvm
		
		predicted = svmpredict(test_y(:,:),test_x(:,:),model,'-q');
    end
    if modeltype==4%livsvm
        
        predicted = predict(model,test_x);
    end


end

