function [N,E,U]=XYZ2NEU(X,Y,Z)
% X Y Z 为 测站在WGS-84的坐标， N E U 为站心坐标
[B,L,h]=XYZ2BLH(X,Y,Z);
N=-sin(B)*cos(L)*X-sin(B)*sin(L)*Y+cos(B)*Z;
E=-sin(L)*X+cos(L)*Y;
U=cos(B)*cos(L)*X+cos(B)*sin(L)*Y+sin(B)*Z;

end