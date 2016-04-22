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
;	sld_set_gm, slx, gm
;
;
; ARGUMENTS:
;  INPUT: 
;	slx:	 Array (nt) of any subclass of SOLID descriptors.
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
;	
;-
;===========================================================================
pro sld_set_gm, slxp, gm, nosynch=nosynch, noevent=noevent
@nv_lib.include
 sldp = class_extract(slxp, 'SOLID')
 sld = nv_dereference(sldp)

 if(NOT keyword__set(nosynch)) then sld.mass = sld.mass * gm/sld.gm
 sld.gm = gm

 nv_rereference, sldp, sld
 nv_notify, sldp, type = 0, noevent=noevent
end
;===========================================================================
