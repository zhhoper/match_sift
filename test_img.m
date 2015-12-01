% add vl_feat to path
run('~/lib/vlfeat-0.9.20/toolbox/vl_setup');

% add the folder containing the images
addpath('../Data/Selected_Images/00000065/');

% load two images
I1 = imread('20151101_133309.jpg');
I2 = imread('20151101_140305.jpg');

I1 = single(rgb2gray(I1));
I2 = single(rgb2gray(I2));

[f1, d1] = vl_sift(I1);
[f2, d2] = vl_sift(I2);

thr_total = sqrt(2);
thr_sift = 2;

fprintf('Computing the total match...\n');
[total_matched, total_score] = matched_points(f1, f2, thr_total);

fprintf('Computing position correct...\n');
[correct_1, matched_1] = position_correct(d1, d2, total_matched);

fprintf('Computing sift correct...\n');
[correct_2, matched_2] = sift_correct(f1, f2, d1, d2, thr_sift);

