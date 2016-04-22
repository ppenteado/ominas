;=============================================================================
;+
; NAME:
;       map_to_surface
;
;
; PURPOSE:
;       Transforms points in map coordinates to surface coordinates.
;
;
; CATEGORY:
;       NV/LIB/TOOLS/COMPOSITE
;
;
; CALLING SEQUENCE:
;       result = map_to_surface(md, bx, map_pts)
;
;
; ARGUMENTS:
;  INPUT:
;	md:	Array of nt map descriptors.
;
;	bx:	Array of nt object descriptors (subclass of BODY.
;
;	map_pts:	Array (2 x nv x nt) of map points
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
;       Array (nv x 3 x nt) of surface coordinates, with the altitude coordinate 
;	set to zero.
;
; STATUS:
;       Completed.
;
;
; MODIFICATION HISTORY:
;       Written by:     Spitale
;-
;=============================================================================
function map_to_surface, md, bx, map_pts

  if(class_get(md[0]) EQ 'CAMERA') then $
              if(NOT keyword_set(bx)) then $
                 return, image_to_surface(md, 0, map_pts, frame_bd=frame_bd)


 if(keyword_set(md)) then nt = n_elements(md) $
 else nt = n_elements(bx)
 sv = size(map_pts)
 nv = 1
 if(sv[0] GT 1) then nv = sv[2]


 result = dblarr(nv,3,nt, /nozero)
 result[*,0,*] = map_pts[0,*,*]
 result[*,1,*] = map_pts[1,*,*]
 result[*,2,*] = 0

 if(class_get(bx[0]) EQ 'GLOBE') then $
  if(class_get(md[0]) EQ 'MAP') then $
   if(map_graphic(md)) then $
          result[*,0,*] = map_graphic_to_centric(md, map_pts[0,*,*])

 return, result
end
;===========================================================================
