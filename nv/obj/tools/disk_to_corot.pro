;==============================================================================
; disk_to_corot
;
;==============================================================================
function disk_to_corot, disk_pts, cd=cd, dkx=dkx, frame_bd=frame_bd, t0=t0, $
           dmldt=dmldt, times=times

 corot_pts = disk_pts
 corot_pts[*,1,*] = $
     disk_to_corot_lon(disk_pts[*,1,*], cd=cd, dkx=dkx, frame_bd=frame_bd, t0=t0, $
           dmldt=dmldt, times=times)

 return, corot_pts
end
;==============================================================================
