function [B,L,h]=XYZ2BLH(X,Y,Z)
%WGS空间坐标转换成大地坐标，
%input  X  Y Z
%output B  L H   用弧度表示
 a84=6378137.000d0;
 b84=6356752.310d0;
 ee=(a84^2-b84^2)/a84^2;
 p=sqrt(X^2+Y^2);
 B0=atan2(Z,p);
 N0=a84/sqrt(1-ee*sin(B0)^2);
 B=atan2(Z+N0*ee*sin(B0),p);
while B-B0>0.001   
      B0=B;
      N0=a84/sqrt(1-ee*sin(B0)^2);
      B=atan2(Z+N0*ee*sin(B0),p);
end
 L=atan2(Y,X);
 h=p/cos(B)-N0;

end
