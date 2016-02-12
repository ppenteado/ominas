;===========================================================================
;+
; NAME:
;	glb_set_solid
;
;
; PURPOSE:
;	Replaces the solid descriptor in each given globe descriptor.
;
;
; CATEGORY:
;	NV/LIB/GLB
;
;
; CALLING SEQUENCE:
;	glb_set_solid, gbx, bd
;
;
; ARGUMENTS:
;  INPUT: 
;	gbx:	 Array (nt) of any subclass of GLOBE descriptors.
;
;	sld:	 Array (nt) of SOLID descriptors.
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
; RETURN: NONE
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
pro glb_set_solid, gbxp, slds
 gbdp = class_extract(gbxp, 'GLOBE')
 gbd = nv_dereference(gbdp)

 gbd.sld=slds

 nv_rereference, gbdp, gbd
 nv_notify, gbdp, type = 0
end
;===========================================================================



