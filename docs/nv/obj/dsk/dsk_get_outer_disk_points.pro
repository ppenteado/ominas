;=============================================================================
;+
; NAME:
;	dsk_get_outer_disk_points
;
;
; PURPOSE:
;	Computes points on the outer edge of a disk. 
;
;
; CATEGORY:
;	NV/LIB/DSK
;
;
; CALLING SEQUENCE:
;	disk_pts = dsk_get_outer_disk_points(dkd, np)
;
;
; ARGUMENTS:
;  INPUT:
;	dkd:	 Array (nt) of any subclass of DISK.
;
;	np:	 Number of points on the edge.
;
;  OUTPUT: NONE
;
;
; KEYWORDS:
;  INPUT:  
;	ta:	True anomalies for the points.  Default is the full circle.
;
;  OUTPUT: NONE
;
;
; RETURN:
;	Array (np x 3 x nt) of points on the outer edge of each disk,
;	in disk body coordinates.
;
;
; STATUS:
;	Complete
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale
; 	Adapted by:	Spitale, 5/2016
;	
;-
;=============================================================================
function dsk_get_outer_disk_points, dkd, n_points, ta=ta, $
              disk_pts=r_disk
@core.include
 

 nt = n_elements(dkd)

 ;----------------------------------------
 ; true anomaly of each point
 ;----------------------------------------
 if(NOT keyword_set(ta)) then ta = dindgen(n_points)*2d*!dpi/double(n_points-1)

 ;-------------------------------------
 ; get radii
 ;-------------------------------------
 r_disk = dblarr(n_points, 3, nt)

 r_disk[*,0,*] = dsk_get_edge_radius(dkd, ta, /outer)
 r_disk[*,1,*] = ta

 ;-------------------------------------
 ; get elevations
 ;-------------------------------------
 r_disk[*,2,*] = dsk_get_edge_elevation(dkd, ta, /outer)


 ;-------------------------------------
 ; convert to body vectors
 ;-------------------------------------
 r_body = dsk_disk_to_body(dkd, r_disk)


 return, r_body
end
;===========================================================================



