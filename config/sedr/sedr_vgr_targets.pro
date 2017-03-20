;===========================================================================
;+
; NAME:
;	sedr_vgr_targets
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
;       Written by:     Haemmerle, 1/1999
;
;-
;===========================================================================
function sedr_vgr_targets, sedr, bconst, j2000=j2000, $
         n_obj=n_obj, dim=dim, status=status

 status=0
 n_obj=1  ; SEDR returns only one object, the SEDR target body
 dim = [1]


 ;--------------------------
 ; plt_name
 ;--------------------------
 name = [strtrim(string(bconst.body_name),2)]
 plt_name = (reform(name, 1, n_obj, /overwrite))[0]

 ;--------------------------
 ; plt_orient
 ;--------------------------
 me = sedr_buildcm(sedr.alpha_0, sedr.delta_0, sedr.omega)

 ;----------------------------------------------------------------------
 ; Compute one-way light time correction for longitude system:  Assume
 ; that a constant correction is adequate for all points within the
 ; field-of-view.  We use the distance from the spacecraft to the sub-
 ; spacecraft point to compute the correction.  NOTE: This correction is
 ; only applied to the original SEDR ME-matrix.  Updated ME-matrices are
 ; assumed to be already corrected.  Also, the correction is only applied
 ; to the planets, since other objects do not have a significant spin
 ; rate.  This is how the VICAR routine SEDR79V2 works.
 ; Note: Constant 71952000d = 2.98e5(km/sec) * 86400(sec/day) / 360(degrees)
 ;----------------------------------------------------------------------
 if(string(sedr.spare_1[0:4]) EQ 'SEDR' AND $
    (sedr.target GT 0 AND sedr.target LT 10)) then $
  begin
    pos3 = transpose(me)##transpose(double(sedr.pb_position))
    mag = sqrt(pos3[0]^2 + pos3[1]^2 + pos3[2]^2)
    ai2 = (1d/bconst.a)^2
    ci2 = (1d/bconst.c)^2
    slat = pos3[2]/mag
    clat = sqrt(1d - slat^2)
    r = 1d/sqrt(ai2*CLAT^2 + ci2*SLAT^2)
    dist = mag - r
    delta_lon = dist / (71952000d * bconst.rotation_rate)
    me = sedr_buildcm(sedr.alpha_0, sedr.delta_0, sedr.omega-delta_lon)
  end

 if(NOT keyword__set(j2000)) then me = b1950_to_j2000(me, /reverse)
 plt_orient = reform(me, 3, 3, n_obj, /overwrite)

 ;--------------------------
 ; plt_pos
 ;--------------------------
 pos = 1000d*transpose(double(sedr.sc_position + sedr.pb_position))
 if(NOT keyword__set(j2000)) then pos = b1950_to_j2000(pos, /reverse)
 plt_pos = reform(pos, 1, 3, n_obj, /overwrite)

 ;--------------------------
 ; plt_vel
 ;--------------------------
 vel = transpose([0d,0d,0d])  ; (orbital motion for sats) Not implemented
 if(NOT keyword__set(j2000)) then vel = b1950_to_j2000(vel, /reverse)
 plt_vel = reform(vel, 1, 3, n_obj, /overwrite)

 ;--------------------------
 ; plt_avel
 ;--------------------------
 me = sedr_buildcm(sedr.alpha_0, sedr.delta_0, sedr.omega)
 avel = me[2,*]*bconst.rotation_rate*2d*!DPI/86400d 
 if(NOT keyword__set(j2000)) then avel = b1950_to_j2000(avel, /reverse)
 plt_avel = reform(avel, 1, 3, n_obj, /overwrite)

 ;-------------------------------
 ; plt_time -- Seconds past 1950
 ;-------------------------------
 time = [sedr_time(sedr)]
 plt_time = reform(time, 1, n_obj, /overwrite)

 ;--------------------------
 ; plt_lora
 ;--------------------------
 lora = [-double(bconst.lora)*!DPI/180d]   ;SEDR in deg and west-longitude
 for i=0,n_obj-1 do if(lora[i] LT 0d) then lora[i] = lora[i] + 2d*!DPI
 plt_lora = reform(lora, 1, n_obj, /overwrite)

 ;--------------------------
 ; plt_lref
 ;--------------------------
 case strupcase(plt_name) of
  'JUPITER' : 	plt_lref = 'II'			;???
  'SATURN' : 	plt_lref = 'II'			;???
  'URANUS' : 	plt_lref = 'III'		;???
  'NEPTUNE' : 	plt_lref = 'III'		;???
  else: 	plt_lref = ''
 endcase

 ;--------------------------
 ; plt_radii
 ;--------------------------
 radii = 1000d*[bconst.a, bconst.b, bconst.c]
 plt_radii = reform(radii, 3, n_obj, /overwrite)

 ;-------------------------------
 ; additional body constants
 ;-------------------------------
 plt_mass = pc_get(plt_name, 'MASS')
 plt_j = pc_get(plt_name, 'J')


 pd = plt_create_descriptors(n_obj, $
		gd=make_array(n_obj, val=dd), $
		name=plt_name, $
		orient=plt_orient, $
		avel=plt_avel, $
		pos=plt_pos, $
		vel=plt_vel, $
		time=plt_time, $
		radii=plt_radii, $
		lref=plt_lref, $
		mass=plt_mass, $
		j=plt_j, $
		lora=plt_lora)

 return, pd

end
;===========================================================================
