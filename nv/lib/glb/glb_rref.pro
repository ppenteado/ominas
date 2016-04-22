;===========================================================================
;+
; NAME:
;	glb_rref
;
;
; PURPOSE:
;       Returns the reference radius for each given globe descriptor.
;
;
; CATEGORY:
;	NV/LIB/GLB
;
;
; CALLING SEQUENCE:
;	mass = glb_rref(gbx)
;
;
; ARGUMENTS:
;  INPUT:
;	gbx:	 Array (nt) of any subclass of GLOBE descriptors.
;
;  OUTPUT: NONE
;
;
; KEYWORDS:
;  INPUT:  NONE
;
;  OUTPUT: NONE
;
;
; RETURN:
;       Array (nt) of reference radii associated with each given globe 
;	descriptor.
;
;
; STATUS:
;	Complete
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale, 1/1998
;	
;-
;===========================================================================
function glb_rref, gbxp, noevent=noevent
 gbdp = class_extract(gbxp, 'GLOBE')
 nv_notify, gbdp, type = 1, noevent=noevent
 gbd = nv_dereference(gbdp)

 return, gbd.rref
end
;===========================================================================
