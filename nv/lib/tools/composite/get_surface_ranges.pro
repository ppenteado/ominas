;=============================================================================
;+
; NAME:
;       get_surface_ranges
;
;
; PURPOSE:
;	Determines full ranges of valid surface coordinate system.
;
;
; CATEGORY:
;       NV/LIB/TOOLS/COMPOSITE
;
;
; CALLING SEQUENCE:
;       points = get_surface_ranges(cd, bx)
;
;
; ARGUMENTS:
;  INPUT:
;	cd:      Camera or map descriptor
;
;	bx:      Object descriptor (subclass of BODY)
;
;
;  OUTPUT: NONE
;
;
; KEYWORDS:
;   INPUT: NONE
;
;   OUTPUT: NONE
;
;
; RETURN: 
;	Array of 2 points representng the minimum and maximum values of the 
;	relevant coordinate system.
;
;
; STATUS:
;       Completed.
;
;
; MODIFICATION HISTORY:
;       Written by:     Spitale
;-
;=============================================================================
function get_surface_ranges, od, bx
           
 gbd = class_extract(bx, 'GLOBE')
 dkd = class_extract(bx, 'DISK')

 if(keyword_set(gbd)) then return, glb_get_ranges(gbd)
 if(keyword_set(dkd)) then return, dsk_get_ranges(dkd)
 if(keyword_set(bx)) then return, bod_get_radec_ranges(bx)

 map_ranges = map_get_ranges(od)
 if(keyword_set(map_ranges)) then $
         return, transpose([map_ranges, transpose([0d, 0d])])

 return, 0
end
;============================================================================
