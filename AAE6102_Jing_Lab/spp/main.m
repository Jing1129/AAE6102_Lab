clear all 
clc
CLIGHT = 299792458.0;
eph_file='../Data/eph.dat';
rcv_file='../Data/rcvr.dat';
fprintf("-------- Codes Started --------\n");
fprintf("Reading rcvr.dat ......\n");
[rcv] = readrcvr(rcv_file); % read receiver file
fprintf("Reading eph.dat ......\n");
[Eph_broadcast] = readeph(eph_file); % read ephemeris file
fprintf("Converting orbit parameters to ECEF coordinates ......\n");
[Eph_xyz] = eph2satxyz(Eph_broadcast,rcv); % Get the ephemeris ECEF coordinate

[sat_num_rcv,column]=size(rcv);
[sat_num_eph,column]=size(Eph_xyz);

A = zeros(sat_num_rcv,4);
P = eye(sat_num_rcv,sat_num_rcv);
L = zeros(sat_num_rcv,1);
p = zeros(sat_num_rcv);
xyzt = zeros(4,1);

X0 = -2694685.473;
Y0 = -4293642.366;
Z0 =  3857878.924;
clock_bias = 0;
iter = 0;
while true
    xyz_0 = [X0;Y0;Z0];
    iter = iter + 1;
    fprintf("==========iter = %d==========\n",iter);
    for sat_indx=1:sat_num_rcv
        pr = rcv(sat_indx).pr;
        svid = rcv(sat_indx).svid;
        for sat_indx_eph=1:sat_num_eph
            if (Eph_xyz(sat_indx_eph).svid==rcv(sat_indx).svid)
    
                % Set A matrix
                R = sqrt((X0-Eph_xyz(sat_indx_eph).x)*(X0-Eph_xyz(sat_indx_eph).x) + (Y0-Eph_xyz(sat_indx_eph).y)*(Y0-Eph_xyz(sat_indx_eph).y) + (Z0-Eph_xyz(sat_indx_eph).z)*(Z0-Eph_xyz(sat_indx_eph).z));
                df_dx = (X0-Eph_xyz(sat_indx_eph).x)/R;
                df_dy = (Y0-Eph_xyz(sat_indx_eph).y)/R;
                df_dz = (Z0-Eph_xyz(sat_indx_eph).z)/R;
                A(sat_indx,1)=df_dx;
                A(sat_indx,2)=df_dy;
                A(sat_indx,3)=df_dz;
                A(sat_indx,4)=1;
                % dtrop
                [X0_N,Y0_E,Z0_U]=XYZ2NEU(X0,Y0,Z0);
                [x_N,y_E,z_U]=XYZ2NEU(Eph_xyz(sat_indx_eph).x,Eph_xyz(sat_indx_eph).y,Eph_xyz(sat_indx_eph).z);
                s_agle=asind((z_U-Z0_U)/sqrt(sum([x_N-X0_N,y_E-Y0_E,z_U-Z0_U].^2)));
                dtrop=2.47/sind(s_agle)+0.0121;
                % Set P matrix      

                % Set L matrix
                dts = Eph_xyz(sat_indx_eph).dts;
                L(sat_indx,1)=pr-R+CLIGHT*dts-clock_bias;  %minus or add dtrop??????
            end
        end
    end
    xyzt = (A'*P*A)\(A'*P*L);
    dx = xyzt(1,1);
    dy = xyzt(2,1);
    dz = xyzt(3,1);
    dtr_m = xyzt(4,1);
    fprintf(" dx = %9.3f (m)\n dy = %9.3f (m)\n dz = %9.3f (m)\n",dx,dy,dz);
    fprintf(" dtr = %8.6f (s)\n",dtr_m/CLIGHT);
    if (dx<1e-4 && dy<1e-4 && dz<1e-4 && dtr_m<1e-4)
        X = X0 + dx;
        Y = Y0 + dy;
        Z = Z0 + dz;
        clock_bias = clock_bias + dtr_m;
        break
    else
        X0 = X0 + dx;
        Y0 = Y0 + dy;
        Z0 = Z0 + dz; 
        clock_bias = clock_bias + dtr_m;
        fprintf(" X_update =%16.6f (m)\n Y_update =%16.6f (m)\n Z_update =%16.6f (m)\n",X0,Y0,Z0);
    end

end
fprintf("==========Final Results:==========\n");
fprintf("The coordinate of the receiver:\n");
fprintf(" X =%16.6f (m)\n Y =%16.6f (m)\n Z =%16.6f (m)\n",X,Y,Z);
fprintf("The receiver clock offset is:\n")
fprintf(" dtr = %8.6f (s)\n",clock_bias/CLIGHT);

% Save Eph_xyz struct in xml file
save('eph.mat',"Eph_xyz");
eph = load('eph.mat');
writestruct(eph,"eph.xml");



