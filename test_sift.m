% this file is used to test vl_sift for sift feature

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

% randomly show 20 features for both images
num = 20;
perm1 = randperm(size(f1,2));
perm2 = randperm(size(f2, 2));

sel1 = perm1(1:num);
sel2 = perm2(1:num);

close all;
figure;
imshow(I1,[]);
h1 = vl_plotframe(f1(:,sel1));
set(h1, 'color', 'k', 'linewidth', 3);

figure;
imshow(I2,[]);
h2 = vl_plotframe(f2(:, sel2));
set(h2, 'color', 'y', 'linewidth', 3);

% finding matches
[matches, score] = vl_ubcmatch(d1, d2);

% draw match for top 5 matches
[~, index] = sort(score, 'ascend');
xa = f1(1, matches(1,index(1:5)));
xb = f2(1, matches(2,index(1:5))) + size(I1, 2);

ya = f1(2, matches(1,index(1:5)));
yb = f2(2, matches(2,index(1:5)));

imshow(cat(2, I1, I2), []);
hold on;
h = line([xa; xb], [ya; yb]);
set(h, 'linewidth', 2, 'color', 'b');

vl_plotframe(f1(:, matches(1, index(1:5))));
f2(1,:) = f2(1,:) + size(I1,2);
vl_plotframe(f2(:, matches(2, index(1:5))));

