;===========================================================================
;+
; NAME:
;	glb_globe_to_graphic
;
;
; PURPOSE:
;       Converts the given vectors from the globe coordinate
;       system to the graphic coordinate system.
;
;
; CATEGORY:
;	NV/LIB/GLB
;
;
; CALLING SEQUENCE:
;	graphic_pts = glb_globe_to_graphic(gbd, globe_pts)
;
;
; ARGUMENTS:
;  INPUT: 
;	gbd:	        Array (nt) of any subclass of GLOBE descriptors.
;
;	globe_pts:	Array (nv,3,nt) of column vectors in the globe system.
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
;       Array (nv,3,nt) of column vectors in the graphic system.
;
;
; STATUS:
;	Complete
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale, 1/1998
; 	Adapted by:	Spitale, 5/2016
;	
;-
;===========================================================================
function glb_globe_to_graphic, gbd, v
@core.include
 
 _gbd = cor_dereference(gbd)

;stop
; result = v
; result[*,[0,1],*] = $
;    transpose($
;        centric_to_graphic(_gbd.radii, transpose(v[*,[0,1],*], [1,0,2])), [1,0,2])
; return, result







 sv = size(v)
 nv = sv[1]
 nt = n_elements(_gbd)

 result = dblarr(nv,3,nt)

 a2 = _gbd.radii[0]^2
 b2 = _gbd.radii[1]^2
 c2 = _gbd.radii[2]^2
 a4 = a2^2
 b4 = b2^2

 tan_glat = a2*b2/c2 / sqrt(b4*cos(v[*,1,*])^2 + a4*sin(v[*,1,*])^2) * $
                                                               tan(v[*,0,*])
 tan_glon = a2/b2 * tan(v[*,1,*])

 result[*,0,*] = atan(tan_glat)
 result[*,1,*] = atan(tan_glon)

; w = where(v[*,0,*] GT !dpi/2d)
; if(w[0] NE -1) then $
;  begin
;   xx = result[*,0,*]
;   xx[w] = xx[w] + !dpi
;   result[*,0,*] = xx
;  end

; w = where(v[*,0,*] LT -!dpi/2d)
; if(w[0] NE -1) then $
;  begin
;   xx = result[*,0,*]
;   xx[w] = xx[w] - !dpi
;   result[*,0,*] = xx
;  end

 w = where((v[*,1,*] GT !dpi/2d) AND (v[*,1,*] LT 3d*!dpi/2d))
 if(w[0] NE -1) then $
  begin
   xx = result[*,1,*]
   xx[w] = xx[w] + !dpi
   result[*,1,*] = xx
  end

 w = where((v[*,1,*] LT -!dpi/2d) AND (v[*,1,*] GT -3d*!dpi/2d))
 if(w[0] NE -1) then $
  begin
   xx = result[*,1,*]
   xx[w] = xx[w] - !dpi
   result[*,1,*] = xx
  end


 return, result
end
;===========================================================================



