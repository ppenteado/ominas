;=============================================================================
;+
; NAME:
;	pg_despike
;
;
; PURPOSE:
;	Removes previously-located spurious features like cosmic-ray hits.
;
;
; CATEGORY:
;	NV/PG
;
;
; CALLING SEQUENCE:
;	result = pg_despike(dd)
;
;
; ARGUMENTS:
;  INPUT:
;	dd:		Data descriptor containing the image to be despiked.
;
;	spike_ps:	points_struct specifying the points to replace;
;			typically computed by pg_spikes.
;
;  OUTPUT:
;	NONE
;
;
; KEYWORDS:
;  INPUT:
;	scale:		Typical size of features to be removed.  Default 
;			is 10.
;
;	n=n:		Number of timers to repeat the box filter.  Default
;			is 5.
;
;  OUTPUT:
;	image:		The corrected image.
;
;
; RETURN:
;	Data descriptor containing the corrected image.  If /noclone
;	is not set, set input data descriptor is modified.
;
;
; PROCEDURE:
;	pg_despike replaces the values of the desired pixels with those
;	computed by smoothing the input image using a box filter of size 
;	'scale' repeatedly, 'n' times.
;
;
; STATUS:
;	Complete.
;
;
; SEE ALSO:
;	pg_spikes
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale, 2/2004
;	
;-
;=============================================================================
function pg_despike, dd, spike_ps, image=image, scale=scale, n=n, noclone=noclone

 if(NOT keyword_set(scale)) then scale = 10
 if(NOT keyword_set(n)) then n = 5

 ;---------------------------------------
 ; dereference
 ;---------------------------------------
 im = nv_data(dd)
 p = pg_points(spike_ps)


 ;---------------------------------------
 ; despike
 ;---------------------------------------
 if(NOT keyword_set(p)) then image = im $ 
 else image = despike(im, p, scale=scale, n=n)


 ;---------------------------------------
 ; set up new data descriptor
 ;---------------------------------------
 if(NOT keyword_set(noclone)) then new_dd = nv_clone(dd) $
 else new_dd = dd
 nv_set_data, new_dd, image

 return, new_dd
end
;=============================================================================
