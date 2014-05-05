function [predict] = trainAndPredict(train_x_all,train_y_all,train_size,test_x_all,test_y_all,test_size,modeltype,lambda)
%this function train a model according to the modeltype, output the predict value
	%train & test: extend this part according to modeltype
	%test_size = size(test_x,1);%row num
	predict = zeros(test_size,1);
	train_x = train_x_all(1:train_size,:);
	train_y = train_y_all(1:train_size,:);
	test_x = test_x_all(1:test_size,:);
	test_y = test_y_all(1:test_size,:);
	%xsize = size(train_x)
	%ysize = size(train_y)
	if modeltype==1%baseline
		theta = pinv(train_x'*train_x)*train_x'*train_y;
		%thetasize = size(theta)
		predict = test_x*theta;
		% for i=1:test_size
			% size(theta)
			% size(test_x(i, :))
			% size(predict(i))
			% predict(i)=test_x(i, :)*theta;
		% end
	end
	if modeltype==2%ridge
		%size_train_x = size(train_x)
		%train_x=x2fx(train_x,'quadratic');
		%test_x=x2fx(test_x,'quadratic');
		lmmdl = ridge( train_y,train_x(:,2:end),lambda,0);
		predict = test_x(:,1:end)*lmmdl;
	end
	if modeltype==3%livsvm
		model = svmtrain(train_y,train_x,['-q -s 3 -t 2 -c ', num2str(2^1), ' -g ', num2str(2^-7)] );
		predict = svmpredict(test_y(:,:),test_x(:,:),model,'-q');
	end
end