function [total_matched, correct_1, correct_2, sift_matched, f1, f2] = sift_match_fix_orientation(I1, I2)
% Given two images I1, I2, this function is used to compute the totoal number of points that supposed to be matched (total_matched), the number of correct matched points (correct_1 and correct_2), and the matched sift points (sift_matched)
% we suppose I1 and I2 are gray images with single type
% we fix the orientation to be 0, i.e. we do not consider about orientation when compute the descriptor.

% get the original sift features
[tf1, td1] = vl_sift(I1);
[tf2, td2] = vl_sift(I2);

[~, index_1] = sort(tf1(3,:));
[~, index_2] = sort(tf2(3,:));
tf1 = tf1(:, index_1);
tf2 = tf2(:, index_2);
% enforce the orientation to be 0
frame_1 = tf1;
frame_2 = tf2;
frame_1(4,:) = 0;
frame_2(4,:) = 0;

% re-extract features
[f1, d1] = vl_sift(I1, 'frames', frame_1);
[f2, d2] = vl_sift(I2, 'frames', frame_2);

thr_total = 5;
thr_sift = 5;

thr_scale = 1.2;
thr_orientation = +inf;

verbose = 1;
if verbose == 1
	fprintf('Computing the total match...\n');
end
%[total_matched, total_score] = matched_points_DAISY_fast(tf1, tf2, thr_total);
[total_matched, total_score] = matched_points_DAISY_fast(f1, f2, thr_total);

if verbose == 1
	fprintf('Computing the correct position match...\n');
end
[correct_1, matched_1] = position_correct(d1, d2, total_matched);

if verbose == 1
	fprintf('Computing the correct sift match...\n');
end
[correct_2, matched_2] = sift_correct(f1, f2, d1, d2, thr_sift);

sift_matched = matched_1;
num_matched = size(total_matched,2);

if verbose == 1
	fprintf('Number of matched points is %d\n', num_matched);
	fprintf('Number of correct matched feature in position is %d\n', size(correct_1, 2));
	fprintf('Number of correct matched feature under threshold is %d\n', size(correct_2, 2));
end

end
