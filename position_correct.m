function [corrected_matched, sift_matched] = position_correct(d1, d2, total_matched)
% This function is used to get correct match found by SIFT feature vs the matched features. The so called corrected match is the matched sift features are actually corresponding matched points based on the location 
% INPUT:
% d1, d2: descriptors (second output of vl_sift)
% matched_total: the matched pair of points
% OUTPUT:
% corrected_matched: corrected matched points
% sift_matched: pair of matched features

% get sift matches
[sift_matched, score] = vl_ubcmatch(d1, d2);

Lia = ismember(sift_matched', total_matched', 'rows');

corrected_matched = sift_matched(:, Lia);
end
