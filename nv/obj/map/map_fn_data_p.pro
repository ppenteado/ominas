;=============================================================================
;+
; NAME:
;	map_fn_data_p
;
;
; PURPOSE:
;	Returns the function data pointer for each given map descriptor.
;
;
; CATEGORY:
;	NV/LIB/MAP
;
;
; CALLING SEQUENCE:
;	fn_data_p = map_fn_data_p(md)
;
;
; ARGUMENTS:
;  INPUT: NONE
;	md:	 Array (nt) of map descriptors.
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
;	Function data pointer associated with each given map descriptor.
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
function map_fn_data_p, md, noevent=noevent
@core.include
 nv_notify, md, type = 1, noevent=noevent
 _md = cor_dereference(md)
 return, _md.fn_data_p
end
;===========================================================================
