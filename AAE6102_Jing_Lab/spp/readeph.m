% ----------------------------------------------------
% Purpose: Read broadcast ephemeris from eph.dat file
% Input  : FILE   string  I   Broadcast ephemeris file
% Output : Eph    struct  O   Ephemeris struct array
% ----------------------------------------------------
function [Eph] = readeph(FILE)
    FileID = fopen(FILE,'r');
    formatSpec = '%f %d %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %d';
    size_eph = [24 inf];
    eph = fscanf(FileID,formatSpec,size_eph);
    fclose(FileID);
    eph = eph';
    [sat_num,eph_para_num]=size(eph);
    data0 = struct('tow',[],'svid',[],'toc',[],'toe',[],'af0',[],'af1',[],'af2',[],'ura',[],'e',[],'sqrta',[],'dn',[],'m0',[],'w',[],'omg0',[],'i0',[],'odot',[],'idot',[],'cus',[],'cuc',[],'cis',[],'cic',[],'crs',[],'crc',[],'iod',[]);
    data=repmat(data0,[sat_num,1]);
    for sat_indx=1:sat_num
        for para_indx=1:eph_para_num
            if (para_indx==1)
                data(sat_indx).tow = eph(sat_indx,para_indx);
            elseif (para_indx==2)
                data(sat_indx).svid = int16(eph(sat_indx,para_indx));
            elseif (para_indx==3)
                data(sat_indx).toc = eph(sat_indx,para_indx);
            elseif (para_indx==4)
                data(sat_indx).toe = eph(sat_indx,para_indx);
            elseif (para_indx==5)
                data(sat_indx).af0 = eph(sat_indx,para_indx);
            elseif (para_indx==6)
                data(sat_indx).af1 = eph(sat_indx,para_indx);
            elseif (para_indx==7)
                data(sat_indx).af2 = eph(sat_indx,para_indx);
            elseif (para_indx==8)
                data(sat_indx).ura = eph(sat_indx,para_indx);
            elseif (para_indx==9)
                data(sat_indx).e = eph(sat_indx,para_indx);
            elseif (para_indx==10)
                data(sat_indx).sqrta = eph(sat_indx,para_indx);
            elseif (para_indx==11)
                data(sat_indx).dn = eph(sat_indx,para_indx);
            elseif (para_indx==12)
                data(sat_indx).m0 = eph(sat_indx,para_indx);
            elseif (para_indx==13)
                data(sat_indx).w = eph(sat_indx,para_indx);
            elseif (para_indx==14)
                data(sat_indx).omg0 = eph(sat_indx,para_indx);
            elseif (para_indx==15)
                data(sat_indx).i0 = eph(sat_indx,para_indx);
            elseif (para_indx==16)
                data(sat_indx).odot = eph(sat_indx,para_indx);
            elseif (para_indx==17)
                data(sat_indx).idot = eph(sat_indx,para_indx);
            elseif (para_indx==18)
                data(sat_indx).cus = eph(sat_indx,para_indx);
            elseif (para_indx==19)
                data(sat_indx).cuc = eph(sat_indx,para_indx);
            elseif (para_indx==20)
                data(sat_indx).cis = eph(sat_indx,para_indx);
            elseif (para_indx==21)
                data(sat_indx).cic = eph(sat_indx,para_indx);
            elseif (para_indx==22)
                data(sat_indx).crs = eph(sat_indx,para_indx);
            elseif (para_indx==23)
                data(sat_indx).crc = eph(sat_indx,para_indx);
            elseif (para_indx==24)
                data(sat_indx).iod = int16(eph(sat_indx,para_indx));
            end
        end
        Eph = data;
    end
end