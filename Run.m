%Entry function
%Attention:To run the code in 'g11.bug.face.attractiveness' and addpath('bean')
function [train_error_rate, test_error_rate, cv_error_rate, train_mse, test_mse, cv_mse]=Run(featurevector,modeltype,quadraticflag,badpoints_filename,log2lambda)
% Sample run:  Run([1 1 1 1 1 1 1 1 1 0 0 0 1 0 0],3,0,'bad.txt',0)
%model index explanation
	%model 1:baseline
	%model 2:ridge
	%model 3:libsvm
%feature index explanation
	%feature 1:faceheight./facewidth
	%feature 2:mouthwidth./facewidth
	%feature 3:jawcurvature
	%feature 4:eyewidth./facewidth
	%feature 5:eyeheight./faceheight
	%feature 6:eyebrowwidth./facewidth
	%feature 7:noseheight./faceheight 
	%feature 8:nosewidth./noseheight 
	%feature 9:midfaceheight./lowfaceheight 
	%feature 10:cheekbonewidth./jawwidth 
	%feature 11:nosewidth./eyewidth 
	%feature 12:nosewidth./mouthwidth 
	%feature 13:eyebrowcurvature 
	%feature 14:eyewidth./eyeheight 
	%feature 15:mouthwidth./mouthheight
%lambda is only valid for ridge regression
%if you want to run svm, should addpath('g11.bug.face.attractiveness.by jkm') and if you cannot support svmtrain and svmpredict in that file, you can addpath('libsvm_bean')
%if you want to define new feature,you can add them in buildFeature.m(don't forget the comment), define and add to all_features, then expand param 'featurevector'()
%if you want to define new model, define in 'trainAndPredict.m', if you need some extra processing on data define in buildFeature.m

    badpoints = importdata(badpoints_filename);
	[train_x, train_y,test_x,test_y,valid_x,valid_y]=buildFeature(featurevector,modeltype,quadraticflag,badpoints,0);
    
	[predict]=trainAndPredict(train_x,train_y,length(train_y),test_x,test_y,length(test_y),modeltype,log2lambda);
	[error_rate,error_count,count,wrongpair,test_mse]=evaluation(test_y,predict);
	test_error_rate=error_rate
	test_error_count=error_count;
	test_count=count;
    
%     [predict]=trainAndPredict(train_x,train_y,length(train_y),valid_x,valid_y,length(valid_y),modeltype);
% 	[error_rate,error_count,count,wrongpair]=evaluation(valid_y,predict);
% 	valid_error_rate=error_rate;
% 	valid_error_count=error_count;
% 	valid_count=count;
    
    [predict]=trainAndPredict(train_x,train_y,length(train_y),train_x,train_y,length(train_y),modeltype,log2lambda);
	[error_rate,error_count,count,wrongpair,train_mse]=evaluation(train_y,predict);
	train_error_rate=error_rate
	train_error_count=error_count;
	train_count=count;
    
    sum_err=0;
    cv_mse=0;
    for j = 1:100
        n_cv = 5;
        indices = crossvalind('Kfold',length(train_y),n_cv);
        for i = 1:n_cv
            valid_i = (indices == i);
            train_i = ~valid_i;
            [predict]=trainAndPredict(train_x(train_i,:),train_y(train_i,:),sum(train_i),train_x(valid_i,:),train_y(valid_i,:),sum(valid_i),modeltype,log2lambda);
            [error_rate,error_count,count,wrongpair,cv_mse_tmp]=evaluation(train_y(valid_i,:),predict);
            sum_err=sum_err+error_rate;
            cv_mse = cv_mse+cv_mse_tmp;
            valid_error_count=error_count;
            valid_count=count;
        end
        
%         n_cv = 1;
%         [train_i, valid_i] = crossvalind('LeaveMOut',length(train_y),1);
%         [predict]=trainAndPredict(train_x(train_i,:),train_y(train_i,:),sum(train_i),train_x(valid_i,:),train_y(valid_i,:),sum(valid_i),modeltype,log2lambda);
%         [error_rate,error_count,count,wrongpair]=evaluation(train_y(valid_i,:),predict);
%         sum_err=sum_err+error_rate;
%         valid_error_count=error_count;
%         valid_count=count;
 
    end
    cv_error_rate = sum_err/n_cv/100
    cv_mse = cv_mse/n_cv/100;
end