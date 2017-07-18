;=============================================================================
;+
; NAME:
;	map_get_ranges
;
;
; PURPOSE:
;	Returns ranges of valid coordinates for the given MAP object.
;
;
; CATEGORY:
;	NV/LIB/MAP
;
;
; CALLING SEQUENCE:
;	ranges = map_get_ranges(md)
;
;
; ARGUMENTS:
;  INPUT:
;	md:	 MAP descriptor.
;
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
;	Array (2 x 2) giving the ranges in latitude, longitude.
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale
; 	Adapted by:	Spitale, 5/2016
;	
;-
;=============================================================================
function map_get_ranges, md

; neither of these is generally correct.  Need to clear this up.

 return, transpose([transpose([-!dpi/2d, -!dpi]), $
                    transpose([ !dpi/2d,  !dpi])])
; return, transpose([transpose([-!dpi/2d, 0d]), $
;                    transpose([ !dpi/2d, 2d*!dpi])])
end
;===========================================================================
