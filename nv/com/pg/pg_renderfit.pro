;=============================================================================
;+
; NAME:
;	pg_renderfit
;
;
; PURPOSE:
;	Searches for the offset (dx,dy) that gives the best agreement between
;	two uncorrelated sets of image points.
;
;
; CATEGORY:
;	NV/PG
;
;
; CALLING SEQUENCE:
;	dxy = pg_renderfit(dd, cd=cd, sund=sund, bx=bx)
;
;
; ARGUMENTS:
;  INPUT:
;	dd:		Data descriptor.
;
;  OUTPUT: NONE
;
;
; KEYWORDS:
;  INPUT: 
;	cd: 		Camera descriptor.
;
;	sund:		Sun descriptor.
;
;	bx:		Array of body descriptors describing objects in the scene.
;
;	show:		If specified, some graphics are displayed illustrating 
;			aspects of the search.
;
;
;  OUTPUT: NONE
;
;
; RETURN:
;	2-element array giving the fit offset as [dx,dy].
;
;
; PROCEDURE:
;	pg_renderfit finds the offset that gives the best correlation between
;	the given image and a simulated image.
;
;
; STATUS:
;	Some bugs.
;
;
; NOTES:
;	This function sometimes fails when the largest object in the scene
;	is not completely contained in the image.  
;
;
; SEE ALSO:
;	pg_farfit
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale, 2/2017
;	
;-
;=============================================================================
function pg_renderfit, dd, cd=cd, sund=sund, bx=bx, show=show

 ;------------------------------------ 
 ; get input image
 ;------------------------------------ 
 im = dat_data(dd)

 ;------------------------------------ 
 ; render scene
 ;------------------------------------ 
 dd0 = pg_render(cd=cd, sund=sund, bx=bx, show=show)
 im0 = dat_data(dd0)

 ;------------------------------------ 
 ; find offset
 ;------------------------------------ 
 dxy = image_offset(im0, im)


 return, dxy
end
;=============================================================================
