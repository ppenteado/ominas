;===========================================================================
;+
; NAME:
;	sedr_vgr_sun
;
;
; PURPOSE:
;	To be called by Voyager SEDR input translator or similar procedure to
;	convert sedr values to an nv planet descriptor
;
; CATEGORY:
;	UTIL/SEDR
;
;
; RESTRICTIONS:
;	By default, Voyager values return B1950 co-ordinates
;
;
; MODIFICATION HISTORY:
;       Written by:     Spitale, 2/2002
;
;-
;===========================================================================
function sedr_vgr_sun, sedr, bconst, j2000=j2000, $
         n_obj=n_obj, dim=dim, status=status

 status=0
 n_obj=1  ; SEDR returns only one object, the SEDR target body
 dim = [1]


 ;--------------------------
 ; plt_name
 ;--------------------------
 str_name = 'SUN'


 ;--------------------------
 ; plt_pos
 ;--------------------------
 pos = 1000d*transpose(double(sedr.sc_position + sedr.sun_position))
 if(NOT keyword__set(j2000)) then pos = b1950_to_j2000(pos, /reverse)
 str_pos = reform(pos, 1, 3, n_obj, /overwrite)


 ;-------------------------------
 ; plt_time -- Seconds past 1950
 ;-------------------------------
 time = [sedr_time(sedr)]
 str_time = reform(time, 1, n_obj, /overwrite)

 sd = str_init_descriptors(n_obj, $
		name=str_name, $
		pos=str_pos, $
		time=strtime)

 return, sd

end
;===========================================================================
