;=============================================================================
;+
; NAME:
;	raytace
;
;
; PURPOSE:
;	Traces rays from a camera to a set of objects.
;
;
; CATEGORY:
;	NV/PG
;
;
; CALLING SEQUENCE:
;	raytrace, image_pts, cd=cd, bx=bx		; For primary rays
;		hit_matrix=hit_matrix, $
;		hit_indices=hit_indices, $
;		range_matrix=range_matrix, hit_list=hit_list
;
;	raytrace, bx=bx, sbx=sbx, $			; For secondary rays
;		hit_matrix=hit_matrix, $
;		hit_indices=hit_indices, $
;		range_matrix=range_matrix, hit_list=hit_list
;
;
; ARGUMENTS:
;  INPUT: 
;	image_pts:  Array (2,np) of image points relative to cd.  These
;	            points will be turned into rays to be traced from the 
;	            position of the camera.
;
;  OUTPUT: NONE
;
;
; KEYWORDS:
;  INPUT:
;	cd:	       Camera descriptor.
;
;	bx:	       Array of object descriptors; must be a subclass of BODY.
;
;	sbx:           Body descriptor for secondary ray tracing.  If set, 
;	               image_pts and cd are not used; instead, secondary rays 
;	               are traced from the given hit_matrix points to sbx.
;
;	hit_matrix:    Body-frame points from prior call, to be used as
;	               source points for secondary rays.  
;
;	hit_indices:   Body index for each secondary ray.
;
;	limit_source : If set, secondary vectors originating on a given
;	               body are not considered for targets that are the
;	               same body.  Default is off.
;
;	standoff:      If given, secondary vectors are advanced by this distance
;	               before tracing in order to avoid hitting target bodies
;	               through round-off error.  Default is 1 unit.
;
;	penumbra:      If set, lighting rays are traced to random points on 
;	               each secondary body rather then the center.
;
;
;
;  OUTPUT: 
;	hit_list:     Array (nhit) giving indices of all bx that have ray 
;	              intersections.  
;
;	hit_indices:  Array (nray) of body indices corresponding to the first 
;	              intersection for each ray.  
;
;	hit_matrix:   Array (nray,3,nhit) of body-frame points for nearest 
;	              ray intersections. 
;
;	range_matrix: Array (nhit,nray) giving distance to the near-side
;	              ray intersection for each body in the hit_matrix.  
;
;	far_matrix:   Array (nray,3,nhit) of body-frame points for all
;	              far-side intersections with bodies in the hit_list.
;
;	near_matrix:   Array (nray,3,nhit) of body-frame points for all
;	               near-side intersections with bodies in the hit_list.
;
;
; RETURN: NONE
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
pro raytrace, image_pts, cd=cd, bx=all_bx, sbx=sbx, $
               hit_matrix=hit_matrix, show=show, penumbra=penumbra, $
               hit_indices=hit_indices, range_matrix=range_matrix, hit_list=hit_list, $
               far_matrix=far_matrix, near_matrix=near_matrix, $
               back=back, standoff=standoff, limit_source=limit_source

 show = keyword_set(show)
 if(NOT keyword_set(all_bx)) then return
 bx = all_bx
 nbx = n_elements(bx)

 hit_list = -1

 if(NOT defined(standoff)) then standoff = 1d
 if(NOT defined(limit_source)) then limit_source = 0

 ;---------------------------------------------
 ; set up primary trace
 ;---------------------------------------------
 if(keyword_set(cd)) then $
  begin
   nray = n_elements(image_pts)/2l
   MM = make_array(nray,val=1d)

   vv = bod_pos(cd)##MM
   rr = image_to_inertial(cd, image_pts)

   select = lindgen(nray)
  end $
 ;---------------------------------------------
 ; set up secondary trace
 ;---------------------------------------------
 else if(keyword_set(sbx)) then $
  begin
   ;- - - - - - - - - - - - - - - - - - - - -
   ; compute rays to secondary center
   ;- - - - - - - - - - - - - - - - - - - - -
   w = where(hit_indices NE -1)
   if(w[0] EQ -1) then return
   select = w
   nselect = n_elements(select)

   nray = n_elements(hit_indices)
   MM = make_array(nray,val=1d)
   sbx_pos = bod_pos(sbx)##MM 

   vv = dblarr(nray,3)
   rr = dblarr(nray,3)

   ;- - - - - - - - - - - - - - - - - 
   ; compute sources
   ;- - - - - - - - - - - - - - - - - 
   for i=0, nbx-1 do $
    begin
     w = where(hit_indices EQ i)
     if(w[0] NE -1) then $
             vv[w,*] = bod_body_to_inertial_pos(bx[i], hit_matrix[w,*])
    end

   ;- - - - - - - - - - - - - - - - - 
   ; compute termini
   ;- - - - - - - - - - - - - - - - - 
   rr[select,*] = v_unit(sbx_pos[select,*] - vv[select,*])

   ;- - - - - - - - - - - - - - - - - - - - -
   ; scramble rays for penumbra  
   ;- - - - - - - - - - - - - - - - - - - - -
   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   ; This is a temporary hack that assumes sbx is a sphere.  
   ; Need a good way to find random points on an arbitrary body.
   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   if(keyword_set(penumbra)) then $
    begin
     MMn = make_array(nselect,val=1d)
     MM3 = make_array(3,val=1d)

     rsbx = (glb_radii(sbx))[0]  
     r = (randomu(seed, nselect) * rsbx)#MM3
     theta = (randomu(seed, nselect) * 2d*!dpi)#MM3

     zz = rr[select,*]
     xx = v_cross(zz, tr([0,0,1d])##MMn)
     yy = v_cross(zz, xx)

     sbx_pos[select,*] = sbx_pos[select,*] + r*cos(theta)*xx + r*sin(theta)*yy
    end

   src_hit_indices = hit_indices
  end $
 else nv_message, name='raytrace', 'Either cd or sbx must be specified. '


 ;---------------------------------------------
 ; Trace bodies
 ;---------------------------------------------
;hit_matrix = 0
;range_matrix =0

 hit_matrix = dblarr(nray,3)
 far_matrix = dblarr(nray,3)
 range_matrix = make_array(nray, val=1d100)
 hit_indices = make_array(nray,val=-1)

 v = dblarr(nray,3)
 r = dblarr(nray,3)
 hits = dblarr(nray,3)
 fhits = dblarr(nray,3)
 mark = bytarr(nray)

 ;- - - - - - - - - - - - - - - - - - -
 ; check each body
 ;- - - - - - - - - - - - - - - - - - -
 for i=0, nbx-1 do $
  begin
   mark[select] = 1

   ;- - - - - - - - - - - - - - - - - - - - - - - - - - - - -
   ; deselect rays originating on this target
   ;- - - - - - - - - - - - - - - - - - - - - - - - - - - - -
   if(keyword_set(limit_source)) then $
    if(keyword_set(src_hit_indices)) then $
     begin 
      w = where(src_hit_indices EQ i)
      if(w[0] NE -1) then mark[w] = 0
     end

   ii = where(mark NE 0)

   ;- - - - - - - - - - - - - - - - - - - - - - - - - - - - -
   ; find the intersections
   ;- - - - - - - - - - - - - - - - - - - - - - - - - - - - -
   if(ii[0] NE -1) then $
    begin
     ;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
     ; convert rays to target body frame
     ;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
     v[ii,*] = bod_inertial_to_body_pos(bx[i], vv[ii,*])
     r[ii,*] = bod_inertial_to_body(bx[i], rr[ii,*])

     ;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
     ; advance secondary source vectors by a small amount to
     ; avoid round-off intersections with that source body
     ;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
     if(keyword_set(sbx)) then $
        if(keyword_set(standoff)) then v[ii,*] = v[ii,*] + r[ii,*]*standoff

     ;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
     ; trace the rays
     ;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
     fbx = 0
     if(cor_isa(bx[i], 'DISK')) then $
      begin
       fbx = get_primary(bx[i], all_bx)
       if(NOT keyword_set(fbx)) then nv_message, name='raytrace', $
                              'No primary descriptor for ' + cor_name(bx[i])
      end

     p = surface_intersect(bx[i], frame_bd=fbx, $
                             v[ii,*], r[ii,*], hit=hit, near=near, far=far)
     hits[ii,*] = near
     fhits[ii,*] = far

     ;- - - - - - - - - - - - - - - - - - - - - - - - - -
     ; add closest result to intercept map
     ;- - - - - - - - - - - - - - - - - - - - - - - - - -
     if(hit[0] NE -1) then $
      begin
       hit = ii[hit]



;       range = v_mag(v - hits)
;       xhit = complement(range, hit)
;       if(xhit[0] NE -1) then range[xhit] = 1d100

;       hit_list = append_array(hit_list, i, /pos)
;       hit_matrix = $
;         append_array(hit_matrix, reform(hits, 1,3,nray,/over))
;       range_matrix = $
;               append_array(range_matrix, reform(range, 1,nray, /over))





       range = v_mag(v[hit,*] - hits[hit,*])
       ww = where(range LT range_matrix[hit])

       if(ww[0] NE -1) then $
        begin
         hit_matrix[hit[ww],*] = hits[hit[ww],*]
         far_matrix[hit[ww],*] = fhits[hit[ww],*]
         hit_indices[hit[ww]] = i
         hit_list = append_array(hit_list, i, /pos)
         range_matrix[hit[ww]] = range[ww]
        end


      end
    end
  end

;if(keyword_set(hit_matrix)) then $
;                            hit_matrix = transpose(hit_matrix)

end
;=================================================================================
