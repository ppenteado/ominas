;===========================================================================
; cam_set_ny
;
;
;===========================================================================
pro cam_set_ny, cxp, ny
@nv_lib.include
 cdp = class_extract(cxp, 'CAMERA')
 cd = nv_dereference(cdp)

 size = cd.size
 size[1,*] = ny

 nv_rereference, cdp, cd
 nv_notify, cdp, type = 0
end
;===========================================================================



