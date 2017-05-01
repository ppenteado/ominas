;=============================================================================
;+
; NAME:
;	apply_colormap
;
;
; PURPOSE:
;	Apply a colormap to an image.
;
;
; CATEGORY:
;	UTIL
;
;
; CALLING SEQUENCE:
;	result = xx(xx, xx)
;	xx, xx, xx
;
;
; ARGUMENTS:
;  INPUT:
;	xx:	xx
;
;	xx:	xx
;
;  OUTPUT:
;	xx:	xx
;
;	xx:	xx
;
;
; KEYWORDS:
;  INPUT:
;	xx:	xx
;
;	xx:	xx
;
;  OUTPUT:
;	xx:	xx
;
;	xx:	xx
;
;
; ENVIRONMENT VARIABLES:
;	xx:	xx
;
;	xx:	xx
;
;
; RETURN:
;	xx
;
;
; COMMON BLOCKS:
;	xx:	xx
;
;	xx:	xx
;
;
; SIDE EFFECTS:
;	xx
;
;
; RESTRICTIONS:
;	xx
;
;
; PROCEDURE:
;	xx
;
;
; EXAMPLE:
;	xx
;
;
; STATUS:
;	xx
;
;
; SEE ALSO:
;	xx, xx, xx
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale, 12/2002
;	
;-
;=============================================================================
function apply_colormap, _image, _map, channel=channel, max=max, min=min
common colors, r_orig, g_orig, b_orig, r_curr, g_curr, b_curr

 map = _map

 ;--------------------------------------
 ; determine number of image planes
 ;--------------------------------------
 nmaps = 1
 s = size(map)
 if(s[0] GT 1) then nmaps = s[2]

 _dim = size(_image, /dim)
 ndim = n_elements(_dim)
 if(_dim[ndim-1] NE nmaps) then image = reform(_image, product(_dim),1) $
 else image = reform(_image, product(_dim[0:ndim-2]),nmaps)

 dim = size(image, /dim)
 if(n_elements(dim) EQ 1) then nplanes = 1 $
 else nplanes = dim[1]

 ;--------------------------------------
 ; scale image
 ;--------------------------------------
 n = n_elements(map)

 scale_image = bytescl(image, top=n-1, max=max, min=min, /double)

 ;--------------------------------------
 ; apply map
 ;--------------------------------------
 if(defined(channel)) then $
  case strupcase(channel) of
   0 : table = r_curr
   1 : table = g_curr
   2 : table = b_curr
  endcase


 if(keyword_set(table)) then for i=0, nplanes-1 do map[*,i] = table[map[*,i]]

 map_image = degen(lonarr(dim[0],nplanes))
 for i=0, nplanes-1 do map_image[*,i] = (map[*,i])[scale_image]

 return, reform(map_image, _dim, /over)
end
;=============================================================================
