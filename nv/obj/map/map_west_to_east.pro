;=============================================================================
;+
; NAME:
;	map_west_to_east
;
;
; PURPOSE:
;	Converts longitudes from the westward to the eastward
;	convention.
;
;
; CATEGORY:
;	NV/LIB/MAP
;
;
; CALLING SEQUENCE:
;	map_pts_c = map_west_to_east(md, map_pts_g)
;
;
; ARGUMENTS:
;  INPUT: 
;	md:	Array (nt) of map descriptors.
;
;	map_pts_g:	Array (2,nv,nt) of map points in which the 
;			longitudes are westward.
;
;  OUTPUT: NONE
;
;
; KEYWORDS:
;  INPUT: NONE
;
;  OUTPUT: NONE
;
;
; RETURN: 
;	Array (2,nv,nt) of map points in which the longitudes are 
;	eastward.
;
;
; STATUS:
;	Complete
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale, 8/201y
;	
;-
;=============================================================================
function map_west_to_east, md, map_pts0
@core.include
 _md = cor_dereference(md)

 map_pts = map_pts0
 map_pts[1,*] = west_to_east_longitude(map_pts[1,*], max=!dpi)

 return, map_pts
end
;===========================================================================
