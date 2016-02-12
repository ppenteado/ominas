;===========================================================================
; cam_set_nx
;
;
;===========================================================================
pro cam_set_nx, cxp, nx
@nv_lib.include
 cdp = class_extract(cxp, 'CAMERA')
 cd = nv_dereference(cdp)

 size = cd.size
 size[0,*] = nx

 nv_rereference, cdp, cd
 nv_notify, cdp, type = 0
end
;===========================================================================



