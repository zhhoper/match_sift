% add vl_feat to path
run('~/lib/vlfeat-0.9.20/toolbox/vl_setup');

% add the folder containing the images
addpath('../Data/Selected_Images_DayNight/00001093/crop_day/');
addpath('../Data/Selected_Images_DayNight/00001093/crop_night/');

% load two images
%I1 = imread('20151101_133309.jpg');
%I2 = imread('20151101_140305.jpg');
I1 = imread('20151102_135413.jpg');
I2 = imread('20151102_072412.jpg');

I1 = single(rgb2gray(I1));
I2 = single(rgb2gray(I2));

[f1, td1] = vl_sift(I1);
[f2, td2] = vl_sift(I2);

frame_1 = f1;
frame_2 = f2;
frame_1(4,:) = 0;
frame_2(4,:) = 0;
[tf1, d1] = vl_sift(I1, 'frames', frame_1);
[tf2, d2] = vl_sift(I2, 'frames', frame_2); 

%tf1 = f1;
%tf2 = f2;
%d1 = td1;
%d2 = td2;

%thr_total = sqrt(2);
thr_total = 5;
thr_sift = 5;
thr_scale = 1.2;
thr_orientation = pi/8;

fprintf('Computing the total match...\n');
%[total_matched, total_score] = matched_points(f1, f2, thr_total);
tic
[total_matched, total_score] = matched_points_DAISY_fast(tf1, tf2, thr_total, thr_scale, thr_orientation);
toc
fprintf('Number of matched points is %d\n', size(total_matched,2));

fprintf('Computing position correct...\n');
[correct_1, matched_1] = position_correct(d1, d2, total_matched);
fprintf('Number of correct matched feature in position is %d\n', size(correct_1, 2));

fprintf('Computing sift correct...\n');
[correct_2, matched_2] = sift_correct(f1, f2, d1, d2, thr_sift);
fprintf('Number of correct matched feature under threshold is %d\n', size(correct_2, 2));


% draw match for top 5 matches
num_show = 1; 
xa = tf1(1, total_matched(1,1:num_show));
xb = tf2(1, total_matched(2,1:num_show)) + size(I1, 2);

ya = tf1(2, total_matched(1,1:num_show));
yb = tf2(2, total_matched(2,1:num_show));

imshow(cat(2, I1, I2), []);
hold on;
h = line([xa; xb], [ya; yb]);
set(h, 'linewidth', 2, 'color', 'b');

%vl_plotframe(tf1(:, matches(1, index(1:5))));
%tf2(1,:) = f2(1,:) + size(I1,2);
