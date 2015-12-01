function [num_correct, num_match] = sift_correct(f1, f2, d1, d2, thr)
% This function is used to get correct match found by SIFT feature vs the matched features. The so called corrected match is that the matched score is smaller equal than a threshold  
% INPUT:
% f1, f2: location, scale and orientation of detected features (first output of vl_sift)
% d1, d2: descriptors (second output of vl_sift)
% thr: threshold for defining correct match 
% OUTPUT:
% num_correct: number of corrected matched points
% num_match: total number of sift features matched

% get sift matches
[sift_matches, score] = vl_ubcmatch(d1, d2);

num_match = size(sift_matches, 2);

% compute the distance of matched location
tmp1 = f1(1:2, sift_matches(1,:));
tmp2 = f2(1:2, sift_matches(2,:));
score_location = sqrt(sum((tmp1 - tmp2).^2));

ind = score_location <= thr;
num_correct = sum(ind);
