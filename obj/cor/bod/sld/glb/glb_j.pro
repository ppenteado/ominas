;===========================================================================
;+
; NAME:
;	glb_j
;
;
; PURPOSE:
;       Returns the zonal harmonics for each given globe descriptor.
;
;
; CATEGORY:
;	NV/LIB/GLB
;
;
; CALLING SEQUENCE:
;	mass = glb_j(gbd)
;
;
; ARGUMENTS:
;  INPUT:
;	gbd:	 Array (nt) of any subclass of GLOBE descriptors.
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
;       Array (nj,nt) of zonal harmonics associated with each given globe 
;	descriptor.
;
;
; STATUS:
;	Complete
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale, 1/1998
; 	Adapted by:	Spitale, 5/2016
;	
;-
;===========================================================================
function glb_j, gbd, noevent=noevent
@core.include
 
 nv_notify, gbd, type = 1, noevent=noevent
 _gbd = cor_dereference(gbd)

 return, _gbd.J
end
;===========================================================================
