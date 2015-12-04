function draw_matched(I1, I2, f1, f2, matched_points, saveName)
% draw matched points and print

xa = f1(1, matched_points(1,:));
xb = f2(1, matched_points(2,:)) + size(I1,2);

ya = f1(2, matched_points(1,:));
yb = f2(2, matched_points(2,:));

imshow(cat(2, I1, I2));
hold on;
h = line([xa; xb], [ya; yb]);
set(h, 'linewidth', 1, 'color', 'b');

vl_plotframe(f1(:, matched_points(1,:)));
f2(1,:) = f2(1,:) + size(I1, 2);
vl_plotframe(f2(:, matched_points(2,:)));


w = 10;
h = w/2*size(I2,1)/size(I1,2);
set(gcf, 'PaperUnits', 'inches', 'PaperPosition', [0,0,w,h]);
print(1, saveName, '-djpeg');
close all;
