;=============================================================================
;+
; NAME:
;	graphic_to_centric
;
;
; PURPOSE:
;	Converts planetographic surface coordinates to planetocentric.
;
;
; CATEGORY:
;	UTIL
;
;
; CALLING SEQUENCE:
;	result = graphic_to_centric(radii, latlon)
;
;
; ARGUMENTS:
;  INPUT:
;	radii:	Ellipsoid (3,nt) radii.
;
;	latlon:	Array (2,nv,nt) giving the planetographic latitudes and
;		longitudes.
;
;  OUTPUT: NONE
;
;
; KEYWORDS: NONE
;
;
; RETURN:
;	Planetographic coordinates.
;
;
; STATUS:
;	Not complete
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale, 2/2014
;	
;-
;=============================================================================
function graphic_to_centric, radii, v

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


 tan_lon = b2/a2 * tan(v[*,1,*])
 result[1,*,*] = atan(tan_lon)

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


 tan_lat = c2/a2/b2 * $
      sqrt(b4*cos(result[1,*,*])^2 + a4*sin(result[1,*,*])^2) * tan(v[*,0,*])
 result[0,*,*] = atan(tan_lat)

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


 return, result

end
;=============================================================================
