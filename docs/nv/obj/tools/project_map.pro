;=============================================================================
;+
; NAME:
;       project_map
;
;
; PURPOSE:
;       Reprojects images.
;
;
; CATEGORY:
;       NV/LIB/TOOLS
;
;
; CALLING SEQUENCE:
;       result = project_map(image, md=md, cd=cd, bx=bx, sund=sund, $
;                            pc_xsize, pc_ysize, $
;                            hide_fn=hide_fn, hide_data_p=hide_data_p)
;
; ARGUMENTS:
;  INPUT:
;          image:     Array (xsize,ysize,nplanes) giving the image(s) to
;		      reproject.
;
;       pc_xsize:     x size of map workspace
;
;       pc_ysize:     y size of map workspace
;
;	bounds:	      Projection bounds specified as [lat0, lat1, lon0, lon1].
;
;
;  OUTPUT:
;       NONE
;
; KEYWORDS:
;  INPUT:
;	md:	Map descriptor.
;
;	cd:	Camera descriptor.
;
;	bx:	Body descriptor.  If two descriptors given, then the
;		first is used with the cd input and the second is used with 
;		the map input.
;
;	sund:	Star descriptor for the sun.  If not given, the dark side
;		is mapped.  If two descriptors given, then the
;		first is used with the cd input and the second is used with 
;		the map input.
;
;	hide_fn:	Array of hide functions, e.g. 'pm_hide_ring'
;
;	hide_data_p:	Array of hide data pointers, e.g. nv_ptr_new(rd)
;
;	offset:	Offset in [lat,lon] to apply to map coordinates before 
;		projecting.
;
;	interp:	Type of interpolation, see image_interp_cam.
;
;	arg_interp:	Interpolation argument, see image_interp_cam.
;
;	roi:	Subscripts in the output map specifying the map region
;		to project, instead of the whole thing.
;
;	edge:	Number of pixels to exclude from edge of the input image.
;
;	smooth:	If set, the input image is smoothed before reprojection.
;
; OUTPUT:
;	NONE
;
;
; RETURN:
;       Array (xsize,ysize,nplanes) giving the reprojected image(s).
;
;
; MODIFICATION HISTORY:
;       Written by:     Spitale, 6/1998
;
;-
;=============================================================================



;=============================================================================
; pm_hide_ring
;
;=============================================================================
function pm_hide_ring, rd, map_image_pts, cam_image_pts, surface_pts, body_pts, pos_cam
 n = n_elements(rd)
 for i=0, n-1 do sub = append_array(sub, dsk_hide_points(rd[i], pos_cam, body_pts))
 return, sub

; return, dsk_hide_points(rd, pos_cam, body_pts)
end
;=============================================================================



;=============================================================================
; pm_hide_globe
;
;=============================================================================
function pm_hide_globe, xd, map_image_pts, cam_image_pts, surface_pts, body_pts, pos_cam

 nxd = n_elements(xd)

 pd = xd[0]
 if(nxd EQ 1) then r = pos_cam $
 else r = bod_inertial_to_body_pos(pd, bod_pos(xd[1]))

 return, glb_hide_points(pd, r, body_pts)
end
;=============================================================================



;=============================================================================
; pm_rm_globe_shadow
;
;=============================================================================
function pm_rm_globe, xd, map_image_pts, cam_image_pts, surface_pts, body_pts, pos_cam

 cd = xd[0]
 pd = xd[1]
 rd = xd[2]
 sund = xd[3]


 nxd = n_elements(xd)

 pd = xd[0]
 if(nxd EQ 1) then r = pos_cam $
 else r = bod_inertial_to_body_pos(pd, bod_pos(xd[1]))

 return, glb_hide_points(pd, r, body_pts, /rm)
end
;=============================================================================



;=============================================================================
; pm_rm_globe
;
;=============================================================================
function pm_rm_globe, xd, map_image_pts, cam_image_pts, surface_pts, body_pts, pos_cam

 nxd = n_elements(xd)

 pd = xd[0]
 if(nxd EQ 1) then r = pos_cam $
 else r = bod_inertial_to_body_pos(pd, bod_pos(xd[1]))

 return, glb_hide_points(pd, r, body_pts, /rm)
end
;=============================================================================



;=============================================================================
; pm_bounds
;
;=============================================================================
function pm_bounds, bounds, surface_pts

 lat0 = bounds[0]
 lat1 = bounds[1]
 lon0 = bounds[2]
 lon1 = bounds[3]

; w = where( ( (surface_pts[*,0] GE lat0) AND (surface_pts[*,0] LE lat1) ) $
;        AND ( (surface_pts[*,1] GT lon0) AND (surface_pts[*,1] LT lon1) ) )

 w = where( (surface_pts[*,0] GE lat0) AND (surface_pts[*,0] LE lat1) $
             AND (surface_pts[*,1] GT lon0) AND (surface_pts[*,1] LT lon1) )

 return, w
end
;=============================================================================



;=============================================================================
; pm_hide_points_limb
;
;=============================================================================
function pm_hide_points_limb, bx, pos_cam, body_pts

 if(cor_isa(bx, 'GLOBE')) then return, glb_hide_points_limb(bx, pos_cam, body_pts)
; return, 
 return, -1
end
;=============================================================================



;=============================================================================
; pm_wind_zonal
;
;  wind_data must contain the following fields:
;
;   vel:	Wind speeds as a function of latitude.  Assumed to be 
;		uniformly-gridded, spanning the entire globe, with an 
;		entry for each pole.
;   dt:		Time over which to integrate velocities
;
;=============================================================================
function pm_wind_zonal, bx, map_pts, wind_data

 dt = wind_data.dt
 vel = wind_data.vel
 n = n_elements(vel)

 lat = map_pts[0,*]
 lon = map_pts[1,*]

 _lat = (2d*dindgen(n)/(n-1) - 1d) * !dpi/2d
 vlat = interpol(vel, _lat, lat, /quad)

 wlat = vlat / (glb_radii(bx))[0]

 lon = lon + dt*wlat
 map_pts[1,*] = lon

 return, map_pts
end
;=============================================================================



;=============================================================================
; pm_wind_kepler
;
;  wind_data must contain the following fields:
;
;   gbx:	Descriptor for central planet
;   dt:		Time over which to integrate velocities
;
;=============================================================================
function pm_wind_kepler, bx, map_pts, wind_data

 dt = wind_data.dt
 gbx = wind_data.gbx

 rad = map_pts[0,*]
 lon = map_pts[1,*]

 dlondt = orb_compute_dmldt(bx, gbx, sma=rad)

 lon = lon + dt*dlondt
 map_pts[1,*] = lon

 return, map_pts
end
;=============================================================================



;=============================================================================
; project_map
;
;=============================================================================
function project_map, image, md=md, cd=cd, bx=bx, sund=sund, $
                      _pc_xsize, _pc_ysize, bounds=bounds, hit=hit, value=value, $
                      hide_fn=hide_fn, hide_data_p=hide_data_p, roi=roi, $
                      interp=interp, arg_interp=arg_interp, offset=offset, $
                      wind_fn=wind_fn, wind_data=wind_data, edge=edge, smooth=smooth

 n_hide = n_elements(hide_fn)
 if(NOT keyword_set(offset)) then offset = [0d,0d]
 if(NOT keyword_set(smooth)) then smooth = 0
 if(NOT keyword_set(edge)) then edge = 0
 if(keyword_set(_pc_xsize)) then pc_xsize = _pc_xsize
 if(keyword_set(_pc_ysize)) then pc_ysize = _pc_ysize

 edge = edge > smooth

 ;======================================
 ; sort out descriptors
 ;======================================
 if(keyword_set(bx)) then bx_cam = (bx_map = bx[0])
 if(n_elements(bx) EQ 2) then $
  begin
   bx_cam = bx[0]
   bx_map = bx[1]
  end

 if(keyword_set(sund)) then sund_cam = (sund_map = sund[0])
 if(n_elements(sund) EQ 2) then $
  begin
   sund_cam = sund[0]
   sund_map = sund[1]
  end


 ;=========================
 ; get map parameters
 ;=========================
 map_size = image_size(md)
 map_xsize = long(map_size[0])
 map_ysize = long(map_size[1])

 ;=========================
 ; allocate the map
 ;=========================
 s = size(image)
 image_xsize = long(s[1])
 image_ysize = long(s[2])
 image_zsize = 1
 if(s[0] EQ 3) then image_zsize = s[3]
 type = s[s[0]+1]
 map = degen(make_array(map_xsize, map_ysize, image_zsize, type=type))

 if(keyword_set(roi)) then if(roi[0] NE -1) then $
                          roixy = w_to_xy(0, roi, sx=map_xsize, sy=map_ysize)

 ;================================
 ; construct the map in pieces
 ;================================
 pc_xsize = pc_xsize < map_xsize
 pc_ysize = pc_ysize < map_ysize

 pc_nx = map_xsize/pc_xsize
 pc_ny = map_ysize/pc_ysize
 if(map_xsize mod pc_xsize NE 0) then pc_nx = pc_nx + 1 
 if(map_ysize mod pc_ysize NE 0) then pc_ny = pc_ny + 1 

 pc_xsize = long(pc_xsize)
 pc_ysize = long(pc_ysize)

 for j=0, pc_ny-1 do $
  for i=0, pc_nx-1 do $
   begin
    ;------------------------------------
    ; determine the size of this piece
    ;------------------------------------
    xsize = pc_xsize
    ysize = pc_ysize
    if(i EQ pc_nx-1) then xsize = map_xsize - (pc_nx-1)*pc_xsize
    if(j EQ pc_ny-1) then ysize = map_ysize - (pc_ny-1)*pc_ysize
    n = xsize*ysize

    ;------------------------------------
    ; construct pixel grid on this piece
    ;------------------------------------
    x0 = i*pc_xsize & y0 = j*pc_ysize

    map_image_pts = dblarr(2,n, /nozero)
    map_image_pts[0,*] = $
        reform((dindgen(xsize) + double(x0))#make_array(ysize,val=1), n, /over)
    map_image_pts[1,*] = $
        reform((dindgen(ysize) + double(y0))##make_array(xsize,val=1), n, /over)

    if(keyword_set(roixy)) then $
     begin
      w = in_image(0, roixy, $
              xmin=x0, xmax=x0+pc_xsize-1, $
              ymin=y0, ymax=y0+pc_ysize-1, $
              slop = 0)
      if(w[0] EQ -1) then map_image_pts = 0 $
      else $
       begin
        pc_roixy = roixy[*,w]
        pc_roixy[0,*] = pc_roixy[0,*] - x0
        pc_roixy[1,*] = pc_roixy[1,*] - y0
        pc_roi = xy_to_w(0, pc_roixy, sx=pc_xsize, sy=pc_ysize)
        map_image_pts = map_image_pts[*,pc_roi]
        n = n_elements(pc_roi)
       end
     end


    if(keyword_set(map_image_pts)) then $
     begin
      ;---------------------------------------------------
      ; convert pixel coordinates to map coordinates
      ;---------------------------------------------------
      map_pts = image_to_map(md, map_image_pts, bx=bx_map, valid=valid)
      invalid = complement(map_image_pts[0,*], valid)

      if(keyword_set(map_pts)) then $
       begin
        map_pts[0,*] = map_pts[0,*] + offset[0]
        map_pts[1,*] = map_pts[1,*] + offset[1]

        ;--------------------------
        ; apply wind function
        ;--------------------------
        if(keyword_set(wind_fn)) then $
             map_pts = call_function('pm_wind_'+wind_fn, bx_map, map_pts, wind_data)

        ;----------------------------------------------
        ; compute projection
        ;----------------------------------------------
        map_image_pts = 0
        if(valid[0] NE -1) then $
         begin
          surface_pts = map_to_surface(md, bx_map, map_pts)
          map_pts = 0

          ;-----------------------------------
          ; test bounds
          ;-----------------------------------
          cont = 1
          if(keyword_set(bounds)) then $
           begin
            bounds_sub = pm_bounds(bounds, surface_pts)
            cont = 0
            if(bounds_sub[0] NE -1) then $
             begin
              surface_pts = surface_pts[bounds_sub,*]
              cont = 1
             end
           end $
          else bounds_sub = lindgen(n)

          if(cont) then $
           begin
            ;-----------------------------------
            ; compute source image coordinates
            ;-----------------------------------
            cam_image_pts = $
              surface_to_image(cd, bx_cam, surface_pts, $
                                                body_pts=body_pts, valid=_valid)
            _invalid = complement(surface_pts[*,0], _valid)
 ;          if(arg_present(hit)) then hit = append_array(hit, $
 ;                 xy_to_w([image_xsize, image_ysize], w_to_xy([pc_xsize, pc_ysize], _valid)))


            ;----------------------------------------------------------------
            ; determine indices of points to exclude from the projection
            ;----------------------------------------------------------------
            sub = -1
            if(cor_class(cd) NE 'MAP') then if(keyword_set(bx_cam)) then $
             begin
              pos_cam = bod_inertial_to_body_pos(bx_cam, bod_pos(cd))

              ;- - - - - - - - - - - - - - - - - - - - - - -
              ; points behind the limb
              ;- - - - - - - - - - - - - - - - - - - - - - -
              limb_sub = pm_hide_points_limb(bx_cam, pos_cam, body_pts)
              sub = append_array(sub, limb_sub)

              ;- - - - - - - - - - - - - - - - - - - - - - -
              ; points behind the terminator
              ;- - - - - - - - - - - - - - - - - - - - - - -
              if(keyword_set(sund_cam)) then $
               begin
                pos_sun = bod_inertial_to_body_pos(bx_cam, bod_pos(sund_cam))
                term_sub = pm_hide_points_limb(bx_cam, pos_sun, body_pts)
                sub = append_array(sub, term_sub)
               end

              ;- - - - - - - - - - - - - - - - - - - - - - -
              ; user-specific hide functions
              ;- - - - - - - - - - - - - - - - - - - - - - -
              for k=0, n_hide-1 do $
               begin
                user_sub = -1
                user_sub = call_function(hide_fn[k], *hide_data_p[k], $
                            map_image_pts, cam_image_pts, surface_pts, body_pts, pos_cam)
                sub = append_array(sub, user_sub)
               end
              surface_pts = 0
              body_pts = 0
             end

            ;- - - - - - - - - - - - - - - - - - - - - - -
            ; points outside the input image
            ;- - - - - - - - - - - - - - - - - - - - - - -
            ex_sub = $
             external_points(cam_image_pts, edge, image_xsize-1-edge, $
                                                   edge, image_ysize-1-edge)
            sub = append_array(sub, ex_sub)

            ;- - - - - - - - - - - - - - - - - - - - - - -
            ; points that map to nothing in the output
            ;- - - - - - - - - - - - - - - - - - - - - - -
            sub = append_array(sub, invalid)

            ;- - - - - - - - - - - - - - - - - - - - - - -
            ; points that map to nothing in the input
            ;- - - - - - - - - - - - - - - - - - - - - - -
            sub = append_array(sub, _invalid)

            w = where(sub EQ -1)
            if(w[0] NE -1) then sub = rm_list_item(sub, w, only=-1)


            ;------------------------------
            ; build the map for this piece
            ;------------------------------
            pc_sub = complement(bounds_sub, sub)
            if(pc_sub[0] NE -1) then $
             begin
              cam_image_pts = cam_image_pts[*,pc_sub]
              bounds_sub = bounds_sub[pc_sub]

              for ii=0, image_zsize-1 do $
               begin
                if(keyword_set(smooth)) then image[*,*,ii] = smooth(image[*,*,ii], smooth)
                if(keyword_set(value)) then dat = value $
                else dat = image_interp_cam(cd=cd, image[*,*,ii], interp=interp, $
                                       cam_image_pts[0,*], cam_image_pts[1,*], arg_interp, /zmask)
                pc_map = make_array(xsize, ysize, type=type)

                if(NOT keyword_set(roixy)) then pc_map[bounds_sub] = dat $
                else pc_map[pc_roi[bounds_sub]] = dat

                w = where(finite(pc_map) EQ 0)
                if(w[0] NE -1) then pc_map[w] = 0

                ;------------------------------
                ; insert into the main map
                ;------------------------------
                map[x0:x0+xsize-1, y0:y0+ysize-1, ii] = pc_map
               end
             end
           end
         end
       end
     end
   end



 for k=0, n_hide-1 do nv_ptr_free, hide_data_p[k]
 
; w = where(map NE 0)
; if(w[0] EQ -1) then return, 0

 return, map
end
;=============================================================================

