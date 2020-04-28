;===========================================================================
;+
; NAME:
;	sld_set_extn_parm
;
;
; PURPOSE:
;       Replaces the extinction function parameters for each given solid 
;	descriptor.
;
;
; CATEGORY:
;	NV/LIB/SLD
;
;
; CALLING SEQUENCE:
;	sld_set_extn_parm, sld, extn_parm
;
;
; ARGUMENTS:
;  INPUT: 
;	sld:		Array (nt) of any subclass of SOLID descriptors.
;
;	extn_parm:	Array (nt) of new extinction function parameters.
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
; 	Written by:	Spitale, 9/2017
;	
;-
;===========================================================================
pro sld_set_extn_parm, sld, extn_parm, noevent=noevent
@core.include

 _sld = cor_dereference(sld)

 _sld.extn_parm=extn_parm

 cor_rereference, sld, _sld
 nv_notify, sld, type = 0, noevent=noevent
end
;===========================================================================
