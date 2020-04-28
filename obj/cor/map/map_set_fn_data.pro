;=============================================================================
;+
; NAME:
;	map_set_fn_data
;
;
; PURPOSE:
;	Replaces the function data for a map descriptor.
;
;
; CATEGORY:
;	NV/LIB/MAP
;
;
; CALLING SEQUENCE:
;	map_set_fn_data, md, data
;
;
; ARGUMENTS:
;  INPUT: 
;	md:	 Map descriptor.
;
;	data:	 New function data.
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
; 	Adapted by:	Spitale, 7/2016; adapted from map_set_fn_data_p
;	
;-
;=============================================================================
pro map_set_fn_data, md, data, noevent=noevent
@core.include
 cor_set_udata, md, 'MAP_FN_DATA', data, noevent=noevent
end
;===========================================================================
