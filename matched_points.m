function [matched, score] = matched_points(f1, f2, thr)
% This function is used to find the matched points based on the location of detected feature
% INPUT:
% f1, f2: location, scale and orientation of two images (first output of vl_sift)
% thr: threshold for defining two locations are matched
% OUTPUT:
% matched: 2 X N matrix. N is the number of matched points, first row shows the index in the first image, second row shows the index in the second image 

% compute pair wise distance
tmp1 = f1(1:2, :);
tmp2 = f2(1:2, :);
distance = pdist2(tmp1', tmp2', 'euclidean');

% make sure that the match is unique
% now we use a stupid way: each time, we find the smallest distance and record the match, then 
% we remove the matched points
distance(distance > thr) = thr + 1;

num_row = sum(sum(distance <= thr, 2) > 0);
num_col = sum(sum(distance <= thr, 1) > 0);

% maximum number of matched points
num = min(num_row, num_col);
tmp_matched = zeros(2, num);
tmp_score = -1*ones(1, num);

count = 1;
min_value = min(min(distance));
while min_value ~= thr + 1
	[ind_x, ind_y] = find(distance == min_value);
	for i = 1 : length(ind_x)
			tmp_matched(1, count) = ind_x(i);
			tmp_matched(2, count) = ind_y(i);
			tmp_score(1, count) = min_value;
			count = count + 1;
			distance(ind_x(i), :) = thr + 1;
			distance(:, ind_y(i)) = thr + 1;
	end
	min_value = min(min(distance));
end

matched = tmp_matched(1:2, 1:count-1);
score = tmp_score(1, 1:count-1);
