;=============================================================================
;+
; NAME:
;	map_set_fn_data_p
;
;
; PURPOSE:
;	Replaces the function data pointer for each given map descriptor.
;
;
; CATEGORY:
;	NV/LIB/MAP
;
;
; CALLING SEQUENCE:
;	map_set_fn_data_p, md, fn_data_p
;
;
; ARGUMENTS:
;  INPUT: 
;	md:	 Array (nt) of map descriptors.
;
;	fn_data_p:	 Array (nt) of new function data pointers.
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
; 	Adapted by:	Spitale, 5/2016
;	
;-
;=============================================================================
pro map_set_fn_data_p, md, p, noevent=noevent
@core.include
 _md = cor_dereference(md)

 _md.fn_data_p=p

 cor_rereference, md, _md
 nv_notify, md, type = 0, noevent=noevent
end
;===========================================================================
