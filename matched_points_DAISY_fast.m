function [matched, score] = matched_points_DAISYi_fast(f1, f2, thr_location, thr_scale, thr_ori)
% This function is used to find the matched points based on the location, scale and orientation of detected feature
% INPUT:
% f1, f2: location, scale and orientation of two images (first output of vl_sift)
% thr_location: threshold for defining two locations are matched
% thr_scale: threshold for scale
% thr_ori: threshold for orientation
% OUTPUT:
% matched: 2 X N matrix. N is the number of matched points, first row shows the index in the first image, second row shows the index in the second image 

% setting default value
%scale = 1.6; % default scale of SIFT 

% ----------------------------------------------
% we use the ratio of scale to test the matching
% default value if 1.2 (roughtly 1/4 of scale)
% ----------------------------------------------

switch nargin
case 2
		thr_location = 5;
		thr_scale = 1.2;
		thr_ori = pi/8;
case 3
		thr_scale = 1.2;
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

% compute ratio of scale
tmp_scale_1 = repmat(f1(3,:)', 1, num_2);
tmp_scale_2 = repmat(f2(3,:), num_1, 1);
distance_scale = max(tmp_scale_1, tmp_scale_2)./min(tmp_scale_1, tmp_scale_2);

distance_orientation = pdist2(f1(4,:)',f2(4,:)', @angle_distance);

% make sure that the match is unique
% now we use a stupid way: each time, we find the smallest distance and record the match, then 
% we remove the matched points
indicator_distance = distance_location > thr_location;
indicator_scale = distance_scale > thr_scale;
indicator_orientation = distance_orientation > thr_ori;

distance_location(indicator_distance | indicator_scale | indicator_orientation) = thr_location + 1;

num_row = sum(sum(distance_location <= thr_location, 2) > 0);
num_col = sum(sum(distance_location <= thr_location, 1) > 0);

% maximum number of matched points
num = min(num_row, num_col);
tmp_matched = zeros(2, num);
tmp_score = -1*ones(1, num);

count = 1;
[tmp_min_value, tmp_ind1] = min(distance_location);
[min_value, tmp_ind2] = min(tmp_min_value);
ind_y = tmp_ind2;
ind_x = tmp_ind1(tmp_ind2);
while min_value ~= thr_location + 1
		tmp_matched(1, count) = ind_x;
		tmp_matched(2, count) = ind_y;
		tmp_score(1, count) = min_value;
		count = count + 1;
		distance_location(ind_x, :) = thr_location + 1;
		distance_location(:, ind_y) = thr_location + 1;
		[tmp_min_value, tmp_ind1] = min(distance_location);
		[min_value, tmp_ind2] = min(tmp_min_value);
		ind_y = tmp_ind2;
		ind_x = tmp_ind1(tmp_ind2);
end
matched = tmp_matched(1:2, 1:count-1);
score = tmp_score(1, 1:count-1);
end

function dist = angle_distance(x,y)
% compute the distance between two angles (radians)
tx = x + 2*pi*ceil(-x/pi/2);
ty = y + 2*pi*ceil(-y/pi/2);

dist = min(abs(tx - ty), 2*pi - abs(tx-ty));
end
