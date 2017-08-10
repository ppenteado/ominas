;=============================================================================
;+
; NAME:
;	render
;
;
; PURPOSE:
;	Performs rendering on an array of bodies.
;
;
; CATEGORY:
;	NV/PG
;
;
; CALLING SEQUENCE:
;	map = render(cd=cd, bx=bx, sund=sund)
;
;
;
; ARGUMENTS:
;  INPUT: NONE
;	image_pts:    Array of the image points defining the grid to be traced.  
;
;  OUTPUT: NONE
;	image_pts:    Array of the image points giving the grid that was traced.  
;
;
; KEYWORDS:
;  INPUT:
;	cd:	      Camera descriptor.
;
;	bx:	      Array of object descriptors; must be a subclass of BODY.
;
;	sund:         Star descriptor for the Sun.
;
;	md:           Array of map descriptors, one for each body.
;
;	ddmap:        Array of data descriptors containing the body maps, 
;	              one for each body.
;
;	sample:       Amount by which to subsample pixels.
;
;	pc_size:      To save memory, the projection is performed in pieces
;	              of this size.  Default is 65536.
;
;	penumbra:     If set, lighting rays are traced to random points on 
;	              each secondary body rather then the center.
;
;	no_secondary: If set, no secondary ray tracing is performed, so 
;	              resulting in no shadows.
;
;
;  OUTPUT: 
;
;
;
; RETURN: 
;	2D array containing the rendered image.
;
;
; PROCEDURE:
;	
;
;
; EXAMPLE:
;
;
; STATUS:
;	Complete
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale
;	
;-
;=============================================================================



;=================================================================================
; map_smoothing_width
;
;  This assume a globe and a rectangular map.  Need a more general way to
;  compute the footprint of a ray in map pixels. 
;
;=================================================================================
function map_smoothing_width, data, i


 bx = data.bx[i]
 md_bx = data.md[i]

 theta = $
    v_mag(bod_pos(data.cd)-bod_pos(bx))*cam_scale(data.cd[0]) $
        / (glb_radii(bx))[0]
    
 tvim, /silent, get_info=tvd
 zoom = max(tvd.zoom)

 smoothing = fix(max(map_size(md_bx)/[!dpi,2d*!dpi] * [theta,theta])) $
                                * map_scale(md_bx) / zoom / data.sample

 return, smoothing * 4
end
;=================================================================================



;=================================================================================
; rdr_photometry
;
;=================================================================================
function rdr_photometry, data, cd, sund, bx, body_pts, no_pht=no_pht

 n = n_elements(body_pts)/3

 if(data.no_pht) then phot = make_array(n, val=1d) $
 else $
  begin
   pht_angles, 0, cd, bx, sund, body_pts=body_pts, emm=mu, inc=mu0, g=g

   refl_fn = sld_refl_fn(bx)
   refl_parm = sld_refl_parm(bx)
   if(NOT keyword_set(refl_fn)) then $
    begin
     refl_fn = 'pht_refl_lunar_lambert'
     refl_parm = [0.5,0.5]
    end

   phase_fn = sld_phase_fn(bx)
   phase_parm = sld_phase_parm(bx)
   if(NOT keyword_set(phase_fn)) then $
    begin
     phase_fn = 'pht_phase_isotropic'
     phase_parm = 0
    end

   refl_corr = call_function(refl_fn, mu, mu0, refl_parm)
   phase_corr = call_function(phase_fn, g, phase_parm)

   albedo = sld_albedo(bx)

   phot = refl_corr*phase_corr*albedo
  end


 return, phot > data.pht_min
end
;=================================================================================



;=================================================================================
; rdr_map
;
;=================================================================================
pro rdr_map, data, piece, bx, md, ddmap, body_pts, phot, ii

 if(keyword_set(ddmap)) then $
  begin
   w = where(cor_name(bx) EQ cor_name(md))
   if(w[0] NE -1) then jj = w[0]
  end

 if(NOT defined(jj)) then piece[ii] = phot $
 else $
  begin
   ww = where(phot NE 0)
   if(ww[0] NE -1) then $
    begin
     www = ii[ww]

     ;- - - - - - - - - - - - - - - -
     ; compute map points
     ;- - - - - - - - - - - - - - - -
     im_pts_map = body_to_image_pos(md[jj], bx, body_pts[www,*])

     ;- - - - - - - - - - - - - - - -
     ; sample map
     ;- - - - - - - - - - - - - - - -
;     map_smoothing_width = rdr_map_smoothing_width(data, ii)
map_smoothing_width=1

     map = dat_data(ddmap[jj])

     dat = image_interp_cam(cd=md[jj], map, interp='sinc', $
               im_pts_map[0,*], im_pts_map[1,*], {k:4,fwhm:map_smoothing_width})

     ;- - - - - - - - - - - - - - - - - - - - - - - - -
     ; replace unmapped samples with map average
     ;- - - - - - - - - - - - - - - - - - - - - - - - -
     w = where(dat EQ 0)
     if(w[0] NE -1) then dat[w] = mean(map)

     ;- - - - - - - - - - - - - - - -
     ; apply photometry
     ;- - - - - - - - - - - - - - - -
     piece[www] = dat * phot
    end
  end
end
;=================================================================================



;=================================================================================
; rdr_piece
;
;=================================================================================
function rdr_piece, data, image_pts

 bx = data.bx
 md = data.md
 ddmap = data.ddmap
 cd = data.cd
 sund = data.sund

 np = n_elements(image_pts)/2
 piece = dblarr(np)


 ;---------------------------------------------
 ; trace primary rays from camera
 ;---------------------------------------------
 raytrace, image_pts, cd=cd, bx=bx, $
	show=data.show, standoff=data.standoff, limit_source=data.limit_source, $
	hit_list=hit_list, hit_indices=hit_indices, hit_matrix=hit_matrix, $
        near_matrix=near_matrix, far_matrix=far_matrix, $
        range_matrix=range_matrix
 if(hit_list[0] EQ -1) then return, piece


 ;---------------------------------------------
 ; trace secondary rays to sun
 ;---------------------------------------------
 sec_hit_indices = hit_indices
 sec_hit_matrix = hit_matrix
 sec_hit_list = hit_list
 if(data.no_secondary) then sec_hit_list = -1

 if(sec_hit_list[0] NE -1) then $
   raytrace, bx=bx, sbx=sund, penumbra=data.penumbra, $
	show=data.show, standoff=data.standoff, limit_source=data.limit_source, $
	hit_list=sec_hit_list, hit_indices=sec_hit_indices, hit_matrix=sec_hit_matrix, $
        near_matrix=sec_near_matrix, far_matrix=sec_far_matrix, $
        range_matrix=sec_range_matrix


 ;---------------------------------------------------------------------------
 ; remove primary hits whose sunward secondaries hit other bodies 
 ;---------------------------------------------------------------------------
 if(sec_hit_list[0] NE -1) then $
  begin
   w = where(sec_hit_indices NE -1)
   if(w[0] NE -1) then hit_indices[w] =-1
  end


 ;---------------------------------------------
 ; map surfaces
 ;---------------------------------------------
 for i=0, n_elements(hit_list)-1 do $
  begin
   ii = hit_list[i]
   w = where(hit_indices EQ ii)
   nw = n_elements(w)
   if(w[0] NE -1) then $
    begin
     if(data.show) then plots, image_pts[*,w], psym=3, col=ctorange()

     ;- - - - - - - - - - - - - - - - - - - - - - - - - -
     ; photometry
     ;- - - - - - - - - - - - - - - - - - - - - - - - - -
     phot = rdr_photometry(data, cd, sund, bx[ii], hit_matrix[w,*])

     ;- - - - - - - - - - - - - - - - - - - - - - - - - -
     ; map
     ;- - - - - - - - - - - - - - - - - - - - - - - - - -
     rdr_map, data, piece, bx[ii], md, ddmap, hit_matrix, phot, w
    end
  end


 return, piece
end
;=================================================================================



;=================================================================================
; render
;
;=================================================================================
function render, image_pts, cd=cd, sund=sund, $
  bx=bx, ddmap=ddmap, md=md, sample=sample, pc_size=pc_size, $
  show=show, pht_min=pht_min, no_pht=no_pht, $
  standoff=standoff, limit_source=limit_source, penumbra=penumbra, $
  no_secondary=no_secondary

 nbx = n_elements(bx)
 if(NOT keyword_set(no_secondary)) then no_secondary = 0
 if(NOT keyword_set(penumbra)) then penumbra = 0
 if(NOT keyword_set(pht_min)) then pht_min = 0

 if(NOT defined(limit_source)) then limit_source = 0
 if(NOT defined(standoff)) then standoff = 1

 if(NOT keyword_set(sund)) then $
  begin
   sund = 0
   no_secondary = (no_pht = 1)
  end

 show = keyword_set(show)
 if(NOT keyword_set(sample)) then sample = 1
 sample = double(sample)

 if(NOT keyword_set(pc_size)) then pc_size = 65536

 if(NOT keyword_set(ddmap)) then ddmap = objarr(nbx)
 if(NOT keyword_set(md)) then md = objarr(nbx)


 if(nbx EQ 0) then bx = 0
 data = { $
		cd		:	cd, $
		sund		:	sund, $
		bx		:	bx, $
		ddmap		:	ddmap, $
		md		:	md, $
		sample		:	sample, $
		no_secondary	:	no_secondary, $
		penumbra	:	penumbra, $
		limit_source	:	limit_source, $
		standoff	:	standoff, $
		pht_min		:	pht_min, $
		no_pht		:	keyword_set(no_pht), $
		show		:	show $
	}


 map_size = n_elements(image_pts)/2
 pc_size = long(pc_size<map_size)
 npc = map_size/pc_size
 if(map_size mod pc_size NE 0) then npc = npc + 1

 sample2 = sample*sample

 ;----------------------------------------
 ; perform ray tracing piece-by-piece
 ;----------------------------------------
 map = dblarr(map_size)
 for i=0, npc-1 do $
  begin
   ;------------------------------------
   ; determine the size of this piece
   ;------------------------------------
   size = pc_size
   if(i EQ npc-1) then size = map_size - (npc-1)*pc_size

   ;------------------------------------
   ; resample this grid piece
   ;------------------------------------
   ;- - - - - - - - - - - - - - - - - - - 
   ; get master grid for this piece
   ;- - - - - - - - - - - - - - - - - - - 
   ii = lindgen(pc_size) + i*pc_size
   pc_image_pts = double(image_pts[*,ii])

   ;- - - - - - - - - - - - - - - - - - - 
   ; create subsampled grid
   ;- - - - - - - - - - - - - - - - - - - 
   if(show) then plots, pc_image_pts, psym=1, col=ctred()

   dxy = gridgen([sample, sample], /double, /center)/sample
   dxy = dxy[linegen3z(2,sample2,pc_size)]
   dxy = transpose(dxy, [0,2,1])

   pc_image_pts = pc_image_pts[linegen3z(2,pc_size,sample2)]
   pc_image_pts = reform(pc_image_pts + dxy, 2,sample2*pc_size)

   if(show) then plots, pc_image_pts, psym=3, col=ctgreen()

   ;- - - - - - - - - - - - - - - - - - - 
   ; trace this piece
   ;- - - - - - - - - - - - - - - - - - - 
   if(show) then $
    begin
     device, set_graphics=6
     plots, pc_image_pts, psym=3, col=ctgray(0.25)
     device, set_graphics=3
    end
   piece = rdr_piece(data, pc_image_pts)

   ;- - - - - - - - - - - - - - - - - - - - - 
   ; average over samples and add to map
   ;- - - - - - - - - - - - - - - - - - - - -
   piece = reform(piece, pc_size, sample2, /over)
   piece = total(piece,2)/(sample2)

   map[ii] = piece
  end


 return, map
end
;=================================================================================








pro test
; grim ~/casIss/1350/N1350122987_2.IMG over=planet_center,ring
; grim ~/casIss/1460/N1460090980_1.IMG over=planet_center,ring
; grim ~/casIss/1444/N1444735589_1.IMG over=planet_center,ring
; grim ~/casIss/1669/N1669801856_1.IMG over=planet_center

 grift, dd=dd, cd=cd, pd=pd, rd=rd, sund=sund
 bx = append_array(pd, rd)
 dd_render = pg_render(/show, cd=cd, bx=bx, sund=sund, pht=0.02, /psf, /pen, sample=2, mask=0)

 grim, dd_render, /new, cd=cd, pd=pd, rd=rd, sund=sund

end
