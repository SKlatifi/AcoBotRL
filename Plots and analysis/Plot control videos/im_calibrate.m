function [coordinates,angle] = im_calibrate(I_in)

% Rotation
imshow(I_in);
disp('Choose top left and right for rotation!!');
coordinates = zeros(2,2);
for i = 1:2
    coordinates(i,:) = ginputWhite(1);
end
vector = [coordinates(2,:) - coordinates(1,:) 0];
i_vect = [1 0 0];
cross_product = norm(cross(i_vect,vector));
angle = rad2deg(asin(cross_product/(norm(i_vect)*norm(vector))));
I_rotated = imrotate(I_in,-angle);

% Transportation
imshow(I_rotated);
disp('Choose top left and bottom right for transportation!!');
coordinates = zeros(2,2);
for i = 1:2
    coordinates(i,:) = round(ginputWhite(1));
end
% I_out = I_rotated(coordinates(1,2):coordinates(2,2),...
%     coordinates(1,1):coordinates(2,1),:);
% imshow(I_out);

end