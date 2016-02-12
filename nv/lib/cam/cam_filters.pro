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
;	
;-
;=============================================================================
function cam_filters, cxp, i
@nv_lib.include
 cdp = class_extract(cxp, 'CAMERA')
 nv_notify, cdp, type = 1
 cd = nv_dereference(cdp)

 if(NOT defined(i)) then i = where(cd.filters NE '')
 if(i[0] EQ -1) then return, ''
 return, cd.filters[i]
end
;===========================================================================



