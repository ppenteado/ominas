;=============================================================================
;+
; NAME:
;       image_to_globe
;
;
; PURPOSE:
;       Transforms points in image coordinates to body globe coordinates
;
;
; CATEGORY:
;       NV/LIB/TOOLS/COMPOSITE
;
;
; CALLING SEQUENCE:
;       result = image_to_globe(cd, gbx, p)
;
;
; ARGUMENTS:
;  INPUT:
;	cd:       Array of nt camera or map descriptors.
;
;	gbx:      Array of nt object descriptors (of type GLOBE).
;
;	p:        Array (2 x nv x nt) of image points.
;
;  OUTPUT:
;       NONE
;
; KEYWORDS:
;   INPUT: NONE
;
;   OUTPUT:
;	valid:	Indices of valid output points.
;
;	body_pts:	Body coordinates of output points.
;
;	discriminant:	Determinant D from the ray trace.  No solutions for
;			D<0, two solutions for D=0, one slution for D>0.
;
;
; RETURN:
;       Array (nv x 3 x nt) of globe positions.
;
; STATUS:
;       Completed.
;
;
; MODIFICATION HISTORY:
;       Written by:     Spitale;
;-
;=============================================================================
function image_to_globe, cd, gbx, p, body_pts=body_pts, $
                                      discriminant=discriminant, valid=valid

 if(NOT keyword_set(p)) then return, 0

 class = (cor_class(cd))[0]

 np = n_elements(p)/2
 nt = n_elements(gbx)

 case class of 
  'MAP' : $
	begin
	 mp = map_image_to_map(cd, p)

	 if(NOT keyword_set(mp)) then return, 0
	 return, map_to_globe(cd, gbx, mp)
	end

  'CAMERA' : $
	begin
	 cam_pos = (bod_pos(cd))[gen3y(np,3,nt)]
	 v = bod_inertial_to_body_pos(gbx, cam_pos)

	 r_inertial = (bod_body_to_inertial(cd, $
	                cam_focal_to_body(cd, $
	                  cam_image_to_focal(cd, p))))[linegen3z(np,3,nt)]
	 r = bod_inertial_to_body(gbx, r_inertial)

	 body_pts = glb_intersect(gbx, v, r, discriminant=discriminant)
         valid = where(discriminant GE 0)

         w = where(discriminant GE 0)
         if(w[0] EQ -1) then return, 0

	 return, glb_body_to_globe(gbx, body_pts)
	end


  else :
 endcase


end
;==========================================================================
