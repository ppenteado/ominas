;=============================================================================
;+
; NAME:
;	glb_get_ranges
;
;
; PURPOSE:
;	Returns ranges of valid coordinates for the given GLOBE object.
;
;
; CATEGORY:
;	NV/LIB/GLB
;
;
; CALLING SEQUENCE:
;	ranges = glb_get_ranges(gbd)
;
;
; ARGUMENTS:
;  INPUT:
;	bx:	 Any subclass of GLOBE.
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
;	Array (2 x 3) giving the ranges in globe coordinates.
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale
; 	Adapted by:	Spitale, 5/2016
;	
;-
;=============================================================================
function glb_get_ranges, gbd
 return, [transpose([-!dpi/2d, 0d,      0d]), $
          transpose([!dpi/2d,  2d*!dpi, 1d10000])]
end
;===========================================================================
