;=============================================================================
;+
; NAME:
;	map_fn_data
;
;
; PURPOSE:
;	Returns the function data for a map descriptor.
;
;
; CATEGORY:
;	NV/LIB/MAP
;
;
; CALLING SEQUENCE:
;	data = map_fn_data(md)
;
;
; ARGUMENTS:
;  INPUT: NONE
;	md:	 Map descriptor.
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
;	Function data associated with the given map descriptor.
;
;
; STATUS:
;	Complete
;
;
; MODIFICATION HISTORY:
; 	Adapted by:	Spitale, 7/2016; adapted from map_fn_data_p
;	
;-
;=============================================================================
function map_fn_data, md, noevent=noevent
@core.include
 return, cor_udata(md, 'MAP_FN_DATA', noevent=noevent)
end
;===========================================================================
