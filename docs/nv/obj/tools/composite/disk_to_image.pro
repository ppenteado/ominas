;=============================================================================
;+
; NAME:
;       disk_to_image
;
;
; PURPOSE:
;       Transforms points in disk coordinates to image coordinates
;
;
; CATEGORY:
;       NV/LIB/TOOLS/COMPOSITE
;
;
; CALLING SEQUENCE:
;       result = disk_to_image(cd, dkx, p)
;
;
; ARGUMENTS:
;  INPUT:
;	cd:       Array of nt camera or map descriptors.
;
;	dkx:      Array of nt object descriptors (subclass of DISK).
;
;	p:       Array (nv x 3 x nt) of image points.
;
;  OUTPUT:
;       NONE
;
; KEYWORDS:
;   INPUT:
;	sund:	If given, longitudes are assumed to be referenced to the 
;		sun direction.
;
;   OUTPUT:
;	valid:	Indices of valid output points.
;
;	body_pts:	Body coordinates of output points.
;
;
; RETURN:
;       Array (nv x 3 x nt) of image coordinates.
;
; STATUS:
;       Completed.
;
;
; MODIFICATION HISTORY:
;       Written by:     Spitale, 9/2002
;-
;=============================================================================
function disk_to_image, cd, dkx, p, body_pts=p_body, valid=valid

 nt = n_elements(cd)
 sv = size(p)
 nv = sv[1]

 class = (cor_class(cd))[0]

 case class of 
  'MAP' : return, map_map_to_image(cd, disk_to_map(cd, dkx, p), valid=valid)

  'CAMERA' : $
	begin
	 p_body = dsk_disk_to_body(dkx, p)
	 image_pts =  inertial_to_image_pos(cd,  $
                        bod_body_to_inertial_pos(dkx, p_body))
         valid = lindgen(nv,nt)
	 return, image_pts
	end

  default :
 endcase

end
;==========================================================================
