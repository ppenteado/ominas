;=============================================================================
;+
; NAME:
;	cam_set_filters
;
;
; PURPOSE:
;	Sets the filter name(s) for a given camera descriptor.
;
;
; CATEGORY:
;	NV/LIB/CAM
;
;
; CALLING SEQUENCE:
;	cam_set_filters, cd, filters, i
;
;
; ARGUMENTS:
;  INPUT:
;	cd:	 Camera descriptor.
;
;	filters:	Name(s) of filters.
;
;	index:	 Index of filter to set.  If not given, all are set.
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
; RETURN: NONE
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
pro cam_set_filters, cd, filter, i, noevent=noevent
@core.include

 _cd = cor_dereference(cd)

 if(NOT defined(i)) then _cd.filters = filter $
 else _cd.filters[i] = filter

 cor_rereference, cd, _cd
 nv_notify, cd, type = 0, noevent=noevent
end
;===========================================================================


