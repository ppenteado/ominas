;===========================================================================
;+
; NAME:
;	glb_set_gm
;
;
; PURPOSE:
;       Replaces the GM value for each given globe descriptor.
;
;
; CATEGORY:
;	NV/LIB/GLB
;
;
; CALLING SEQUENCE:
;	glb_set_gm, gbx, gm
;
;
; ARGUMENTS:
;  INPUT: 
;	gbx:	 Array (nt) of any subclass of GLOBE descriptors.
;
;	gm:	 Array (nt) of new GM values.
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
pro glb_set_gm, gbxp, gm, nosynch=nosynch
@nv_lib.include
nv_message, /stop, name='glb_set_gm', 'Obsolete routine.  Use sld_set_gm instead.'
 gbdp = class_extract(gbxp, 'GLOBE')
 gbd = nv_dereference(gbdp)

 if(NOT keyword__set(nosynch)) then gbd.mass = gbd.mass * gm/gbd.gm
 gbd.gm = gm

 nv_rereference, gbdp, gbd
 nv_notify, gbdp, type = 0
end
;===========================================================================
