function pair_list = load_day_night(folder_name)
% This function is used to prepair the name of testing pairs of day images and night images
% folder_name should have two sub-folders: day folder and night folder
% we will check the name of the images first and if there are multiple images for the same hour, we will randomly select one images.

sub1 = 'crop_day';
sub2 = 'crop_night';

folder_1 = fullfile(folder_name, sub1);
folder_2 = fullfile(folder_name, sub2);

% get all the file names
tmp_name1 = dir(fullfile(folder_1, '*.jpg'));
tmp_name2 = dir(fullfile(folder_2, '*.jpg'));

% get the time when the image is taken
hour_name1 = zeros(length(tmp_name1), 1);
hour_name2 = zeros(length(tmp_name2), 1);

for i = 1 : length(tmp_name1)
		hour_name1(i) = str2num(tmp_name1(i).name(10:11));
end
for i = 1 : length(tmp_name2)
		hour_name2(i) = str2num(tmp_name2(i).name(10:11));
end

% check uniquenes
unique_name1 = unique(hour_name1);
unique_name2 = unique(hour_name2);
num_1 = length(unique_name1);
num_2 = length(unique_name2);

total_num = num_1 * num_2;
pair_list = {total_num, 2};
count = 1;

for i = 1 : num_1
		for j = 1 : num_2
				tmp_ind_1 = find(hour_name1 == unique_name1(i));
				tmp_ind_2 = find(hour_name2 == unique_name2(j));

				% random select the one image if we have many
				if length(tmp_ind_1) == 1
						select_name1 = tmp_name1(tmp_ind_1).name;
				else
						rand_ind = randperm(length(tmp_ind_1),1);
						select_name1 = tmp_name1(tmp_ind_1(rand_ind)).name;

				end
				
				if length(tmp_ind_2) == 1
						select_name2 = tmp_name2(tmp_ind_2).name;
				else
						rand_ind = randperm(length(tmp_ind_2),1);
						select_name2 = tmp_name2(tmp_ind_2(rand_ind)).name;
				end

				% record the name
				pair_list{count, 1} = fullfile(sub1, select_name1);
				pair_list{count, 2} = fullfile(sub2, select_name2);
				count = count + 1;
		end
end

end

