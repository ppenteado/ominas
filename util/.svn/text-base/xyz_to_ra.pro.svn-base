;=============================================================================
;+
; NAME:
;       xyz_to_ra
;
;
; PURPOSE:
;	Convert an array of position vectors [x, y, z] to RA and DEC
;
;
; CATEGORY:
;       UTIL
;
;
; CALLING SEQUENCE:
;       xyz_to_ra, pos, ra, dec
;
;
; ARGUMENTS:
;  INPUT:
;       pos:	An array of 1x3 column vectors (1,3,n)
;
;  OUTPUT:
;        ra:	Output array of Right Ascension (in degrees)
;
;       dec:	Output array of Declination (in degrees)
;
; KEYWORDS:
;
;       NONE
;
; STATUS:
;       Completed.
;
;
; MODIFICATION HISTORY:
;       Written by:     Haemmerle 6/2000 
;                       
;-
;=============================================================================
pro xyz_to_ra, pos, ra, dec

 n = n_elements(pos)/3
 ra = make_array(n,value=0d)
 dec = make_array(n,value=0d)

 for i=0,n-1 do $
  begin
   x = pos[0,0,i]
   y = pos[0,1,i]
   z = pos[0,2,i]
   dist = sqrt(x*x + y*y + z*z)
   dec[i] = asin(z/dist)*180d/!dpi
   ra[i] = atan(y/dist,x/dist)*180d/!dpi
  end

 end
