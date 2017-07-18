;=============================================================================
;+
; NAME:
;       impact_param
;
;
; PURPOSE:
;	Computes the impact parameter of a vector originating at the 
;	given camera, relative to the given planet object.
;
;
; CATEGORY:
;       NV/LIB/TOOLS
;
;
; CALLING SEQUENCE:
;       B = impact_param(cd, pd)
;
;
; ARGUMENTS:
;  INPUT:
;	cd:	Camera descriptor.
;
;	pd:	Planet descriptor.
;
;  OUTPUT:  NONE
;
;
; KEYOWRDS:
;  INPUT: 
;	p:	Image point specifying te ray to project.  If not given, 
;		the camera optic axis is used.
;
;  OUTPUT: NONE
;
;
; RETURN:
;       Shifted image.
;
;
;
; MODIFICATION HISTORY:
;       Written by:     Spitale
;
;-
;=============================================================================
function impact_param, cd, pd, p=p

 if(NOT keyword_set(p)) then p = cam_oaxis(cd)

 npd = n_elements(pd)
 cam_pos = bod_pos(cd) ## make_array(npd, val=1d) 
 plt_pos = bod_pos(pd)
 if(npd GT 1) then plt_pos = tr(plt_pos)

 v = image_to_inertial(cd, p) ## make_array(npd, val=1d)
; v = (bod_orient(cd))[1,*] ## make_array(npd, val=1d)
 vv = plt_pos - cam_pos
 range = v_mag(vv)

 theta = v_angle(v, vv)

 return, range * sin(theta)
end
;===========================================================================



