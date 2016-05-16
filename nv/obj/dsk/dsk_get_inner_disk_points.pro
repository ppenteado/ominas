;=============================================================================
;+
; NAME:
;	dsk_get_inner_disk_points
;
;
; PURPOSE:
;	Computes points on the inner edge of a disk. 
;
;
; CATEGORY:
;	NV/LIB/DSK
;
;
; CALLING SEQUENCE:
;	disk_pts = dsk_get_inner_disk_points(dkd, np)
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
;	frame_bd:	Subclass of BODY giving the frame against which to 
;			measure inclinations and nodes, e.g., a planet 
;			descriptor.  One for each dkd.
;
;	dlon:		Azimuthal spacing for the points, instead of specifying
;			the np argument.
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
function dsk_get_inner_disk_points, dkd, n_points, dlon=dlon, frame_bd=frame_bd, $
              disk_pts=r_disk
@core.include
 

 nt = n_elements(dkd)

 ;----------------------------------------
 ; disk longitude of each point
 ;----------------------------------------
 if(NOT keyword__set(dlon)) then dlon = dindgen(n_points)*2.*!dpi/n_points $
 else n_points = n_elements(dlon)

 ;-------------------------------------
 ; get radii
 ;-------------------------------------
 r_disk = dblarr(n_points, 3, nt)

; r_disk[*,0,*] = dsk_get_inner_radius(dkd, dlon, frame_bd)
 r_disk[*,0,*] = dsk_get_edge_radius(dkd, dlon, frame_bd, /inner)
 r_disk[*,1,*] = dlon

 ;-------------------------------------
 ; get elevations
 ;-------------------------------------
 r_disk[*,2,*] = dsk_get_edge_elevation(dkd, dlon, frame_bd, /inner)


 ;-------------------------------------
 ; convert to body vectors
 ;-------------------------------------
 r_body = dsk_disk_to_body(dkd, r_disk, frame_bd=frame_bd)


 return, r_body
end
;===========================================================================



;===========================================================================
; dsk_get_inner_disk_points.pro
;
; Outputs are in disk body coordinates.
;
;===========================================================================
function _dsk_get_inner_disk_points, dkd, n_points, dlon=dlon

 nt = n_elements(dkd)

 ;----------------------------------------
 ; disk longitude of each point
 ;----------------------------------------
 if(NOT keyword__set(dlon)) then dlon = dindgen(n_points)*2.*!dpi/n_points

 ;-------------------------------------
 ; set up rotation in disk coordinates
 ;-------------------------------------
 n = dblarr(nt,3,1)
 n[*,2] = 1
 vo = dblarr(nt,3,1)
 vo[*,0] = 1
 v = transpose( v_rotate(vo, n, sin(dlon), cos(dlon) ) )


 r_disk = dsk_body_to_disk(dkd, v)
 r_disk[*,0,*] = dsk_get_inner_radius(dkd, r_disk[*,1,*])
 r_body = dsk_disk_to_body(dkd, r_disk)


 return, r_body
end
;===========================================================================



