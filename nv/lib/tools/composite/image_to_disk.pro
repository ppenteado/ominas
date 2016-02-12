;=============================================================================
;+
; NAME:
;       image_to_disk
;
;
; PURPOSE:
;       Transforms points in image coordinates to disk coordinates
;
;
; CATEGORY:
;       NV/LIB/TOOLS/COMPOSITE
;
;
; CALLING SEQUENCE:
;       result = image_to_disk(cd, dkx, p)
;
;
; ARGUMENTS:
;  INPUT:
;	cd:	Array of nt camera or map descriptors.
;
;	dkx:	Array of nt object descriptors (subclass of DISK).
;
;	p:	Array (2 x nv x nt) of image points.
;
;  OUTPUT:
;       hit:	Array with one element per input point.  1 if point
;		falls on the body, 0 if not.
;
;
; KEYWORDS:
;   INPUT:
;	frame_bd:	Subclass of BODY giving the frame against which to 
;			measure inclinations and nodes, e.g., a planet 
;			descriptor.  One per bx.
;
;   OUTPUT:
;	valid:	Indices of valid output points.
;
;       hit:	Array with one element per input point.  1 if point
;		falls on the body, 0 if not.
;
;	body_pts:	Body coordinates of output points.
;
;
; RETURN:
;       Array (nv x 3 x nt) of disk positions.
;
; STATUS:
;       Completed.
;
;
; MODIFICATION HISTORY:
;       Written by:     Tiscareno (modified from image_to_surface)
;-
;=============================================================================
function image_to_disk, cd, dkx, p, frame_bd=frame_bd, hit=hit, valid=valid, $
           body_pts=v_int

 if(NOT keyword_set(p)) then return, 0

 class = (class_get(cd))[0]
 np = n_elements(p)/2
 dim = size(p, /dim)
 if(n_elements(dim) GT 1) then np = dim[1] 

 nt = n_elements(dkx)

 case class of 
  'MAP' : $
	begin
hit = 0
	 mp = map_image_to_map(cd, p)

	 if(NOT keyword__set(mp)) then return, 0
	 return, map_to_disk(cd, dkx, mp)
	end

  'CAMERA' : $
	begin
	 cam_pos = bod_pos(cd)
         if(nt GT 1) then cam_pos = cam_pos[linegen3z(1,3,nt)]

	 v = bod_inertial_to_body_pos(dkx, cam_pos)
	 v = v[linegen3x(np,3,nt)]

	 rr = image_to_inertial(cd, p)
	 r = bod_inertial_to_body(dkx, rr)

	 v_int = dsk_intersect(dkx, v, r, hit=hit, frame_bd=frame_bd)
	 valid = hit

;         w = where(hit EQ 1)
;         if(w[0] EQ -1) then return, 0

	 return, dsk_body_to_disk(dkx, v_int, frame_bd=frame_bd)
	end


  default :
 endcase


end
;==========================================================================
