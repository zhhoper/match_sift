function [matched, score] = matched_points_DAISY(f1, f2, thr_location, thr_scale, thr_ori)
% This function is used to find the matched points based on the location, scale and orientation of detected feature
% INPUT:
% f1, f2: location, scale and orientation of two images (first output of vl_sift)
% thr_location: threshold for defining two locations are matched
% thr_scale: threshold for scale
% thr_ori: threshold for orientation
% OUTPUT:
% matched: 2 X N matrix. N is the number of matched points, first row shows the index in the first image, second row shows the index in the second image 

% setting default value
scale = 1.6; % default scale of SIFT 
switch nargin
case 2
		thr_location = 5;
		thr_scale = 0.25*scale;
		thr_ori = pi/8;
case 3
		thr_scale = 0.25*scale;
		thr_ori = pi/8;
case 4
		thr_ori = pi/8;
end
		
num_1 = size(f1, 2);
num_2 = size(f2, 2);
		
% compute pair wise distance
tmp1 = f1(1:2, :);
tmp2 = f2(1:2, :);
distance_location = pdist2(tmp1', tmp2', 'euclidean');
distance_scale = pdist2(f1(3,:)', f2(3,:)', 'euclidean');
distance_orientation = pdist2(f1(4,:)',f2(4,:)', @angle_distance);
tmp_ind = distance_orientation > pi;
distance_orientation(tmp_ind) = distance_orientation(tmp_ind) - pi;

% make sure that the match is unique
% now we use a stupid way: each time, we find the smallest distance and record the match, then 
% we remove the matched points
indicator_distance = distance_location > thr_location;
indicator_scale = distance_scale > thr_scale;
indicator_orientation = distance_orientation > thr_ori;

distance_location(indicator_distance | indicator_scale | indicator_orientation) = thr_location + 1;
%distance(distance > thr) = thr + 1;

num_row = sum(sum(distance_location <= thr_location, 2) > 0);
num_col = sum(sum(distance_location <= thr_location, 1) > 0);

% maximum number of matched points
num = min(num_row, num_col);
tmp_matched = zeros(2, num);
tmp_score = -1*ones(1, num);

count = 1;
min_value = min(min(distance_location));
while min_value ~= thr_location + 1
	[ind_x, ind_y] = find(distance_location == min_value);
	for i = 1 : length(ind_x)
			tmp_matched(1, count) = ind_x(i);
			tmp_matched(2, count) = ind_y(i);
			tmp_score(1, count) = min_value;
			count = count + 1;
			distance_location(ind_x(i), :) = thr_location + 1;
			distance_location(:, ind_y(i)) = thr_location + 1;
	end
	min_value = min(min(distance_location));
end

matched = tmp_matched(1:2, 1:count-1);
score = tmp_score(1, 1:count-1);
end

function dist = angle_distance(x,y)
% compute the distance between two angles (radians)
tx = x + 2*pi*ceil(-x/pi/2);
ty = y + 2*pi*ceil(-y/pi/2);

dist = abs(tx - ty);
end
