function pair_list = load_readme(file_name);
% this function is used to load testing pairs through readme

pair_list = {};
fileID = fopen(file_name);
count_pair = 1;

tline = fgets(fileID);
while ischar(tline)
		% delete the space at the end
		deblank(tline);

		% tmp_elem to store all the names of the file
		count = 1;
		tmp_elem = {};
		[token, remain] = strtok(tline, ' ');
		if ~isempty(token)
				tmp_elem{count} = deblank(token);
				count = count + 1;
		end

		while ~isempty(remain)
				[token, remain] = strtok(remain, ' ');
				tmp_elem{count} = deblank(token);
				count = count + 1;
		end
		
		for i = 1 : count - 2
				for j = i + 1 : count - 1
						pair_list{count_pair,1} = tmp_elem{i};
						pair_list{count_pair,2} = tmp_elem{j};
						count_pair = count_pair + 1;
				end
		end

		tline = fgets(fileID);
end

fclose(fileID);
% end of function
end

