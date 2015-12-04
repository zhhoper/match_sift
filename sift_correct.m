function [corrected_matched, sift_matched] = sift_correct(f1, f2, d1, d2, thr)
% This function is used to get correct match found by SIFT feature vs the matched features. The so called corrected match is that the matched score is smaller equal than a threshold  
% INPUT:
% f1, f2: location, scale and orientation of detected features (first output of vl_sift)
% d1, d2: descriptors (second output of vl_sift)
% thr: threshold for defining correct match 
% OUTPUT:
% corrected_matched: corrected matched points
% sift_matched: pair of matched features

% get sift matches
[sift_matched, score] = vl_ubcmatch(d1, d2);


% compute the distance of matched location
tmp1 = f1(1:2, sift_matched(1,:));
tmp2 = f2(1:2, sift_matched(2,:));
score_location = sqrt(sum((tmp1 - tmp2).^2));

ind = score_location <= thr;
corrected_matched = sift_matched(:, ind);

end
