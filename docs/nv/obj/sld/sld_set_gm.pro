;===========================================================================
;+
; NAME:
;	sld_set_gm
;
;
; PURPOSE:
;       Replaces the GM value for each given solid descriptor.
;
;
; CATEGORY:
;	NV/LIB/SLD
;
;
; CALLING SEQUENCE:
;	sld_set_gm, sld, gm
;
;
; ARGUMENTS:
;  INPUT: 
;	sld:	 Array (nt) of any subclass of SOLID descriptors.
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
; 	Written by:	Spitale, 7/2015
; 	Adapted by:	Spitale, 5/2016
;	
;-
;===========================================================================
pro sld_set_gm, sld, gm, nosynch=nosynch, noevent=noevent
@core.include

 _sld = cor_dereference(sld)

 if(NOT keyword__set(nosynch)) then _sld.mass = _sld.mass * gm/_sld.gm
 _sld.gm = gm

 cor_rereference, sld, _sld
 nv_notify, sld, type = 0, noevent=noevent
end
;===========================================================================
