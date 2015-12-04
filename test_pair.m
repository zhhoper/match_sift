% This file is used to compute the matched information

% add vl_feat to path
run('~/lib/vlfeat-0.9.20/toolbox/vl_setup');

% add the folder containing the images
addpath('../Data/Selected_Images/00000065/');

% loading the matched pair
fileID = fopen('test_pair.txt');
content = textscan(fileID,'%s %s');
fclose(fileID);

numPairs = size(content{1},1);

outID = fopen('result.txt', 'w');
for i = 1 : numPairs
		% loading two images
		I1 = imread(content{1}{i});
		I2 = imread(content{2}{i});
		
		gI1 = single(rgb2gray(I1));
		gI2 = single(rgb2gray(I2));

		% compute the matched information
		[total_matched, correct_1, correct_2, sift_matched, f1, f2] = sift_match(gI1, gI2);

		% draw correspondence when mathced features are less than 50
		if size(correct_1, 2) < 50
				saveName = sprintf('first_%d.jpg', i);
				draw_matched(I1, I2, f1, f2, correct_1, saveName);
		end

		if size(correct_2, 2) < 50
				saveName = sprintf('second_%d.jpg', i);
				draw_matched(I1, I2, f1, f2, correct_2, saveName);
		end	
		% record
		fprintf(outID, '%s %s ', content{1}{i}, content{2}{i});
		fprintf(outID, '%4d %4d %4d %4d\n', size(total_matched, 2), size(correct_1, 2), size(correct_2, 2), size(sift_matched,2)); 
end

fclose(outID);

