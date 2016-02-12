;=============================================================================
;+
; NAME:
;       image_to_ra_dec
;
;
; PURPOSE:
;       Translates a point in image coordinates to polar inertial 
;       coordinates (right ascension and declination) with origin at
;       the camera (spacecraft).
;
;
; CATEGORY:
;       NV/LIB/TOOLS
;
;
; CALLING SEQUENCE:
;       result = image_to_ra_dec(cd, p)
;
;
; ARGUMENTS:
;  INPUT:
;             cd:       Camera or map descriptor
;
;              p:       An array of image points
;
;  OUTPUT:
;       NONE
;
; RETURN:
;       An array of surface positions.
;
; STATUS:
;       Completed.
;
;
; MODIFICATION HISTORY:
;       Written by:     Tiscareno (modified from image_to_surface)
;-
;=============================================================================
function  image_to_ra_dec, cd, p

 class = get_class(cd)

 case class of		; Not implemented for 'MAP'

  'CAMERA' : $
	begin
	 cam_bd = cam_body(cd)

	 ; Transform axes from image to inertial
	 r = bod_body_to_inertial(cam_bd, $
	       cam_focal_to_body(cd, $
	         cam_image_to_focal(cd, p)))

         ; Transform from Cartesian to polar coordinates
	 return, glb_body_to_surface(cd, r)
	end


  default :
 endcase


end
;==========================================================================
