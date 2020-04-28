;=============================================================================
;+
; NAME:
;       map_to_disk
;
;
; PURPOSE:
;       Transforms points in map coordinates to disk coordinates.
;
;
; CATEGORY:
;       NV/LIB/TOOLS/COMPOSITE
;
;
; CALLING SEQUENCE:
;       result = map_to_disk(md, dkx, map_pts)
;
;
; ARGUMENTS:
;  INPUT:
;	md:	Array of nt map descriptors.
;
;	dkx:	Array of nt disk descriptors.
;
;	map_pts:       Array (2 x nv x nt) of map points
;
;  OUTPUT:
;       NONE
;
; KEYWORDS:
;   INPUT: NONE
;
;   OUTPUT: NONE
;
;
; RETURN:
;       Array (nv x 3 x nt) of disk coordinates, with the altitude coordinate set to
;	zero.
;
; STATUS:
;       Completed.
;
;
; MODIFICATION HISTORY:
;       Written by:     Spitale
;-
;=============================================================================
function map_to_disk, md, dkd, map_pts
 return, map_to_surface(md, dkd, map_pts)
end
;===========================================================================
