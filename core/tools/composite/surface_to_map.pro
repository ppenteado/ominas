;=============================================================================
;+
; NAME:
;       surface_to_map
;
;
; PURPOSE:
;       Transforms points in any surface coordinate system to map
;	coordinates.
;
;
; CATEGORY:
;       NV/LIB/TOOLS/COMPOSITE
;
;
; CALLING SEQUENCE:
;       result = surface_to_map(md, bx, surface_pts)
;
;
; ARGUMENTS:
;  INPUT:
;	md:      Array of nt map descriptors.
;
;	bx:      Array of nt object descriptors (subclass of BODY.
;
;	surface_pts:       Array (nv x 3 x nt) of surface points
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
;       Array (2 x nv x nt) of map coordinates.
;
; STATUS:
;       Completed.
;
;
; MODIFICATION HISTORY:
;       Written by:     Spitale
;-
;=============================================================================
function surface_to_map, md, bx, surface_pts

 if(NOT keyword_set(surface_pts)) then return, 0

 if(keyword_set(md)) then class = (cor_class(md))[0]


 if(class EQ 'CAMERA') then $
               if(NOT keyword_set(bx)) then $
                 return, surface_to_image(md, 0, surface_pts)

 nt = n_elements(md)
 sv = size(surface_pts)
 nv = sv[1]

 result = dblarr(2,nv,nt, /nozero)
 result[0,*,*] = surface_pts[*,0,*]
 result[1,*,*] = surface_pts[*,1,*]


  if(class EQ 'MAP') then $
   if(map_graphic(md[0])) then $
            result[0,*,*] = map_centric_to_graphic(md, surface_pts[*,0,*])
 
 return, result
end
;===========================================================================
