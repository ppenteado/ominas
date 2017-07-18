;===========================================================================
;+
; NAME:
;	glb_lora
;
;
; PURPOSE:
;	Returns the longitude of the first ellipsoid radius for each 
;	given globe descriptor.
;
;
; CATEGORY:
;	NV/LIB/GLB
;
;
; CALLING SEQUENCE:
;	lora = glb_lora(gbd)
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
;       Longitude of the first ellipsoid radius associated with each
;       given globe descriptor.
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
function glb_lora, gbd, noevent=noevent
@core.include
 
 nv_notify, gbd, type = 1, noevent=noevent
 _gbd = cor_dereference(gbd)
 return, _gbd.lora
end
;===========================================================================
