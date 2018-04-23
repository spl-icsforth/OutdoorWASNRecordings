function c_cart = mic_array_coordinates(center,R,M)
%Generates the coordinates of the microphones of a uniform circular microphone array given the
%array center, the array radius R, and the number of microphones M
%Output:
%   M x 2 array with the x and y coordinates of each microphone of the
%   array

i = 1:M;
c_polar=[ ((2*pi/M)*(i-1))' R*ones(M,1)];
[x, y]=pol2cart(c_polar(1:M,1), c_polar(1:M,2));
c_cart= repmat(center,M,1) + [x y];
end