% ----------------------------------------------
% Purpose: Broadcast ephemeris to xyz
% Input  : Eph      struct  I   broadcast ephemeris
% Output : eph_xyz  struct  O   xyz in ECEF
% ----------------------------------------------
function [xyz]=eph2satxyz(Eph,rcv)
    % constant
    u=3.986005e+14; % Earth's universal gravitation constant
    CLIGHT = 299792458.0;
    Wedot= 7.2921151467e-5;
    % ------------------------------------------
    [sat_num,column]=size(Eph);
    xyz0 = struct('x',[],'y',[],'z',[],'svid',[],'dts',[]);
    xyz=repmat(xyz0,[sat_num,1]);
    for sat_indx=1:sat_num
        % The average angular velocity of satellite
        a=Eph(sat_indx).sqrta^2;  % sqrta: square root of semi-major axis a; a: semi-major axis a
        n0 = sqrt(u/(a)^3); % n0: angular velocity(according to the kelplar law)
        n = n0 + Eph(sat_indx).dn; % dn: mean motion correction(perturbation parameter); n: average angular velocity of satellite
        % The mean anomaly of satellite
        t = Eph(sat_indx).tow - rcv(sat_indx).pr/CLIGHT;
        % t = Eph(sat_indx).tow;        
        M = Eph(sat_indx).m0 + n*(t - Eph(sat_indx).toe);
        % The eccentricity anomaly
        E = 0.0;
        while true
            E0 = E;
            E = M + Eph(sat_indx).e*sin(E0);
            if abs(E-E0)<0.000001
                break
            end
        end
        % True anomaly
        f = atan2(sqrt((1-(Eph(sat_indx).e)^2))*sin(E),cos(E)-Eph(sat_indx).e);
        theta_ = f + Eph(sat_indx).w;
        % perturbation correction items
        sigma_theta = Eph(sat_indx).cus*sin(2*theta_)+Eph(sat_indx).cuc*cos(2*theta_);
        sigma_afa = Eph(sat_indx).crs*sin(2*theta_)+Eph(sat_indx).crc*cos(2*theta_);
        sigma_i = Eph(sat_indx).cis*sin(2*theta_)+Eph(sat_indx).cic*cos(2*theta_);
        % perturbation correction
        u_ = sigma_theta + theta_;
        r = a*(1-Eph(sat_indx).e*cos(E))+sigma_afa;
        i = Eph(sat_indx).i0+sigma_i+Eph(sat_indx).idot*(t - Eph(sat_indx).toe);
        % Satellite coordinate at orbit plane
        x = r*cos(u_);
        y = r*sin(u_);
        L = Eph(sat_indx).omg0+Eph(sat_indx).odot*(t - Eph(sat_indx).toe)-Wedot*t;
        % XYZ ECEF
        X = x*cos(L)-y*cos(i)*sin(L);
        Y = x*sin(L)+y*cos(i)*cos(L);
        Z = y*sin(i);
        XYZ=[X;Y;Z];
        % earth rotation correction
        earth_rot_angle = Wedot*rcv(sat_indx).pr/CLIGHT;
        earth_rot_Matrix=[cos(earth_rot_angle)     sin(earth_rot_angle)   0;
                          -sin(earth_rot_angle)    cos(earth_rot_angle)   0;
                            0                      0                      1];
        % earth_rot_Matrix=eye(3);
        XYZ_corr=earth_rot_Matrix*XYZ;
        xyz(sat_indx).x=XYZ_corr(1);
        xyz(sat_indx).y=XYZ_corr(2);
        xyz(sat_indx).z=XYZ_corr(3);
        xyz(sat_indx).svid=Eph(sat_indx).svid;
        % satellite clock correction
        dt = t-Eph(sat_indx).toc;
        dts = Eph(sat_indx).af0+Eph(sat_indx).af1*dt+Eph(sat_indx).af2*dt*dt;
        dts = dts - 2.d0*sqrt(u*a)*Eph(sat_indx).e*sin(E)/(CLIGHT*CLIGHT); %relativity correction
        xyz(sat_indx).dts = dts;


    end
end