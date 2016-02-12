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
;       result = image_to_globe(cd, od, p)
;
;
; ARGUMENTS:
;  INPUT:
;	cd:       Array of nt camera or map descriptors.
;
;	od:       Array of nt object descriptors (of type GLOBE).
;
;	p:       Array (2 x nv x nt) of image points.
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
function image_to_globe, cd, od, p, body_pts=body_pts, $
                                      discriminant=discriminant, valid=valid

 if(NOT keyword_set(p)) then return, 0

 class = class_get(cd)

 np = n_elements(p)/2
 nt = n_elements(od)

 case class of 
  'MAP' : $
	begin
	 mp = map_image_to_map(cd, p)

	 if(NOT keyword_set(mp)) then return, 0
	 return, map_to_globe(cd, od, mp)
	end

  'CAMERA' : $
	begin
	 gbd = class_extract(od, 'GLOBE')
	 sld = glb_solid(gbd)
	 bd = sld_body(sld)

	 cam_bd = cam_body(cd)

	 cam_pos = (bod_pos(cam_bd))[gen3y(np,3,nt)]
	 v = bod_inertial_to_body_pos(bd, cam_pos)

	 r_inertial = (bod_body_to_inertial(cam_bd, $
	                cam_focal_to_body(cd, $
	                  cam_image_to_focal(cd, p))))[linegen3z(np,3,nt)]
	 r = bod_inertial_to_body(bd, r_inertial)

	 body_pts = glb_intersect(gbd, v, r, discriminant=discriminant)
         valid = where(discriminant GE 0)

         w = where(discriminant GE 0)
         if(w[0] EQ -1) then return, 0

	 return, glb_body_to_globe(gbd, body_pts)
	end


  else :
 endcase


end
;==========================================================================
