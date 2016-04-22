;=============================================================================
;+
; NAME:
;	sld_set_opacity
;
;
; PURPOSE:
;	Replaces the opacity of each given solid descriptor.
;
;
; CATEGORY:
;	NV/LIB/SLD
;
;
; CALLING SEQUENCE:
;	sld_set_opacity, slx, opacity
;
;
; ARGUMENTS:
;  INPUT: 
;	slx:	 Any subclass of SOLID.
;
;	opacity:	 New opacity value.
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
;=============================================================================
pro sld_set_opacity, slxp, opacity, noevent=noevent
@nv_lib.include
 sldp = class_extract(slxp, 'SOLID')
 sld = nv_dereference(sldp)

 sld.opacity=opacity

 nv_rereference, sldp, sld
 nv_notify, sldp, type = 0, noevent=noevent
end
;===========================================================================



