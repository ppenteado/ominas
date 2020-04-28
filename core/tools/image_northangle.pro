;=============================================================================
;+
; NAME:
;       image_northangle
;
;
; PURPOSE:
;	Computes the image azimuth (see image_azimuth.pro) of the north 
;	direction on the surface of the given body at the specified pixel 
;	location p.
;
;
; CATEGORY:
;       NV/LIB/TOOLS
;
;
; CALLING SEQUENCE:
;       result = image_northangle(cd, gbx, p)
;
;
; ARGUMENTS:
;  INPUT:
;	cd:	Camera descriptor.
;
;	gbx:	Any subclass of GLOBE.
;
;	p:	Array (2) giving the image point.
;
;  OUTPUT:  NONE
;
;
; KEYOWRDS:
;  INPUT: NONE
;
;  OUTPUT: 
;	valid:	Indicates whether the result has a solution.  -1 if no
;		solution, 1 otherwise.
;
;
; RETURN:
;       Angle in radians.
;
;
;
; MODIFICATION HISTORY:
;       Written by:     Spitale
;
;-
;=============================================================================
function image_northangle, cd, gbx, p, valid=valid

 valid = -1

 zz = tr([0,0,1d])

 surf_pt = image_to_surface(cd, gbx, p, body=body_pt, dis=dis)
 if(dis[0] LT 0) then return, 0
 valid = 0

 body_pt = body_pt[0,*]
 nn = v_unit(glb_get_surface_normal(/body, gbx, body_pt))
 ll = v_unit(v_cross(zz, nn))

 northaz = v_cross(nn, ll)
 northaz_inertial = bod_body_to_inertial(gbx, northaz)

 return, image_azimuth(cd, northaz_inertial)
end
;===========================================================================



