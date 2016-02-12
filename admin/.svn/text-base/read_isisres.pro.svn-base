;========================================================================
; read_isisres
;
; Reads what appear to be voyager reseau files found on pirl in 
; /opt/usgs/isisdata/voydata/.
;
; rp = read_isisres('../debug/voyager_1.res')
; plots, rp, psym=1
;
;========================================================================
function read_isisres, fname

 xx = dblarr(16,51)

 ;---------------------
 ; open reseau file
 ;---------------------
 openr, unit, fname, /get_lun


 ;---------------------
 ; read file
 ;---------------------
 line = dblarr(16)

 for i=0, 49 do $
  begin
   readf, unit, line
   xx[*,i] = line
  end

 line = dblarr(12)
 readf, unit, line
 xx[0:11,i] = line

 ;---------------------
 ; close file
 ;---------------------
 close, unit
 free_lun, unit


 ;-----------------------------------------------------------------------------
 ; rearrange into image points array assuming alternating line/sample coords.
 ;-----------------------------------------------------------------------------
 p = dblarr(2,406)
 p[1,*] = xx[lindgen(406)*2] - 1
 p[0,*] = xx[lindgen(406)*2+1] - 1

 p = p[*,0:403]

 ;-----------------------------------------------------------------------------
 ; Adjacent points in the file are nearly identical, perhaps that's narrow
 ; and wide-angle reseaus, I don't know.  Anyway, just average them.
 ;-----------------------------------------------------------------------------
 p = 0.5d*(p[*,lindgen(202)*2] + p[*,lindgen(202)*2+1])

 ;-------------------------------------------------------------------------
 ; Coords in the file are in 'object space'; convert to 'image space' by
 ; shrinking coords about pixel (499,499) by 15%.  Then translate so that 
 ; (499,499) becaomes (399,399).
 ;-------------------------------------------------------------------------
; p[0,*] = 499. + (p[0,*] - 499.)*0.85 - 100.
; p[1,*] = 499. + (p[1,*] - 499.)*0.85 - 100.

 ;-------------------------------------------------------------------------
 ; Coords in the file are in 'object space'; convert to focal coords.
 ;-------------------------------------------------------------------------
 oaxis = [499.,499.]
 scale = 0.85 * 9.2454750d-06
 p[0,*] = (p[0,*] - oaxis[0])*scale 
 p[1,*] = (p[1,*] - oaxis[1])*scale 

 ps = {pg_points_struct}
 ps = pgs_set_points(ps, points = p)
 
 return, ps
end
;========================================================================
