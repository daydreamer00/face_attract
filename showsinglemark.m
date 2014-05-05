function showsinglemark(j)
% This function is used to show a set of factor marks, j is a landmarks index vector
%=====baseline feature factors=====
%factor 1: faceheight index[1 25 71](operation on x-axis)
%factor 2: facewidth index[13 4](operation on y-axis)
%factor 3: mouthwidth index[47 38](operation on y-axis)
%factor 4: eyewidth index[71 25](operation on y-axis)
%factor 5:jawcurvature index[7 16](operation on both x-axis and y-axis)
	load('landmarks.mat');
	x=landmarks(2,1:2:end);
	y=landmarks(2,2:2:end);
	img = imread(['data/female(' num2str(2) ').jpg']);
	imshow(img);
	hold on;
	for k=1:length(j)
		index = j(k);
		%plot(x(index),y(index),'+');
		%x(index)
		%y(index)
		%num2str(index)
		text(x(index), y(index), num2str(index), 'Color', 'b');
	end
	
end