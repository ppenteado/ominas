;=============================================================================
;+
; NAME:
;	map_graphic_to_centric
;
;
; PURPOSE:
;	Converts latitudes from the planetographic to the planetocentric
;	convention.
;
;
; CATEGORY:
;	NV/LIB/MAP
;
;
; CALLING SEQUENCE:
;	map_pts_c = map_graphic_to_centric(md, map_pts_g)
;
;
; ARGUMENTS:
;  INPUT: 
;	md:	Array (nt) of map descriptors.
;
;	map_pts_g:	Array (2,nv,nt) of map points in which the 
;			latitudes are planetographic.
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
;	Array (2,nv,nt) of map points in which the latitudes are 
;	planetocentric.
;
;
; STATUS:
;	Complete
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale, 1/1998
; 	Adapted by:	Spitale, 5/2016
;	
;-
;=============================================================================
function map_graphic_to_centric, md, map_pts0
@core.include
 _md = cor_dereference(md)

 ecc = (map_radii_to_ecc(_md.radii))[0]

 map_pts = map_pts0
 map_pts[0,*] = graphic_to_centric_lat(sqrt(1d - ecc^2), 1d, map_pts[0,*])

 return, map_pts
end
;===========================================================================
