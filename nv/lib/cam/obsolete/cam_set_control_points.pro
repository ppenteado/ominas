;===========================================================================
; cam_set_control_points
;
;
;===========================================================================
pro cam_set_control_points, cd, focal_pts, image_pts
@nv_lib.include


 if(ptr_valid(cd.fn_data_p)) then nv_ptr_free_recurse, cd.fn_data_p

 cd.fn_data_p = nv_ptr_new([nv_ptr_new(focal_pts), nv_ptr_new(image_pts)])

 nv_notify, cd, type = 0
end
;===========================================================================



