function dist = angle_distance(x,y)
% compute the distance between two angles (radians)
tx = x + 2*pi*ceil(-x/pi/2);
ty = y + 2*pi*ceil(-y/pi/2);

tmp = abs(tx - ty);
if tmp > 3.141592653 
		tmp = tmp - pi;
end
dist = tmp;
end
