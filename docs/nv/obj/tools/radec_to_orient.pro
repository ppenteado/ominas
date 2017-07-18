;=============================================================================
;+
; NAME:
;       radec_to_orient
;
;
; PURPOSE:
;	Computes orientation matrices such that the optic axis (axis 1) 
;	points in the direction of the given radec and the image y direction 
;	(axis 2) points toward celestial north (inertial [0,0,1]).
;
;
; CATEGORY:
;       NV/LIB/TOOLS
;
;
; CALLING SEQUENCE:
;       M = radec_to_orient(radec)
;
;
; ARGUMENTS:
;  INPUT:
;	radec:	Array (nt) giving the radec representations of the 
;		pointing vectors.
;
;  OUTPUT:  NONE
;
;
; KEYOWRDS:
;  INPUT: NONE
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
function radec_to_orient, radec

 nv = n_elements(radec)/3

 v1 = v_unit(bod_radec_to_body(bod_inertial(), radec))
 zz = [[0],[0],[1d]]##make_array(nv,val=1d)
 
 v0 = v_unit(v_cross(v1, zz))
 v2 = v_unit(v_cross(v0, v1))

 orient = dblarr(3,3,nv)
 orient[0,*,*] = tr(v0)
 orient[1,*,*] = tr(v1)
 orient[2,*,*] = tr(v2)

 return, orient
end
;===========================================================================
