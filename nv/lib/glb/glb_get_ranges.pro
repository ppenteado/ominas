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
;	ranges = glb_get_ranges(gbx)
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
;	
;-
;=============================================================================
function glb_get_ranges, gbx
 return, [transpose([-!dpi/2d, 0d,      0d]), $
          transpose([!dpi/2d,  2d*!dpi, 1d10000])]
end
;===========================================================================
