;=============================================================================
;+
; NAME:
;	map_centric_to_graphic
;
;
; PURPOSE:
;	Converts latitudes from the planetocentric to the planetographic
;	convention.
;
;
; CATEGORY:
;	NV/LIB/MAP
;
;
; CALLING SEQUENCE:
;	map_pts_g = map_centric_to_graphic(md, map_pts_c)
;
;
; ARGUMENTS:
;  INPUT: 
;	md:	Array (nt) of map descriptors.
;
;	map_pts_c:	Array (2,nv,nt) of map points in which the 
;			latitudes are planetocentric.
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
;	planetographic.
;
;
; STATUS:
;	Complete
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale, 1/1998
;	
;-
;=============================================================================
function map_centric_to_graphic, mdp, map_pts0
@nv_lib.include
 md = nv_dereference(mdp)

 ecc = map_radii_to_ecc(md.radii)

 map_pts = map_pts0
 map_pts[0,*] = centric_to_graphic_lat(sqrt(1d - ecc^2), 1d, map_pts[0,*])

 return, map_pts
end
;===========================================================================
