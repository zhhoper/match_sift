% This file is used to crop the water marks

% add the folder containing the images
folder_path = '../Data/Selected_Images_DayNight/';
folder_list = dir(folder_path);

num_folders = length(folder_list);

total_num = 0;
for i = 1 : num_folders
		folder_name = strcat(folder_path, folder_list(i).name);
		if strcmp(folder_name(end), '.') || strcmp(folder_name(end-1:end), '..')
				continue;
		end
		
		ori_folder1 = fullfile(folder_name, 'day');
		ori_folder2 = fullfile(folder_name, 'night');
		crop_folder1 = fullfile(folder_name, 'crop_day');
		crop_folder2 = fullfile(folder_name, 'crop_night');
		if ~exist(crop_folder1)
				mkdir(crop_folder1);
		end
		if ~exist(crop_folder2)
				mkdir(crop_folder2);
		end		

		list_1 = dir(fullfile(ori_folder1, '*.jpg'));
		list_2 = dir(fullfile(ori_folder2, '*.jpg'));

		if exist(fullfile(folder_name, 'crop.txt'));
				fid = fopen(fullfile(folder_name, 'crop.txt'));
				crop_param = textscan(fid, '%d %d %d %d');
				fclose(fid);
		else
				crop_param = [];
		end	

		for i = 1 : length(list_1)
				I = imread(fullfile(ori_folder1, list_1(i).name));
				if ~isempty(crop_param)
						tmp_I = I(crop_param{1} : crop_param{2}, crop_param{3} : crop_param{4}, :);
				else
						tmp_I = I;
				end
				imwrite(tmp_I, fullfile(crop_folder1, list_1(i).name));
		end

		for i = 1 : length(list_2)
				I = imread(fullfile(ori_folder2, list_2(i).name));
				if ~isempty(crop_param)
						tmp_I = I(crop_param{1}:crop_param{2}, crop_param{3} : crop_param{4}, :);
				else
						tmp_I = I;
				end
				imwrite(tmp_I, fullfile(crop_folder2, list_2(i).name));
		end

		ccc = 0;

end
