;===========================================================================
;+
; NAME:
;	glb_lref
;
;
; PURPOSE:
;       Returns the longitude system reference for each given globe
;       descriptor.
;
;
; CATEGORY:
;	NV/LIB/GLB
;
;
; CALLING SEQUENCE:
;	lref = glb_lref(gbx)
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
;       Longitude system reference associated with each given globe
;       descriptor.
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
function glb_lref, gbxp, noevent=noevent
 gbdp = class_extract(gbxp, 'GLOBE')
 nv_notify, gbdp, type = 1, noevent=noevent
 gbd = nv_dereference(gbdp)
 return, gbd.lref
end
;===========================================================================
