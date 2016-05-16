;=============================================================================
;+
; NAME:
;	dsk_get_disk_points
;
;
; PURPOSE:
;	Computes points on the inner and outer edges of a disk. 
;
;
; CATEGORY:
;	NV/LIB/DSK
;
;
; CALLING SEQUENCE:
;	disk_pts = dsk_get_disk_points(dkd, np)
;
;
; ARGUMENTS:
;  INPUT:
;	dkd:	 Any single subclass of DISK.
;
;	np:	 Number of points on each edge.
;
;  OUTPUT: NONE
;
;
; KEYWORDS:
;  INPUT:  
;	frame_bd:	Subclass of BODY giving the frame against which to 
;			measure inclinations and nodes, e.g., a planet 
;			descriptor.
;
;	dlon:		Azimuthal spacing for the points, instead of specifying
;			the np argument.
;
;  OUTPUT: NONE
;
;
; RETURN:
;	Array (np x 3 x 2) of points on the inner and outer edges of the 
;	disk, in disk body coordinates.
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


;===========================================================================
; dsk_get_disk_points.pro
;
; Outputs are in disk body coordinates.
; Result is [n_points,3,2].
;
;===========================================================================
function _dsk_get_disk_points, dkd, n_points, frame_bd=frame_bd
@core.include
 

 r = dblarr(n_points, 3, 2)
 r[*,*,0] = dsk_get_inner_disk_points(dkd, n_points, frame_bd=frame_bd)
 r[*,*,1] = dsk_get_outer_disk_points(dkd, n_points, frame_bd=frame_bd)

 return, r
end
;===========================================================================



;===========================================================================
; dsk_get_disk_points.pro
;
; Outputs are in disk body coordinates.
; Result is [n_points,3,2].
;
;===========================================================================
function dsk_get_disk_points, dkd, n_points, frame_bd=frame_bd, dlon=dlon
@core.include
 

 r_inner = dsk_get_inner_disk_points(dkd, n_points, frame_bd=frame_bd, dlon=dlon)
 r_outer = dsk_get_outer_disk_points(dkd, n_points, frame_bd=frame_bd, dlon=dlon)

 np = n_elements(r_inner)/3
 r = dblarr(n_points, 3, 2)
 r[*,*,0] = r_inner
 r[*,*,1] = r_outer

 return, r
end
;===========================================================================



