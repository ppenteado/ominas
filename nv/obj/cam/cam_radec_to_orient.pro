;=============================================================================
;+
; NAME:
;       cam_radec_to_orient
;
;
; PURPOSE:
;	Computes orientation matrices such that the optic axis (axis 1) 
;	points in the direction of the given radec and the image y direction 
;	(axis 2) points toward celestial north (inertial [0,0,1]).
;
;
; CATEGORY:
;       NV/LIB/CAM
;
;
; CALLING SEQUENCE:
;       M = cam_radec_to_orient(radec)
;
;
; ARGUMENTS:
;  INPUT:
;	radec:	Array (nv,3) or (1,2,nt)  giving the radec representations of the 
;		pointing vectors (i.e., orient[1,*,*]).
;
;  OUTPUT:  NONE
;
;
; KEYOWRDS:
;  INPUT: 
;	y:	If set, axis 2 is set to point in this direction instead of 
;		celestial north.
;
;  OUTPUT: NONE
;
;
; RETURN:
;       Array (3,3,nt) of orientation matrices.
;
;
;
; MODIFICATION HISTORY:
;       Written by:     Spitale
;
;-
;=============================================================================
function cam_radec_to_orient, _radec, y=y

 zz = [[0],[0],[1d]]
 if(keyword_set(y)) then zz = y

 radec = _radec
 dim = size(radec, /dim)
 if(n_elements(dim) EQ 3) then radec = transpose(radec)

 nv = n_elements(radec)/3

 v1 = v_unit(bod_radec_to_body(bod_inertial(), radec))
 zz = zz##make_array(nv,val=1d)
 
 v0 = v_unit(v_cross(v1, zz))
 v2 = v_unit(v_cross(v0, v1))

 orient = dblarr(3,3,nv)
 orient[0,*,*] = -v0
 orient[1,*,*] = v1
 orient[2,*,*] = v2

 return, orient
end
;===========================================================================



