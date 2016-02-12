;===========================================================================
;+
; NAME:
;	glb_type
;
;
; PURPOSE:
;       Returns the type string for each given globe descriptor.
;
;
; CATEGORY:
;	NV/LIB/GLB
;
;
; CALLING SEQUENCE:
;	type = glb_type(gbx)
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
;       Array (nt) of type strings associated with each given globe 
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
function glb_type, gbxp
 gbdp = class_extract(gbxp, 'GLOBE')
 nv_notify, gbdp, type = 1
 gbd = nv_dereference(gbdp)
 return, gbd.type
end
;===========================================================================
