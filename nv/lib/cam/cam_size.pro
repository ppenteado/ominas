;===========================================================================
;+
; NAME:
;	cam_size
;
;
; PURPOSE:
;	Returns the image size (in pixels) for each given camera descriptor.
;
;
; CATEGORY:
;	NV/LIB/CAM
;
;
; CALLING SEQUENCE:
;	size = cam_size(cd)
;
;
; ARGUMENTS:
;  INPUT:
;	cd:	 Array (nt) of CAMERA descriptors.
;
;  OUTPUT: NONE
;
;
; KEYWORDS:
;  INPUT:  NONE
;
;  OUTPUT: NONE
;
;
; RETURN:
;	Size array associated with each given camera descriptor.
;
;
; STATUS:
;	Complete
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale, 1/1998
;	
;-
;===========================================================================
function cam_size, cxp, noevent=noevent, nx=nx, ny=ny
@nv_lib.include
 cdp = class_extract(cxp, 'CAMERA')
 nv_notify, cdp, type = 1, noevent=noevent
 cd = nv_dereference(cdp)
 nx = cd.size[0]
 ny = cd.size[1]
 return, cd.size
end
;===========================================================================



