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
;	
;-
;=============================================================================
pro cam_set_filters, cxp, filter, i, noevent=noevent
@nv_lib.include
 cdp = class_extract(cxp, 'CAMERA')
 cd = nv_dereference(cdp)

 if(NOT defined(i)) then cd.filters = filter $
 else cd.filters[i] = filter

 nv_rereference, cdp, cd
 nv_notify, cdp, type = 0, noevent=noevent
end
;===========================================================================


