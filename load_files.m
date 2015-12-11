function pair_list = load_files(folder_name)
% this function is used to load testing pairs making use of all the images

pair_list = {};
count = 1;
file_names = dir(strcat(folder_name, '/*.jpg'));

num_files = length(file_names);

for i = 1 : num_files - 1
		for j = i+1 : num_files
				pair_list{count, 1} = file_names(i).name;
				pair_list{count, 2} = file_names(j).name;
				count = count + 1;
		end
end
end
