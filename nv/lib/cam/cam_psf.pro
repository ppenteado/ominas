;=============================================================================
;+
; NAME:
;	cam_psf
;
;
; PURPOSE:
;	Computes a point-spread function.
;
;
; CATEGORY:
;	NV/LIB/CAM
;
;
; CALLING SEQUENCE:
;	psf = cam_psf(cd, x, y)
;
;
; ARGUMENTS:
;  INPUT:
;	cd:	 Camera descriptor.
;
;	x:	 Array of x coordinates relative to the center of the PSF,
;		 or a width in the x direction.
;
;	y:	 Array of y coordinates relative to the center of the PSF,
;		 or a width in the y direction.
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
;	Point-spread function values at each point specified by the x and y 
;	arguments.
;
;
; PROCEDURE:
;	The function indicated by the fn_psf field of the camera descriptor
;	is called and its return value is passed through to the caller of
;	cam_psf.  If x and y widths are given instead of arrays, the PSF
;	will be centered, and the grid spacing will be one pixel.
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
function cam_psf, cxp, _x, _y, noevent=noevent
@nv_lib.include
 cdp = class_extract(cxp, 'CAMERA')
 if(NOT keyword_set(cdp)) then return, 0
 nv_notify, cdp, type = 1, noevent=noevent
 cd = nv_dereference(cdp)

 if(keyword_set(_x)) then x = _x 
 if(keyword_set(_y)) then y = _y

 ;---------------------------------------
 ; test for width instead of grid
 ;---------------------------------------
 if(n_elements(x) EQ 1) then $
  begin
   nx = (ny = x)
   if(keyword_set(y)) then ny = y

   x = (dindgen(nx)-0.5*nx)#make_array(ny,val=1d)
   y = (dindgen(ny)-0.5*ny)##make_array(nx,val=1d)
  end


 if(NOT keyword_set(cd[0].fn_psf)) then return, 0
 return, call_function(cd[0].fn_psf, cdp, x, y)
end
;===========================================================================
