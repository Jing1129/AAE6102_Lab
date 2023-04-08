function [N,E,U]=XYZ2NEU(X,Y,Z)
% X Y Z Ϊ ��վ��WGS-84�����꣬ N E U Ϊվ������
[B,L,h]=XYZ2BLH(X,Y,Z);
N=-sin(B)*cos(L)*X-sin(B)*sin(L)*Y+cos(B)*Z;
E=-sin(L)*X+cos(L)*Y;
U=cos(B)*cos(L)*X+cos(B)*sin(L)*Y+sin(B)*Z;

end