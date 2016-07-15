;===========================================================================
; spice_cameras
;
;
;===========================================================================
function spice_cameras, dd, ref, k_in, uk_in, sc=sc, inst=inst, plat=plat, $
		cam_time=cam_time, dt=dt, cam_scale=cam_scale, cam_oaxis=cam_oaxis, $
		cam_exposure=cam_exposure, cam_size=cam_size, $
		cam_fn_focal_to_image=cam_fn_focal_to_image, $
		cam_fn_image_to_focal=cam_fn_image_to_focal, $
		cam_fn_data=cam_fn_data, tol=tol, constants=constants, $
		n_obj=n_obj, dim=dim, status=status, orient=orient, $
                spice_fn = spice_fn, pos=pos, cam_fn_psf=cam_fn_psf, $
                cam_filters=cam_filters, obs=obs,$
                cam_fn_body_to_image=cam_fn_body_to_image,$
                cam_fn_body_to_inertial=cam_fn_body_to_inertial

 if(NOT keyword_set(tol)) then tol = 1d

 status = 0
 n_obj = 1 
 dim = [1]

 cam_name = dat_instrument(dd)

 n_k_in = 0l
 if(NOT keyword_set(k_in)) then k_in = '' $
 else n_k_in = n_elements(k_in)

 n_uk_in = 0l
 if(NOT keyword_set(uk_in)) then uk_in = '' $
 else n_uk_in = n_elements(uk_in)

 pos = long(keyword_set(pos))


 ;--------------------------------------------------------------------
 ; spacecraft position and velocity w.r.t. SS barycenter
 ;--------------------------------------------------------------------
 if(NOT keyword_set(constants)) then $
  begin
   nets=n_elements(cam_time)
   cmats=dblarr(3,3,nets)
   for iet=nets-1,0,-1 do begin
   status = spice_get_cameras(sc, inst, plat, ref, cam_time[iet], tol, $
                                cam_pos, cam_vel, cmat, cam_avel, pos, obs=obs)
   cmats[*,*,iet]=cmat
   endfor
   if (n_elements(*cam_fn_data[0]) gt 0) then (*cam_fn_data[0]).orients=cmats 
   ;- - - - - - - - - - - - - - - - - - - - - -
   ; handle spice errors
   ;- - - - - - - - - - - - - - - - - - - - - -
   if(status NE 0) then $
    begin
     if(keyword_set(orient)) then $
      begin
       cmat = orient
       status = 0
      end $
     else $
      begin
       nv_message, name = 'spice_cameras', /continue, $
                         'Error obtaining camera data for ' + cor_name(dd)
       return, 0
      end
    end

   ;- - - - - - - - - - - - - - - - - - - - - -
   ; validate orientation matrix
   ;- - - - - - - - - - - - - - - - - - - - - -
   if(NOT pos) then $
    if(NOT valid_rotation(cmat)) then $
     begin
      nv_message, name = 'spice_cameras', /continue, $
                    'Invalid C-matrix for ' + cor_name(dd) + '.'
      status = -1
      return, 0
     end
  end


 ;------------------------------
 ; create a camera descriptor
 ;------------------------------
 cd = cam_create_descriptors(n_obj, $
		name=cam_name, $
		orient=cmat, $
		exposure=cam_exposure, $
		avel=cam_avel, $
		pos=cam_pos, $
		vel=cam_vel, $
		time=cam_time, $
		fn_focal_to_image=cam_fn_focal_to_image, $
		fn_image_to_focal=cam_fn_image_to_focal, $
		fn_data=cam_fn_data, $
		scale=cam_scale, $
		fn_psf=cam_fn_psf, $
		filters=cam_filters, $
		size=cam_size, $
		oaxis=cam_oaxis,$
		fn_body_to_image=cam_fn_body_to_image,$
		fn_body_to_inertial=cam_fn_body_to_inertial)

  return, cd
end
;===========================================================================
