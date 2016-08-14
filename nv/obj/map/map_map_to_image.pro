;=============================================================================
;+
; NAME:
;	map_map_to_image
;
;
; PURPOSE:
;	Transforms the given map points to map image points.
;
;
; CATEGORY:
;	NV/LIB/MAP
;
;
; CALLING SEQUENCE:
;	image_pts = map_map_to_image(md, map_pts)
;
;
; ARGUMENTS:
;  INPUT: 
;	md	 	Array (nt) of MAP descriptors.
;
;	map_pts:	Array (2,nv,nt) of map points.
;
;  OUTPUT: NONE
;
;
; KEYWORDS:
;  INPUT: 
;	nowrap:	If set, then points that lie outide the map will not be
;		around to the other side.
;
;  OUTPUT: 
;	valid:	Indices of all input points that correspond to valid
;		output image points.  If not se then all points are
;		valid.
;
;
; RETURN:
;	Array (2,nv,nt) of map image points.
;
;
; STATUS:
;	Complete
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale, 1/1998
;	
;-
;=============================================================================
function map_map_to_image, md, _map_pts, valid=valid, nowrap=nowrap, all=all
 _md = cor_dereference(md)

 nt = n_elements(_md)
 nv = n_elements(_map_pts)/2/nt

 pi2 = !dpi/2d
 
 map_pts = _map_pts
 nmap_pts=map_pts
 if finite(_md.pole.lat)+finite(_md.pole.lon)+finite(_md.pole.rot) eq 3 then begin
   pole_lat=30d0*!dpi/180d0;_md.pole.lat
   pole_lon=90d0*!dpi/180d0;-_md.pole.lon
   pole_rot=0d0*!dpi/180d0;_md.pole.rot
   pole_lat=_md.pole.lat
   pole_lon=-_md.pole.lon
   pole_rot=_md.pole.rot
   lons=reform(map_pts[1,*])
   lats=reform(map_pts[0,*])

   
   
   p1=ominas_body()
   bod_rotate,p1,pole_lon,axis=2
   bod_rotate,p1,(0.5d0*!dpi-pole_lat),axis=1
   bod_rotate,p1,pole_rot,axis=2
   bod_set_orient,p1,transpose(bod_orient(p1))

   
   z=sin(lats)
   x=cos(lats)*cos(lons)
   y=cos(lats)*sin(lons)
   xyz=bod_body_to_inertial(p1,[[x],[y],[z]])
   lat1=asin(xyz[*,2])
   lon1=atan(xyz[*,1],xyz[*,0])
   
   nmap_pts[1,*]=lon1;mlon
   nmap_pts[0,*]=lat1;mlat
 endif

 ii = transpose(linegen3z(2,nt,nv), [0,2,1])
 jj = transpose(gen3y(nt,nv,1))

 size = double((_md.size)[ii])
 rotate = (_md.rotate)[jj]

 fn = map_fn_map_to_image(md[0])

 image_pts = call_function(fn, md, nmap_pts)
 image_pts = rotate_coord(image_pts, rotate, size=size)

 if(NOT keyword_set(nowrap)) then image_pts = map_wrap_points(_md, image_pts, map_pts)

 if(NOT keyword_set(all)) then valid = map_valid_points(_md, map_pts, image_pts) $
 else valid = lindgen(nv*nt)



 return, image_pts
end
;===========================================================================
