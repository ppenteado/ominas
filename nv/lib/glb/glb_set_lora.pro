;===========================================================================
;+
; NAME:
;	glb_set_lora
;
;
; PURPOSE:
;       Replaces the longitude of the first ellipsoid radius for each
;       given globe descriptor.
;
;
; CATEGORY:
;	NV/LIB/GLB
;
;
; CALLING SEQUENCE:
;	glb_set_lora, gbx, lora
;
;
; ARGUMENTS:
;  INPUT: 
;	gbx:	 Array (nt) of any subclass of GLOBE descriptors.
;
;	lora:	 Array (nt) of new longitude values of the first ellipsoid radius.
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
; 	Written by:	Spitale, 1/1998
;	
;-
;===========================================================================
pro glb_set_lora, gbxp, lora, noevent=noevent
 gbdp = class_extract(gbxp, 'GLOBE')
 gbd = nv_dereference(gbdp)

 gbd.lora=lora

 nv_rereference, gbdp, gbd
 nv_notify, gbdp, type = 0, noevent=noevent
end
;===========================================================================
