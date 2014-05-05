function sort = findbeauty()
%Just for fun: this function can show you the females in decent order of labeled scores
	load('labels.mat');
	label = mean(labels')';
	index = [1:330]';
	index_label = [index label];
	sorted = sortrows(index_label,-2);
	show = sorted(:,1);
	for i=1:length(show)
		show(i)
		img = imread(['data/female(' num2str(show(i)) ').jpg']);
        imshow(img);
		pause(5);
	end
end