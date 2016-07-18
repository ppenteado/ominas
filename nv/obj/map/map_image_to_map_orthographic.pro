;=============================================================================
;+
; NAME:
;	map_image_to_map_orthographic
;
;
; PURPOSE:
;	Transforms the given image points to map coordinate points
;	using an orthographic projection.
;
;
; CATEGORY:
;	NV/LIB/MAP
;
;
; CALLING SEQUENCE:
;	map_pts = map_image_to_map_orthographic(md, image_pts)
;
;
; ARGUMENTS:
;  INPUT: 
;	md	 	Array (nt) of MAP descriptors.
;
;	image_pts:	Array (2,nv,nt) of map image points.
;
;  OUTPUT: NONE
;
;
; KEYWORDS:
;  INPUT: NONE
;
;  OUTPUT: 
;	valid:	Indices of all input points that correspond to valid
;		output map points.  If not set then all points are
;		valid.
;
;
; RETURN:
;	Array (2,nv,nt) of map coordinate points in an orthographic 
;	projection.  This projection portrays a planet as seen from a
;	great distance.  Scale is true only at the map center.  Areas 
;	are distorted, especially away from the map center.  
;
;	With:
; 
;	  R = min(size[0],size[1])/2 * scale,
;
;	and:
;
;	  rho = sqrt(x^2 + y^2),
;
;	and:
;
;	  c = asin(rho/R),
;
;	the transformation is:
;
;	  lat = asin( cos(c)*sin(center[0]) + 
;	                    y*sin(c)*cos(center[0])/rho ) / units[0]
;
;	  lon = center[1] + 
;	          atan( x*sin(c)/(rho*cos(center[0])*cos(c) - 
;	                        y*sin(center[0])*sin(c)) ) + units[1]
;
;
;	See [1], p. 150 for the mathematical derivation.
;
;	[1] Snyder (1987)
;	    Map projections -- A working manual
;	    USGS professional paper 1395
;
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
;=============================================================================
function map_image_to_map_orthographic, md, _image_pts, valid=valid
@core.include
 _md = cor_dereference(md)

 nt = n_elements(_md)
 sv = size(_image_pts)
 nv = 1
 if(sv[0] GT 1) then nv = sv[2]

 ii = transpose(linegen3z(2,nt,nv), [0,2,1])
 jj = transpose(gen3y(nt,nv,1))

 units = (_md.units)[ii]
 scale = (_md.scale)[jj]
 size = double((nmin(_md.size,0))[jj])
 center = (_md.center)[ii]
 origin = (_md.origin)[ii]

 image_pts = _image_pts - origin

 R = 0.5*size*scale

 rho = sqrt(image_pts[0,*,*]^2 + image_pts[1,*,*]^2)
 valid = where(rho LT R)
 if(valid[0] EQ -1) then return, 0

 rho = rho[valid]
 c = asin(rho/R) 

 lat = dblarr(1,nv,nt)
 lon = dblarr(1,nv,nt)

 c0 = (center[0,*,*])[valid]
 im0 = (image_pts[0,*,*])[valid]
 im1 = (image_pts[1,*,*])[valid]
 u0 = (units[0,*,*])[valid]
 u1 = (units[1,*,*])[valid]

 lat[valid] = asin(cos(c)*sin(c0) + (im1*sin(c)*cos(c0)/rho)) / u0
 lon[valid] = center[1,*,*] + atan(im0*sin(c), (rho*cos(c0)*cos(c) - im1*sin(c0)*sin(c))) / u1

 w = where(rho EQ 0)
 if(w[0] NE -1) then lat[w] = _md.center[0]

 result = [lat,lon]
 return, result
end
;===========================================================================



;=============================================================================
function _map_image_to_map_orthographic, md, _image_pts, valid=valid
@core.include
 _md = cor_dereference(md)

 nt = n_elements(_md)
 sv = size(_image_pts)
 nv = 1
 if(sv[0] GT 1) then nv = sv[2]


 _image_pts = reform(_image_pts, 2,nv*nt, /over)

 result = dblarr(2,nv*nt)

 R = 0.5*min(_md.size)*_md.scale

 image_pts = dblarr(2,nv*nt, /nozero)
 image_pts[0,*] = _image_pts[0,*] - _md.origin[0]
 image_pts[1,*] = _image_pts[1,*] - _md.origin[1]


 rho = sqrt(image_pts[0,*]^2 + image_pts[1,*]^2)
 valid = where(rho LT R)
 if(valid[0] EQ -1) then $
  begin
   _image_pts = reform(_image_pts, 2,nv,nt, /over)
   return, 0
  end

 rho = rho[valid]
 c = asin(rho/R) 


 result[0,valid] = $
       asin(cos(c)*sin(_md.center[0]) + $
            (image_pts[1,valid]*sin(c)*cos(_md.center[0])/rho)) / _md.units[0]

 result[1,valid] = $
        _md.center[1] + $
           atan(image_pts[0,valid]*sin(c), $
              (rho*cos(_md.center[0])*cos(c) - $
                  image_pts[1,valid]*sin(_md.center[0])*sin(c))) / _md.units[1]

 result = reform(result, 2,nv,nt, /over)


 _image_pts = reform(_image_pts, 2,nv,nt, /over)
 return, result
end
;===========================================================================



