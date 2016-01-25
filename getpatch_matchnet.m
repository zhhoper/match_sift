function getPatch_matchnet()
% This file is used to prepare the paired match for using matchnet (crop a 64*64 image match around the key-point)

% add vl_feat to path
run('~/lib/vlfeat-0.9.20/toolbox/vl_setup');
%run(vl_path);

% add the folder containing the images
folder_path = '../Data/Selected_Images_DayNight/';

folder_list = dir(folder_path);

num_folders = length(folder_list);

total_num = 0;
total_num_all = 0;
for i = 1 : num_folders
		folder_name = strcat(folder_path, folder_list(i).name);
		if strcmp(folder_name(end), '.') || strcmp(folder_name(end-1:end), '..')
				continue;
		end
		
		% load testing pair images
		pair_name = load_day_night(folder_name);
		%save_folder = fullfile(folder_name, 'matchnet');
		save_folder = fullfile(folder_path, 'matchnet_scale', folder_list(i).name);
		if ~exist(save_folder, 'file')
				mkdir(save_folder);
		end
		

		num_pairs = size(pair_name, 1);
		for j = 1 : num_pairs
				%save name
				save_name = fullfile(save_folder, sprintf('matchnet%04d.txt', j));
				save_name_img = fullfile(save_folder, sprintf('matchnet%04d.bmp', j));
				save_name_sift = fullfile(save_folder, sprintf('matchnet%04d_sift.bmp', j));
				outID = fopen(save_name, 'w');

				name_1 = fullfile(folder_name, pair_name{j,1});
				name_2 = fullfile(folder_name, pair_name{j,2});

				I1 = imread(name_1);
				I2 = imread(name_2);

				gI1 = single(rgb2gray(I1));
				gI2 = single(rgb2gray(I2));

				[total_matched, correct_1, correct_2, sift_matched, f1, f2, d1, d2] = sift_match_fix_orientation_feature(gI1, gI2);

				num_matched = size(total_matched,2);
				unmatched = get_unmatched(size(f1,2), size(f2, 2), total_matched, num_matched);
				% image to save all the patches
				img = zeros(num_matched*2*64, 64*2);
				img_sift = zeros(num_matched*2, 128*2);

				% save matched images
				for ii = 1 : size(total_matched, 2)
						day = total_matched(1,ii);
						night = total_matched(2,ii);
						patch_day = getPatch(day, f1, gI1);	
						patch_night = getPatch(night, f2, gI2);
						
						img( (ii-1)*64+1 : ii*64, 1:64 ) = patch_day;
						img( (ii-1)*64+1 : ii*64, 65:128) = patch_night;

						img_sift(ii, 1:128) = d1(:, day)';
						img_sift(ii, 129:end) = d2(:, night)';

						fprintf(outID, '%d %f\n', 1, norm(double(d1(:, day) - d2(:, night)), 2) );
				end

				for ii = 1 : size(unmatched, 2)
						day = unmatched(1, ii);
						night = unmatched(2, ii);
						patch_day = getPatch(day, f1, gI1);
						patch_night = getPatch(night, f2, gI2);
						unI = ii + size(total_matched,2);

						img( (unI-1)*64+1 : unI*64, 1:64 ) = patch_day;
						img( (unI-1)*64+1 : unI*64, 65:128 ) = patch_night;
					
						img_sift(unI, 1:128) = d1(:, day)';
						img_sift(unI, 129:end) = d2(:, night)';

						fprintf(outID, '%d %f\n', 0, norm(double(d1(:, day) - d2(:, night)), 2));
				end
				fclose(outID);
				imwrite(uint8(img), save_name_img);
				imwrite(uint8(img_sift), save_name_sift);
				ccc = 0;

		end
		ccc = 0;
end
end

function pair = get_unmatched(num_day, num_night, total_matched, num_sample)
% this function is used to randomly sample un-matched patches
% num_day : number of day feature
% num_night : number of night feature
% total_matched : matched pairs
% num_sample : number of samples we want to find
pair = zeros(2, num_sample);
for i = 1 : num_sample
		ind = 1;
		while ind 
				tmp1 = randi(num_day,1);
				tmp2 = randi(num_night,1);
				if ~ismember([tmp1, tmp2], total_matched', 'rows') ...
						&& ~ismember([tmp1, tmp2], pair', 'rows')
						ind = 0;
				end
		end
		pair(:, i) = [tmp1;tmp2];
end

end

function patch = getPatch(index, f, img)
% This function is used to find the patch according to the index
patch = zeros(64,64);
%[row, col] = size(img);
%x = round(f(1, index));
%y = round(f(2, index));

% we need to consider about the scale.
scale = f(3, index);
tmp_img = imresize(img, 1/scale);
[row, col] = size(tmp_img);

x = round(f(1, index)/scale);
y = round(f(2, index)/scale);

xx1 = max(x-32, 1);
xx2 = min(x+31, col);

yy1 = max(y-32, 1);
yy2 = min(y+31, row);

indx1 = max(33-x, 0) + 1;
indx2 = 64 - max(x+31-col, 0);
indy1 = max(33-y, 0) + 1;
indy2 = 64 - max(y+31-row, 0);

patch(indy1:indy2, indx1:indx2) = tmp_img(yy1:yy2, xx1:xx2);
end

