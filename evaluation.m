function [error_rate,error_count,count,wrongpair] = evaluation(test_y,predict_y)
%the evaluation method is raised by Bug group
	test_y;
	predict_y;
	MAX=500;
	count = 0;
    error_count = 0;
	len = length(predict_y);
	wrongpair=zeros(MAX,2);
    for i = 1:(len)
        for j = (1):len
            if abs(test_y(i) - test_y(j)) >= 1 
                count = count + 1;
                result_i = predict_y(i);
                result_j = predict_y(j);
                result_d = result_i-result_j;
                test_y_d = test_y(i) - test_y(j);
                if (result_i <= result_j && test_y(i) > test_y(j)) || (result_i >= result_j && test_y(i) < test_y(j))
                    error_count = error_count + 1;
					wrongpair(error_count,:)=[i j];
                end
            end
        end
    end
    error_rate = error_count / count;
end