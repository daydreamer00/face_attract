function [predicted model] = trainAndPredict(train_x_all,train_y_all,train_size,test_x_all,test_y_all,test_size,modeltype,log2lambda)
%this function train a model according to the modeltype, output the predict value
	%train & test: extend this part according to modeltype
	%test_size = size(test_x,1);%row num
	predicted = zeros(test_size,1);
	train_x = train_x_all(1:train_size,:);
	train_y = train_y_all(1:train_size,:);
	test_x = test_x_all(1:test_size,:);
	test_y = test_y_all(1:test_size,:);
	%xsize = size(train_x)
	%ysize = size(train_y)
	if modeltype==1%baseline
% 		model = pinv(train_x'*train_x)*train_x'*train_y;
% 		predicted = test_x*model;
        
        model = LinearModel.fit(train_x(:,2:end),train_y);
        predicted = predict(model,test_x(:,2:end));
		
	end
	if modeltype==2%ridge
	
% 		lmmdl = ridge( train_y,train_x(:,2:end),2^log2lambda,0);
		model = ridge( train_y,train_x(:,1:end),2^log2lambda);
		predicted = test_x(:,1:end)*model;

	end
	if modeltype==3%livsvm
		model = svmtrain(train_y,train_x,['-q -s 3 -t 2 -c ', num2str(2^7), ' -g ', num2str(2^-12)] );
		predicted = svmpredict(test_y(:,:),test_x(:,:),model,'-q');
    end
    if modeltype==4%livsvm
        model = LinearModel.stepwise(train_x,train_y,'constant','Verbose',1,'Upper','linear');
%         model = LinearModel.stepwise(train_x,train_y,'constant','Verbose',1,'Upper','linear');
        predicted = predict(model,test_x);
    end
end