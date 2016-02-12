;===========================================================================
;+
; NAME:
;       dh_camera
;
;
; PURPOSE:
;	In conjunction with the detached header routine, write out
;	camera parameters.
;
;
; CATEGORY:
;       UTIL/SPICE
;
;
; CALLING SEQUENCE:
;       dh_camera, dh, label, et, c_matrix
;
;
; ARGUMENTS:
;  INPUT:
;             dh:     Detached header name
;	   label:     Vicar label from image
;	      et:     Ephemeris time
;	c_matrix:     C-matrix from SPICE
;
;
;  OUTPUT:
;       NONE
;
; KEYWORDS:
;  INPUT:
;       NONE
;
;  OUTPUT:
;       NONE
;
;
;
; STATUS:
;       Completed.
;
;
; MODIFICATION HISTORY:
;       Written by:     Haemmerle 12/2000
;-
;=============================================================================
pro dh_camera, dh, label, et, c_matrix

 ;-------------------------------
 ; name - array(nobj)
 ;-------------------------------
 cam__name = vicgetpar(label, 'INSTRUMENT_ID')
 if(cam__name NE 'ISSNA' AND cam__name NE 'ISSWA') then $
   nv_message, name='dh_camera', 'Bad camera name'
 cam__name = 'CAS_' + cam__name

 ;----------------------------------
 ; orientation - array(3,3,nobj)
 ;----------------------------------
;   reverse = [ [-1d, 0d, 0d], [0d, -1d, 0d], [0d, 0d, 1d] ]; Flip 180 degrees

;   jpl_n_to_j2000 = transpose(c_matrix)

;Transpose
   cam_to_j2000 = reform(c_matrix, 3, 3)
   cam_to_j2000 = transpose(cam_to_j2000)

; swap axes 1 and 2 for nv
   nv_to_j2000 = cam_to_j2000
   nv_to_j2000[1,*] = cam_to_j2000[2,*]
   nv_to_j2000[2,*] = cam_to_j2000[1,*] 
   cam__orient = nv_to_j2000
;print, 'cam_orient='
;print, cam__orient

 ;--------------------------------------
 ; angular velocity - array(ndv,3,nobj)
 ;--------------------------------------
 cam__avel=tr([0.0, 0.0, 0.0])
;print, 'cam_avel=',cam__avel

 ;-------------------------------
 ; position - array(1,3,nobj)
 ;-------------------------------
 cam__pos=tr([0.0, 0.0, 0.0])
;print, 'cam_pos=',cam__pos

 ;--------------------------------
 ; velocity - array(ndv,3,nobj)
 ;--------------------------------
 cam__vel=tr([0.0, 0.0, 0.0])
;print,'cam_vel=',cam__vel

 ;----------------------
 ; time - array(nobj)   (ephemeris time, secs past 2000)
 ;----------------------
 cam__time=et
;print,'cam_time=',cam__time

 ;---------------------------------
 ; fn_focal_to_image - array(nobj)
 ;---------------------------------
 cam__fn_focal_to_image='cam_focal_to_image_linear'
;print, 'cam_fn_focal_to_image=',cam__fn_focal_to_image

 ;---------------------------------
 ; fn_image_to_focal - array(nobj)
 ;---------------------------------
 cam__fn_image_to_focal='cam_image_to_focal_linear'
;print,'cam_fn_image_to_focal=',cam__fn_image_to_focal

 ;---------------------------------
 ; fn_data - array(nobj)
 ;---------------------------------
; cam__fn_data=nv_ptr_new()


 ;-----------------------
 ; scale - array(2,nobj)
 ;-----------------------
 cam__scale=[0.,0.]
 ; NAC size = 12micrometer/(2000.00mm x 1000micrometer/mm)
 if(cam__name EQ 'CAS_ISSNA') then cam__scale=[6e-06,6e-06]
 ; WAC size = 12micrometer/(200.22mm x 1000micrometer/mm)
 if(cam__name EQ 'CAS_ISSWA') then cam__scale=[5.9934e-05,5.9934e-05]
 mode = vicgetpar(label, 'INSTRUMENT_MODE_ID') 
 if(mode EQ 'SUM2') then cam__scale = cam__scale*2d
 if(mode EQ 'SUM4') then cam__scale = cam__scale*4d
;print,'cam_scale=',cam__scale


 ;-----------------------
 ; oaxis - array(2,nobj)
 ;-----------------------
 cam__oaxis=[511.5,511.5]
 if(mode EQ 'SUM2') then cam__oaxis = [255.5,255.5]
 if(mode EQ 'SUM4') then cam__oaxis = [127.5,127.5]
;print,'cam_oaxis=',cam__oaxis

 ;------------------------------
 ; Add values to detached header
 ;------------------------------
 dh_put_value, dh, 'cam_scale', cam__scale
 dh_put_value, dh, 'cam_oaxis', cam__oaxis
 dh_put_value, dh, 'cam_pos', cam__pos
 dh_put_value, dh, 'cam_vel', cam__vel
 dh_put_value, dh, 'cam_time', cam__time
 dh_put_value, dh, 'cam_orient', cam__orient
 dh_put_value, dh, 'cam_name', cam__name
 dh_put_value, dh, 'cam_fn_f2i', cam__fn_focal_to_image
 dh_put_value, dh, 'cam_fn_i2f', cam__fn_image_to_focal

end
;===========================================================================

