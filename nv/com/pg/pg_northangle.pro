;=============================================================================
;+
; NAME:
;	pg_northangle
;
;
; PURPOSE:
;	Computes the angle between the image-coordinate y-axis and the 
;	projected z-axis of the given body.  Increasing angle corresponds to 
;	clockwise rotation in the image. 
;
;
; CATEGORY:
;	NV/PG
;
;
; CALLING SEQUENCE:
;	northangle = pg_northangle(cd=cd, bx=bx)
;	northangle = pg_northangle(gd=gd)
;
;
; ARGUMENTS:
;  INPUT: NONE
;
;  OUTPUT: NONE
;
;
; KEYWORDS:
;  INPUT:
;	cd:	Array (n_timesteps) of camera descriptors.
;
;	bx:	Array (n_objects, n_timesteps) of descriptors of objects 
;		which must be a subclass of BODY.
;
;	gd:	Generic descriptor.  If given, the descriptor inputs 
;		are taken from this structure if not explicitly given.
;
;	dd:	Data descriptor containing a generic descriptor to use
;		if gd not given.
;
;  OUTPUT: NONE
;
;
; RETURN:
;	Array (n_objects) of double giving the northangles in radians.
;
;
; STATUS:
;	Complete
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale, 11/2001
;	
;-
;=============================================================================
function pg_northangle, cd=cd, bx=bx, dd=dd, gd=gd

 ;-----------------------------------------------
 ; dereference the generic descriptor if given
 ;-----------------------------------------------
 if(NOT keyword_set(cd)) then cd = dat_gd(gd, dd=dd, /cd)
 if(NOT keyword_set(bx)) then bx = dat_gd(gd, dd=dd, /bx)

 ;-----------------------------------
 ; validate descriptors
 ;-----------------------------------
 nt = n_elements(cd)
 cor_count_descriptors, bx, nd=n_objects, nt=nt1
 if(nt NE nt1) then nv_message, 'Inconsistent timesteps.'


 ;-----------------------------------
 ; compute northangles
 ;-----------------------------------
 orient = bod_orient(bx)
 bod_z = orient[2,*,*]

 bod_z_camera = bod_inertial_to_body(cd, bod_z)
 
 northangles = atan(bod_z_camera[*,0,*], bod_z_camera[*,2,*])
; northangles = atan(bod_z_camera[*,2,*], bod_z_camera[*,0,*])



 return, northangles
end
;=============================================================================
