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
;	spike_ptd:	POINT specifying the points to replace;
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
;	kernel:		If set, this kernel is used to weight the replacement
;			of all pixels in a box of size scale around each
;			spike point, instead of replacing only the spike
;			point.  If this is a scalar, then this is taken as the
;			width of a Gaussian kernel.
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
function pg_despike, dd, spike_ptd, $
                image=image, scale=scale, n=n, kernel=kernel, noclone=noclone

 if(NOT keyword_set(scale)) then scale = 10
 if(NOT keyword_set(n)) then n = 5

 ;---------------------------------------
 ; dereference
 ;---------------------------------------
 im = dat_data(dd)
 p = pnt_points(spike_ptd, /cat)
 np = n_elements(p[0,*])


 ;---------------------------------------
 ; determine weigting kernel, if any
 ;---------------------------------------
 pp = p
 if(keyword_set(kernel)) then $
  begin
   wk = n_elements(kernel) EQ 1

   nxy = [scale,scale]
   if(NOT wk) then nxy = size(kernel, /dim)

   xx = dindgen(nxy[0])#make_array(nxy[1],val=1d) - double(nxy[0])/2
   yy = dindgen(nxy[1])##make_array(nxy[0],val=1d) - double(nxy[1])/2

   weight = kernel
   if(wk) then weight = gauss2d(xx, yy, kernel, kernel)

   dp = [transpose(xx[*]), transpose(yy[*])]
   ndp = n_elements(dp[0,*])

   dp = reform(/over, dp[linegen3z(2,ndp,np)], 2, ndp*np)
   p = reform(/over, transpose(p[linegen3z(2,np,ndp)], [0,2,1]), 2, ndp*np)
   weight = reform(/over, weight[*]#make_array(np,val=1d), ndp*np)

   pp = p + dp
  end


 ;---------------------------------------
 ; despike
 ;---------------------------------------
 if(NOT keyword_set(p)) then image = im $ 
 else image = despike(im, pp, scale=scale, n=n, weight=weight)


 ;---------------------------------------
 ; set up new data descriptor
 ;---------------------------------------
 if(NOT keyword_set(noclone)) then new_dd = nv_clone(dd) $
 else new_dd = dd
 dat_set_data, new_dd, image

 return, new_dd
end
;=============================================================================
