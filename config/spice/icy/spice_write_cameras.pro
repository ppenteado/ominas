;===========================================================================
; spice_write_cameras
;
; Assumes all descriptors for the same instrument
;
;===========================================================================
pro spice_write_cameras, dd, ref, ck_file, cd, $
                sc=sc, inst=inst, plat=plat, status=status

 status = 0

 ;-------------------------------
 ; remove ck file if it exists
 ;-------------------------------
 fdelete, ck_file

 ;-------------------------------
 ; extract cd fields
 ;-------------------------------
 cam_exposure = cam_exposure(cd)

 cam_time = bod_time(cd)
 cam_pos = bod_pos(cd)
 cam_vel = bod_vel(cd)
 cam_orient = bod_orient(cd)

 cam_avel = (bod_avel(cd))[0,*]

 cam_name = (dat_instrument(dd))[0]

; spawn, 'echo ' + ck_file, ck_file
; ck_file = ck_file[0]

 comment = cor_udata(cd, 'CK_COMMENT')
 if(NOT keyword_set(comment)) then comment = ' '

 ;-------------------------------
 ; write the kernel
 ;-------------------------------
 nv_message, /verb, 'Writing ' + ck_file
 status = spice_put_cameras(sc, inst, plat, ref, ck_file, comment, $
                        cam_time, cam_exposure, cam_pos, cam_vel, $
                        cam_orient, cam_avel)

; status = call_external(path + 'spice_io.so', 'put_cameras', $
;                        value=[0,0,0,1,1,1, $
;                               0,0,0,0,$
;                               0,0], $
;                        sc, inst, plat, ref, ck_file, comment, $
;                        cam_time, cam_exposure, cam_pos, cam_vel, $
;                        cam_orient, cam_avel)


end
;===========================================================================
