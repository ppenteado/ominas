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
;	sld_set_opacity, sld, opacity
;
;
; ARGUMENTS:
;  INPUT: 
;	sld:	 Any subclass of SOLID.
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
; 	Adapted by:	Spitale, 5/2016
;	
;-
;=============================================================================
pro sld_set_opacity, sld, opacity, noevent=noevent
@core.include

 _sld = cor_dereference(sld)

 _sld.opacity=opacity

 cor_rereference, sld, _sld
 nv_notify, sld, type = 0, noevent=noevent
end
;===========================================================================



