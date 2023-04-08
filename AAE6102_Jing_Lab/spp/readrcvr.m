% ----------------------------------------------------
% Purpose: Read receiver data from rcvr.dat file
% Input  : FILE   string  I   Receiver file
% Output : rcv    struct  O   Receiver struct array
% ----------------------------------------------------
function [rcv] = readrcvr(FILE)
    FileID = fopen(FILE,'r');
    formatSpec = '%f %d %f %d %d %d %d';
    size_rcv = [7 inf];
    rcv_ = fscanf(FileID,formatSpec,size_rcv); % build the rcv struct
    fclose(FileID);
    rcv_ = rcv_';
    [sat_num,rcv_para_num] = size(rcv_);
    rcv0 = struct('rcvr_tow',[],'svid',[],'pr',[],'cycles',[],'phase',[],'slp_dtct',[],'snr_dbhz',[]);
    rcv = repmat(rcv0,[sat_num,1]);
    for sat_indx=1:sat_num
        for para_indx=1:rcv_para_num
            if (para_indx==1)
                rcv(sat_indx).rcvr_tow = rcv_(sat_indx,para_indx);
            elseif (para_indx==2)
                rcv(sat_indx).svid = int16(rcv_(sat_indx,para_indx));
            elseif (para_indx==3)
                rcv(sat_indx).pr = rcv_(sat_indx,para_indx);
            elseif (para_indx==4)
                rcv(sat_indx).cycles = rcv_(sat_indx,para_indx);
            elseif (para_indx==5)
                rcv(sat_indx).phase = rcv_(sat_indx,para_indx);
            elseif (para_indx==6)
                rcv(sat_indx).slp_dtct = rcv_(sat_indx,para_indx);
            elseif (para_indx==7)
                rcv(sat_indx).snr_dbhz = rcv_(sat_indx,para_indx);
            end
        end
    end
end