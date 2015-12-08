% This file is used to compute the matched information for all the data we have

% add vl_feat to path
run('~/lib/vlfeat-0.9.20/toolbox/vl_setup');

% add the folder containing the images
folder_path = '../Data/Selected_Images/';
folder_list = dir(folder_path);

num_folders = length(folder_list);
name = 'result.txt';

total_num = 0;
for i = 1 : num_folders
		folder_name = strcat(folder_path, folder_list(i).name);
		if strcmp(folder_name(end), '.') || strcmp(folder_name(end-1:end), '..')
				continue;
		end
		
		file_name = fullfile(folder_name, 'README');
		if exist(file_name)
				pair_name = load_readme(file_name);
		else
				pair_name = load_files(folder_name);
		end
		
		save_name = fullfile(folder_name, name);
		
		outID = fopen(save_name, 'w');

		num_pairs = size(pair_name, 1);
		for j = 1 : num_pairs
				name_1 = fullfile(folder_name, pair_name{j,1});
				name_2 = fullfile(folder_name, pair_name{j,2});

				I1 = imread(name_1);
				I2 = imread(name_2);

				gI1 = single(rgb2gray(I1));
				gI2 = single(rgb2gray(I2));

				[total_matched, correct_1, correct_2, sift_matched, f1, f2] = sift_match_fix_orientation(gI1, gI2);
				
				fprintf(outID, '%s %s ', name_1, name_2);
				fprintf(outID, '%4d %4d %.2f %4d %4d ', size(total_matched,2), size(correct_1,2), size(correct_1,2)/size(total_matched,2), size(correct_2, 2), size(sift_matched, 2));	

				if size(correct_1, 2)/size(total_matched, 2) < 0.25
						fprintf(outID, '1\n');
						total_num = total_num + size(total_matched, 2);
				else
						fprintf(outID, '0\n');
				end
		end
		
		fclose(outID);

		ccc = 0;

end

