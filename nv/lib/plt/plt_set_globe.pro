;=============================================================================
;+
; NAME:
;	plt_set_globe
;
;
; PURPOSE:
;	Replaces the globe descriptor in each given planet descriptor.
;
;
; CATEGORY:
;	NV/LIB/PLT
;
;
; CALLING SEQUENCE:
;	plt_set_globe, px, gbd
;
;
; ARGUMENTS:
;  INPUT: 
;	px:	 Array (nt) of any subclass of PLANET.
;
;	gbd:	 Array (nt) of new globe descriptors.
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
;=============================================================================
pro plt_set_globe, pxp, gbdp, noevent=noevent
@nv_lib.include
 pdp = class_extract(pxp, 'PLANET')
 pd = nv_dereference(pdp)

 pd.gbd=gbdp

 nv_rereference, pdp, pd
 nv_notify, pdp, type = 0, noevent=noevent
end
;===========================================================================



