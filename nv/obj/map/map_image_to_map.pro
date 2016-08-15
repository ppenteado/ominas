;=============================================================================
;+
; NAME:
;	map_image_to_map
;
;
; PURPOSE:
;	Transforms the given image points to map coordinate points.
;
;
; CATEGORY:
;	NV/LIB/MAP
;
;
; CALLING SEQUENCE:
;	map_pts = map_image_to_map(md, image_pts)
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
;	Array (2,nv,nt) of map coordinate points.
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
function _map_image_to_map, md, _image_pts, valid=valid
@core.include
 _md = cor_dereference(md)

 nt = n_elements(_md)
 nv = n_elements(_image_pts)/2/nt

 ii = transpose(linegen3z(2,nt,nv), [0,2,1])
 jj = transpose(gen3y(nt,nv,1))

 size = (_md.size)[ii]
 rotate = (_md.rotate)[jj]

 image_pts = rotate_coord(_image_pts, rotate, /inverse, size=size)

 fn = map_fn_image_to_map(md)

 map_pts = call_function(fn, md, image_pts, valid=valid)
 if(NOT keyword_set(map_pts)) then $
  begin
   valid = [-1]
   return, 0
  end
  
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
   ;bod_set_orient,p1,transpose(bod_orient(p1))

   
   z=sin(lats)
   x=cos(lats)*cos(lons)
   y=cos(lats)*sin(lons)
   xyz=bod_body_to_inertial(p1,[[x],[y],[z]])
   lat1=asin(xyz[*,2])
   lon1=atan(xyz[*,1],xyz[*,0])
   
   nmap_pts[1,*]=lon1;mlon
   nmap_pts[0,*]=lat1;mlat
 endif

 return, nmap_pts
end
;===========================================================================




;===========================================================================
function map_image_to_map, md, _image_pts, valid=valid
@core.include
 _md = cor_dereference(md)

 nt = n_elements(_md)
 nv = n_elements(_image_pts)/2/nt

 ii = transpose(linegen3z(2,nt,nv), [0,2,1])
 jj = transpose(gen3y(nt,nv,1))

 size = (_md.size)[ii]
 rotate = (_md.rotate)[jj]

 image_pts = rotate_coord(_image_pts, rotate, /inverse, size=size)

 fn = map_fn_image_to_map(md)

 map_pts = call_function(fn, md, image_pts, valid=valid)
 if(NOT keyword_set(map_pts)) then $
  begin
   valid = [-1]
   return, 0
  end

 return, map_pts
end
;===========================================================================
