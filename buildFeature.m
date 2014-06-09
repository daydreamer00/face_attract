function [train_x, train_y,test_x,test_y,valid_x,valid_y] = buildFeature(featurevector, modeltype,quadraticflag,badpoints,valid_size)
%TODO quadratic
%this function is used to fill train_x, train_y,test_x,test_y according to the feature definition(only apply the features in featurevector indexs)
	
    train_size = 230-valid_size;
    test_size = 100;
	%load files and average the labels
	load('landmarks.mat');
    load('labels.mat');
	label = mean(labels')';
%     label = labels(:,1);
	
    %get factors from landmarks, preparation for feature definition(for x-axis: landmarks(:,index*2), for y-axis:landmarks(:,index*2-1))
	faceheight = landmarks(:, 2)-(landmarks(:, 50)+landmarks(:, 142))./2;%F1
    facewidth = landmarks(:, 25) - landmarks(:, 7);%F2
    mouthwidth = landmarks(:, 93) - landmarks(:, 75);%F3
    mouthheight = landmarks(:,110) - landmarks(:,78);%jkm F4   
    pupildis = landmarks(:, 141) - landmarks(:, 49);%jkm,chg name F5
	eyeheight = (landmarks(:, 54) - landmarks(:, 40)+landmarks(:, 146)-landmarks(:, 132))/2;%jkm F6
    eyebrowwidth = (landmarks(:, 67) - landmarks(:, 59) +landmarks(:, 159)-landmarks(:, 151))/2;%jkm F7
    jawcurvature = (landmarks(:, 31) - landmarks(:, 13)) ./ (landmarks(:, 2) - (landmarks(:, 14) + landmarks(:, 32)) ./ 2);%F8
	%bean
	nosewidth=landmarks(:, 127)-landmarks(:, 125);%F9
	noseheight=(landmarks(:, 68)+landmarks(:, 152))/2-landmarks(:, 118);%F10
	midfaceheight=(landmarks(:, 166)+landmarks(:, 70))/2-(landmarks(:, 128)+landmarks(:, 126))/2;%F11
	lowfaceheight=(landmarks(:, 126)+landmarks(:, 128))-landmarks(:, 2);%F12
	cheekbonewidth=landmarks(:, 23)-landmarks(:, 5);%F13
	jawwidth=landmarks(:, 31)-landmarks(:, 13);%F14
	eyewidth=(landmarks(:, 51)-landmarks(:, 43)+landmarks(:, 143)-landmarks(:, 135))/2;%F15
	eyebrowcurvature=(landmarks(:, 159)-landmarks(:, 151))./(landmarks(:, 164)-(landmarks(:, 160)+landmarks(:, 152))/2);%F16
	
	%feature definition
	all_features = [faceheight./facewidth mouthwidth./facewidth jawcurvature pupildis./facewidth eyeheight./faceheight eyebrowwidth./facewidth noseheight./faceheight nosewidth./noseheight midfaceheight./lowfaceheight cheekbonewidth./jawwidth nosewidth./eyewidth nosewidth./mouthwidth eyebrowcurvature eyewidth./eyeheight mouthwidth./mouthheight];
	%fill features matrix
	features = [];
	for i=1:length(featurevector)
		if featurevector(i)==1
			features = [features all_features(:,i)];
		end
	end
	%TODO quadratic
	if quadraticflag==3
		features = x2fx(features,'quadratic');
    elseif quadraticflag == 2
        features = x2fx(features,'purequadratic');
    else 
        features = x2fx(features,'linear');
	end
	
    
    %perm = [randperm(230) 231:330]; %randomize train and validation set
%     perm = 1:330; %no random
    perm = randperm(330); %random all
    perm(ismember(perm,badpoints)) = [];
    features = features(perm,:);
    label = label(perm,:);
        
    train_i = badpoints(badpoints<=train_size);
    train_size = train_size-length(train_i);
    valid_i = badpoints(badpoints>train_size & badpoints<=train_size+valid_size)-train_size;
    valid_size = valid_size-length(valid_i);
    test_i = badpoints(badpoints>train_size+valid_size)-train_size-valid_size;
    test_size =test_size - length(test_i);
    
    %get train_x,train_y,test_x,test_y
	train_x = features(1:train_size,:);
    test_x = features(train_size+valid_size+1:end,:);
    valid_x = features(train_size+1:train_size+valid_size,:);
    
    train_y = label(1:train_size,:);
    test_y = label(train_size+valid_size+1:end,:);
    valid_y = label(train_size+1:train_size+valid_size,:);
	%extra operation for model:  e.g standardize ?,libsvmwrite,sparse...
	if modeltype==2
		[train_x mean_a std_a] = standardize(train_x);
		test_x = standardize_test(test_x,mean_a,std_a);
	end
	if modeltype==3  %libsvm
		[train_x mean_a std_a] = standardize(train_x);
		test_x = standardize_test(test_x,mean_a,std_a);
		train_x = sparse(train_x);
		%?why
		%libsvmwrite('landmarks.train',train_y,train_x);
		test_x = sparse(test_x);
		%libsvmwrite('landmarks.test',test_y,test_x);
		%[train_y,train_x] = libsvmread('landmarks.train');
		%[test_y,test_x] = libsvmread('landmarks.test');
	end
end

%not add quadratic test