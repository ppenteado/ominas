;=============================================================================
;+
; NAME:
;	sld_opacity
;
;
; PURPOSE:
;	Returns the opacity for each given solid descriptor.
;
;
; CATEGORY:
;	NV/LIB/SLD
;
;
; CALLING SEQUENCE:
;	opacity = sld_opacity(slx)
;
;
; ARGUMENTS:
;  INPUT: NONE
;	slx:	 Any subclass of SOLID.
;
;  OUTPUT: NONE
;
;
; KEYWORDS:
;  INPUT: 
;
;  OUTPUT: NONE
;
;
; RETURN:
;	Opacity value associated with each given solid descriptor.
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
function sld_opacity, slxp, noevent=noevent
 sldp = class_extract(slxp, 'SOLID')
 nv_notify, sldp, type = 1, noevent=noevent
 sld = nv_dereference(sldp)
 return, sld.opacity
end
;===========================================================================



