;===========================================================================
;+
; NAME:
;	surface_normal
;
;
; PURPOSE:
;	Computes the normal at points on a surface.
;
;
; CATEGORY:
;       NV/LIB/TOOLS/COMPOSITE
;
;
; CALLING SEQUENCE:
;	norm_pts = surface_normal(bx, r)
;
;
; ARGUMENTS:
;  INPUT: 
;	bx:	Array (nt) of any subclass of BODY descriptors with
;		the expected surface parameters.
;
;	r:	Array (nv,3,nt) giving surface positions in the BODY frame.
;
;
;  OUTPUT: NONE
;
;
; KEYWORDS:
;  INPUT: 
;	frame_bd:  Frame descriptor, if required for bx.
;
;  OUTPUT: NONE
;
;
; RETURN: 
;	Array (nv, 3, nt) of surface unit normals in the BODY frame.
;
;
; STATUS:
;	Complete
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale, 7/2015
;	
;-
;===========================================================================
function surface_normal, bx, r, frame_bd=frame_bd

 if(keyword_set(class_extract(bx, 'GLOBE'))) then $
     norm_pts = glb_surface_normal(bx, r) $
 else if(keyword_set(class_extract(bx, 'DISK'))) then $
     norm_pts = dsk_surface_normal(bx, r, frame_bd=frame_bd)


 return, norm_pts
end
;===========================================================================
