function [num_correct, num_match] = position_correct(d1, d2, total_matched)
% This function is used to get correct match found by SIFT feature vs the matched features. The so called corrected match is the matched sift features are actually corresponding matched points based on the location 
% INPUT:
% d1, d2: descriptors (second output of vl_sift)
% matched_total: the matched pair of points
% OUTPUT:
% num_correct: number of corrected matched points
% num_match: total number of sift features matched

% get sift matches
[sift_matches, score] = vl_ubcmatch(d1, d2);

num_match = size(sift_matches, 2);

Lia = ismember(sift_matches', total_matched', 'rows');
num_correct = sum(Lia);
