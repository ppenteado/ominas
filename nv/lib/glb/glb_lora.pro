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
;	lora = glb_lora(gbx)
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
;	
;-
;===========================================================================
function glb_lora, gbxp, noevent=noevent
@nv_lib.include
 gbdp = class_extract(gbxp, 'GLOBE')
 nv_notify, gbdp, type = 1, noevent=noevent
 gbd = nv_dereference(gbdp)
 return, gbd.lora
end
;===========================================================================
