;=============================================================================
;+
; NAME:
;	pg_grid_globe
;
;
; PURPOSE:
;	Computes image points on a latitude/longitude grid for objects that 
;	are a subclass of GLOBE.
;
;
; CATEGORY:
;	NV/PG
;
;
; CALLING SEQUENCE:
;	grid_ps = pg_grid_globe(cd=cd, gbx=gbx)
;	grid_ps = pg_grid_globe(gd=gd)
;
;
; ARGUMENTS:
;  INPUT: NONE
;
;  OUTPUT: NONE
;
;
; KEYWORDS:
;  INPUT:
;	cd:	Array (n_timesteps) of camera descriptors.
;
;	gbx:	Array (n_objects, n_timesteps) of descriptors of objects 
;		which must be a subclass of GLOBE.
;
;	gd:	Generic descriptor.  If given, the cd and gbx inputs 
;		are taken from the cd and gbx fields of this structure
;		instead of from those keywords.
;
;	lat:	Array giving grid-line latitudes in radians.
;
;	lon:	Array giving grid-line longitudes in radians.
;
;	nlat:	Number of equally-spaced latitude lines to generate if keywor
;		lat not given.  Default is 12.
;
;	flat:	This reference latitude line will be one of the latitude lines generated 
;		if nlat is specified.  Default is zero.
;
;	nlon:	Number of equally-spaced longitude lines to generate if keyword
;		lon not given.  Default is 12.
;
;	flon:	This reference longitude line will be one of the longitude lines generated 
;		if nlon is specified.  Default is zero.
;
;	fov:	 If set points are computed only within this many camera
;		 fields of view.
;
;	cull:	 If set, points structures excluded by the fov keyword
;		 are not returned.  Normally, empty points structures
;		 are returned as placeholders.
;
;	npoints: Number of points to compute in each latitude or longitude line,
;		 per 2*pi radians; default is 360.
;
;
;  OUTPUT: 
;	lat:	Array giving grid-line latitudes in radians.
;
;	lon:	Array giving grid-line longitudes in radians.
;
;	plat_ps:	pg_points_struct giving the image coordinates of the
;			intersection of the each latitude line with the 
;			reference longitude line.  These points can be used to draw
;			labels for the latitude lines. 
;
;	plon_ps:	pg_points_struct giving the image coordinates of the
;			intersection of the each longitude line with the 
;			reference latitude line.
;
;
; RETURN:
;	Array (n_objects) of pg_points_struct containing image points and
;	the corresponding inertial vectors.
;
;
; STATUS:
;	Complete
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale, 2/1998
;	
;-
;=============================================================================
function pg_grid_globe, cd=cd, gbx=gbx, gd=gd, lat=_lat, lon=_lon, $
		nlat=nlat, nlon=nlon, flat=flat, flon=flon, npoints=npoints, $
		plat_ps=plat_ps, plon_ps=plon_ps, fov=fov, cull=cull
@pgs_include.pro

 ;-----------------------------------------------
 ; dereference the generic descriptor if given
 ;-----------------------------------------------
 pgs_gd, gd, cd=cd, gbx=gbx
 if(NOT keyword_set(cd)) then cd = 0 

 if(keyword_set(fov)) then slop = (cam_size(cd[0]))[0]*(fov-1) > 1

 ;-----------------------------------
 ; generate lat/lon grid
 ;-----------------------------------
 if(NOT keyword_set(npoints)) then npoints = 360

 if(NOT defined(flat)) then flat = 0d
 if(NOT defined(flon)) then flon = 0d

 nplat = npoints
 nplon = npoints/2

 if(n_elements(_lat) EQ 0) then $
  begin
   if(n_elements(nlat) EQ 0) then nlat = 12
   lat = dindgen(nlat)/nlat*!dpi + flat
   w = where(lat GT !dpi/2d)
   if(w[0] NE -1) then lat[w] = lat[w] - !dpi
  end $
 else lat = _lat

 if(n_elements(_lon) EQ 0) then $
  begin
   if(n_elements(nlon) EQ 0) then nlon = 24
   lon = reduce_angle(dindgen(nlon)/nlon*2d*!dpi + flon)
  end $
 else lon = _lon

 _lat = lat
 _lon = lon

 ;-----------------------------------
 ; validate descriptors
 ;-----------------------------------
 nt = n_elements(cd)
 pgs_count_descriptors, gbx, nd=n_objects, nt=nt1
 if(nt NE nt1) then nv_message, name='pg_grid', $
                                   'Inconsistent camera and object timesteps.'


 ;-----------------------------------
 ; get grid for each planet
 ;-----------------------------------
 grid_ps = replicate({pg_points_struct}, n_objects)
 plat_ps = replicate({pg_points_struct}, n_objects)
 plon_ps = replicate({pg_points_struct}, n_objects)

 for i=0, n_objects-1 do $
  begin
   xd = reform(gbx[i,*], nt)
   gbds = class_extract(xd, 'GLOBE')			; Object i for all t.

   scan_lat = dindgen(nplat)*!dpi/nplat - !dpi/2d
   scan_lon = dindgen(nplon)*2d*!dpi/nplon

   ;- - - - - - - - - - - - - - - - -
   ; fov 
   ;- - - - - - - - - - - - - - - - -
   continue = 1
   if(keyword_set(fov)) then $
    begin
     glb_image_bounds, cd, xd, slop=slop, border_pts_im=border_pts_im, $
                    latmin=latmin, latmax=latmax, lonmin=lonmin, lonmax=lonmax
    if(NOT keyword_set(lonmin)) then continue = 0 $
    else $
     begin
      scan_lon = dindgen(nplon)/double(nplon)*(lonmax-lonmin) + lonmin
      scan_lat = dindgen(nplat)/double(nplat)*(latmax-latmin) + latmin
     end
    end

   ;- - - - - - - - - - - - - - - - -
   ; compute points 
   ;- - - - - - - - - - - - - - - - -
   if(continue) then $
    begin
     grid_pts = glb_get_grid_points(gbds, lat=_lat, lon=_lon, $
                                                 scan_lat=scan_lat, scan_lon=scan_lon)
 
     ;-----------------------------------
     ; compute grid
     ;-----------------------------------
     flags = bytarr(n_elements(grid_pts[*,0]))
     points = body_to_image_pos(cd, xd, grid_pts, inertial=inertial_pts, valid=valid)
     if(keyword__set(valid)) then $
      begin
       invalid = complement(grid_pts[*,0], valid)
       if(invalid[0] NE -1) then flags[invalid] = PGS_INVISIBLE_MASK
      end
     grid_ps[i] = $
          pgs_set_points( grid_ps[i], $
		name = get_core_name(gbds), $
		desc = 'globe_grid', $
		input = pgs_desc_suffix(gbx=gbx[i,0], cd=cd[0]), $
		assoc_idp = nv_extract_idp(xd), $
		points = points, $
		flags = flags, $
		vectors = inertial_pts )

     ;---------------------------------------------------
     ; compute reference longitude-line intersections
     ;---------------------------------------------------
     plat_pts = glb_get_grid_points(gbds, lon=[flon], scan_lat=_lat)

     flags = bytarr(n_elements(plat_pts[*,0]))
     points = body_to_image_pos(cd, xd, plat_pts, inertial=plat_inertial_pts, valid=valid)
     if(keyword__set(valid)) then $
      begin
       invalid = complement(plat_pts[*,0], valid)
       if(invalid[0] NE -1) then flags[invalid] = PGS_INVISIBLE_MASK
      end
     plat_ps[i] = $
          pgs_set_points( plat_ps[i], $
		points = points, $
		flags = flags, $
		desc = 'globe_grid_plat', $
		input = pgs_desc_suffix(gbx=gbx[i,0], cd=cd[0]), $
		vectors = plat_inertial_pts )

     ;---------------------------------------------------
     ; compute reference latitude-line intersections
     ;---------------------------------------------------
     plon_pts = glb_get_grid_points(gbds, lat=[flat], scan_lon=_lon)

     flags = bytarr(n_elements(plon_pts[*,0]))
     points = body_to_image_pos(cd, xd, plon_pts, inertial=plon_inertial_pts, valid=valid)
     if(keyword__set(valid)) then $
      begin
       invalid = complement(plon_pts[*,0], valid)
       if(invalid[0] NE -1) then flags[invalid] = PGS_INVISIBLE_MASK
      end
     plon_ps[i] = $
          pgs_set_points( plon_ps[i], $
		points = points, $
		flags = flags, $
		desc = 'globe_grid_plon', $
		input = pgs_desc_suffix(gbx=gbx[i,0], cd=cd[0]), $
		vectors = plon_inertial_pts )
    end
  end


 ;------------------------------------------------------
 ; crop to fov, if desired
 ;  Note, that one image size is applied to all points
 ;------------------------------------------------------
 if(keyword_set(fov)) then $
  begin
   pg_crop_points, grid_ps, cd=cd[0], slop=slop
   if(keyword_set(cull)) then grid_ps = pgs_cull(grid_ps)
   pg_crop_points, plat_ps, cd=cd[0], slop=slop
   if(keyword_set(cull)) then plat_ps = pgs_cull(plat_ps)
   pg_crop_points, plon_ps, cd=cd[0], slop=slop
   if(keyword_set(cull)) then plon_ps = pgs_cull(plon_ps)
  end



 return, grid_ps
end
;=============================================================================
