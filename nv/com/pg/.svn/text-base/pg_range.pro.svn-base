;=============================================================================
;+
; NAME:
;	pg_range
;
;
; PURPOSE:
;	Computes distance between the centers of two bodies.
;
;
; CATEGORY:
;	NV/PG
;
;
; CALLING SEQUENCE:
;	range = pg_center(bx1, bx2)
;
;
; ARGUMENTS:
;  INPUT:
;	bx1:	Array (n_objects, n_timesteps) of descriptors of objects 
;		which must be a subclass of BODY.
;
;	bx2:	Array (n_objects, n_timesteps) of descriptors of objects 
;		which must be a subclass of BODY.
;
;  OUTPUT: NONE
;
;
; RETURN:
;	Array (n_objects) doubles giving the ranges.
;
;
; STATUS:
;	Complete
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale, 11/2001
;	
;-
;=============================================================================
function pg_range, bx1, bx2

 ;-----------------------------------
 ; validate descriptors
 ;-----------------------------------
 pgs_count_descriptors, bx1, nd=n_objects1, nt=nt1
 pgs_count_descriptors, bx2, nd=n_objects2, nt=nt2
 if((nt1 NE nt2) OR (n_objects1 NE n_objects2)) then $
                 nv_message, name='pg_range', 'Inconsistent descriptors.'

 nt = nt1
 n_objects = n_objects1

 ;-----------------------------------
 ; get centers
 ;-----------------------------------
 bds1=class_extract(bx1, 'BODY')
 bds2=class_extract(bx2, 'BODY')
 center_pts1 = bod_pos(bds1)
 center_pts2 = bod_pos(bds2)

 ;-----------------------------------
 ; compute ranges
 ;-----------------------------------
 offsets = center_pts2 - center_pts1

 ranges = v_mag(offsets)


 return, ranges
end
;=============================================================================
