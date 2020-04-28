;=============================================================================
;+
; NAME:
;	centric_to_graphic
;
;
; PURPOSE:
;	Converts planetocentric surface coordinates to planetographic.
;
;
; CATEGORY:
;	UTIL
;
;
; CALLING SEQUENCE:
;	result = centric_to_graphic(radii, latlon)
;
;
; ARGUMENTS:
;  INPUT:
;	radii:	Array (3,nt) of Ellipsoid radii.
;
;	latlon:	Array (2,nv,nt) giving the planetocentric latitudes and
;		longitudes.
;
;  OUTPUT: NONE
;
;
; KEYWORDS: NONE
;
;
; RETURN:
;	Planetocentric coordinates.
;
;
; STATUS:
;	Complete
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale, 2/2014
;	
;-
;=============================================================================
function centric_to_graphic, radii, v

 dim = size(v, /dim)
 ndim = n_elements(dim)
 nv = 1 & nt = 1
 if(ndim GT 1) then nv = dim[1]
 if(ndim GT 2) then nt = dim[2]

 result = dblarr(2,nv,nt)

 a2 = radii[0]^2
 b2 = radii[1]^2
 c2 = radii[2]^2
 a4 = a2^2
 b4 = b2^2

 tan_glat = a2*b2/c2 / sqrt(b4*cos(v[*,1,*])^2 + a4*sin(v[*,1,*])^2) * $
                                                               tan(v[*,0,*])
 tan_glon = a2/b2 * tan(v[*,1,*])

 result[0,*,*] = atan(tan_glat)
 result[1,*,*] = atan(tan_glon)

; w = where(v[*,0,*] GT !dpi/2d)
; if(w[0] NE -1) then $
;  begin
;   xx = result[0,*,*]
;   xx[w] = xx[w] + !dpi
;   result[0,*,*] = xx
;  end

; w = where(v[*,0,*] LT -!dpi/2d)
; if(w[0] NE -1) then $
;  begin
;   xx = result[0,*,*]
;   xx[w] = xx[w] - !dpi
;   result[0,*,*] = xx
;  end

 w = where((v[*,1,*] GT !dpi/2d) AND (v[*,1,*] LT 3d*!dpi/2d))
 if(w[0] NE -1) then $
  begin
   xx = result[1,*,*]
   xx[w] = xx[w] + !dpi
   result[1,*,*] = xx
  end

 w = where((v[*,1,*] LT -!dpi/2d) AND (v[*,1,*] GT -3d*!dpi/2d))
 if(w[0] NE -1) then $
  begin
   xx = result[1,*,*]
   xx[w] = xx[w] - !dpi
   result[1,*,*] = xx
  end


 return, result
end
;=============================================================================
