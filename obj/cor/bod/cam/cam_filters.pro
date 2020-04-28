;=============================================================================
;+
; NAME:
;	cam_filters
;
;
; PURPOSE:
;	Returns the filter name(s) for a given camera descriptor.
;
;
; CATEGORY:
;	NV/LIB/CAM
;
;
; CALLING SEQUENCE:
;	filters = cam_filers(cd, index)
;
;
; ARGUMENTS:
;  INPUT:
;	cd:	 Camera descriptor.
;
;	index:	 Index of filter to return.  If not given, all are returned.
;
;  OUTPUT: NONE
;
;
; KEYWORDS:
;  INPUT:  NONE
;
;  OUTPUT: NONE
;
;
; RETURN:
;	Names of requested filters.
;
;
; STATUS:
;	Complete
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale
; 	Adapted by:	Spitale, 5/2016
;	
;-
;=============================================================================
function cam_filters, cd, i, noevent=noevent
@core.include
 nv_notify, cd, type = 1, noevent=noevent
 _cd = cor_dereference(cd)

 if(NOT defined(i)) then i = where(_cd.filters NE '')
 if(i[0] EQ -1) then return, ''
 return, _cd.filters[i]
end
;===========================================================================



