;===========================================================================
;+
; NAME:
;	glb_solid
;
;
; PURPOSE:
;	Returns the solid descriptor for each given globe descriptor.
;
;
; CATEGORY:
;	NV/LIB/GLB
;
;
; CALLING SEQUENCE:
;	sld = glb_solid(gbx)
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
;  INPUT: NONE
;
;  OUTPUT: NONE
;
;
; RETURN:
;	Solid descriptor associated with each given globe descriptor.
;
;
; STATUS:
;	Complete
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale, 7/2015
;	
;-
;===========================================================================
function glb_solid, gbxp, noevent=noevent
@nv_lib.include
 gbdp = class_extract(gbxp, 'GLOBE')
 nv_notify, gbdp, type = 1, noevent=noevent
 gbd = nv_dereference(gbdp)
 return, gbd.sld
end
;===========================================================================



