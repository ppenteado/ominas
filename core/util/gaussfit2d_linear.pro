;==============================================================================
; gaussfit2d_linear
;
;  Fits the function y(x) = A0 exp(-(x-A1)^2/A2^2 -(y-A3)^2/A4^2) using a 
;  linear least-square fit in log space.
;
;  returns [A0, A1, A2, A3, A4]
;
; All data points must be positive.
;
; *** This routine is not weighted correctly.
;
;==============================================================================
function gaussfit2d_linear, _data, status=status

 data = alog(_data)
 xx = sfit(data, 2, kx=kx)

 status = intarr(5)
 cc = dblarr(5)

 if(kx[0,2] NE 0) then cc[1] = -0.5*kx[0,1]/kx[0,2] $
 else status[1] = -1
 if(kx[0,2] LT 0) then cc[2] = sqrt(-1d/kx[0,2]) $
 else status[2] = -1
 if(kx[2,0] NE 0) then cc[3] = -0.5*kx[1,0]/kx[2,0] $
 else status[3] = -1
 if(kx[2,0] LT 0) then cc[4] = sqrt(-1d/kx[2,0]) $
 else status[4] = -1
 if((cc[2] NE 0) AND (cc[4] NE 0) AND $
               (status[2] EQ 0) AND (status[4] EQ 0)) then $
                   cc[0] = exp(kx[0,0] + (cc[1]/cc[2])^2 + (cc[3]/cc[4])^2) $
 else status[0] = -1


 return, cc
end
;==============================================================================
