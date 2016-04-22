;===========================================================================
;+
; NAME:
;	glb_sub_point_graphic
;
;
; PURPOSE:
;	Computes the planetographic sub-point in body coordinates.
;
;
; CATEGORY:
;	NV/LIB/GLB
;
;
; CALLING SEQUENCE:
;	n = glb_sub_point_graphic(gbx, r)
;
;
; ARGUMENTS:
;  INPUT: 
;	gbx:	Array (nt) of any subclass of GLOBE descriptors.
;
;	r:	Array (nv,3,nt) of points in the BODY frame.
;
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
;	Array (nv,3,nt) points in the BODY frame that lie on the surface
;	of each globe, directly 'beneath' r, i.e., such that each 
;	planetographic surface normal points at each r.
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
;===========================================================================
function glb_sub_point_graphic, gbxp, v, noevent=noevent
@nv_lib.include
 gbdp = class_extract(gbxp, 'GLOBE')
 nv_notify, gbdp, type = 1, noevent=noevent
 gbd = nv_dereference(gbdp)

 epsilon = 1d-8

 result = glb_sub_point(gbdp, v)				; 1st guess

 ;------------------------------------------------
 ; iterate to find point where normal points at v
 ;------------------------------------------------
 done = 0
 while(NOT done) do $
  begin
   vv = v_unit(v - result)
   normal = glb_get_surface_normal_body(gbdp, result)

   theta = v_angle(vv, normal)

   w = where(theta GT epsilon)
   if(w[0] EQ -1) then done = 1 $
   else $
    begin
     axis = v_unit(v_cross(normal, vv))
     result = v_rotate_11(result, axis, sin(theta), cos(theta))
     result = glb_sub_point(gbdp, result)
    end

  end


 return, result
end
;==============================================================================
