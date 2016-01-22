folder_path = '../Data/Selected_Images_DayNight/matchnet_new/';
folder_list = dir(folder_path);
num_folders = length(folder_list);

for i = 1 : num_folders
		folder_name = strcat(folder_path, folder_list(i).name);
		if strcmp(folder_name(end), '.') || strcmp(folder_name(end-1:end), '..')
				continue;
		end

		% load images
		file_name = dir(fullfile(folder_name, '*.bmp'));
		num_file = length(file_name);

		for j = 1 : num_file
				if strcmp(file_name(j).name(end-7: end-4), 'sift')
						tmp = file_name(j).name(9:end-9);
						tmp_num = str2num(tmp);
						save_name = fullfile(folder_name, sprintf('matchnet%04d_sift.bmp', tmp_num));
						img = imread(fullfile(folder_name, file_name(j).name));
						imwrite(img, save_name);
				end
		end
end

