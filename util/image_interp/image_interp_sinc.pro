;=============================================================================
;+
; NAME:
;       image_interp_sinc
;
;
; PURPOSE:
;       Extracts a region from an image using sinc interpolation.
;
;
; CATEGORY:
;       UTIL
;
;
; CALLING SEQUENCE:
;       result = image_interp_sinc(image, grid_x, grid_y)
;
;
; ARGUMENTS:
;  INPUT:
;        image:         An array of image point arrays.
;
;       grid_x:         The grid of x positions for interpolation
;
;       grid_y:         The grid of y positions for interpolation
;
;	     k:		"Half-width" of the convolution window.  The
;			window actually covers the central pixel, plus
;			k pixels in each direction.  Default is 3, which
;			gives a 7x7 window.
;
;	fwhm:		If set, a gaussian with this half width is used for 
;			the psf instead of calling the user-supplied function.
;
;  OUTPUT:
;       NONE
;
;
; KEYORDS:
;  INPUT:
;	psf_fn:		Name of a function to compute the psf:
;
;				psf_fn(psf_data, x,y)
;
;			where x and y are the location relative to the 
;			center, and must accept arrays of any dimension.
;
;	psf_data:	Data for psf function as shown above.
;
;	mask:		Byte image indcating which pixels (value GT 0) should
;			be excluded from the interpolation.
;
;  OUTPUT:
;       NONE
;
;
; RETURN:
;       Array of interpolated points at the (grid_x, grid_y) points.
;
;
; STATUS:
;       Completed.
;
;
; MODIFICATION HISTORY:
;       Written by:     Spitale
;
;-
;=============================================================================
function image_interp_sinc, image, grid_x, grid_y, k, fwhm, valid=valid, $
                        psf_fn=psf_fn, psf_data=psf_data, psf_frac, kmax=kmax, $
                        mask=mask, zmask=zmask

 if(NOT keyword_set(k)) then k = 3
 if(NOT keyword_set(psf_frac)) then psf_frac = 0.95
 if(NOT keyword_set(kmax)) then kmax = 2

 dim = size(image, /dim)
 np = n_elements(grid_x)

 ;----------------------------------------------------------------------
 ; if using a psf function, determine kernel width as size of box
 ; containing some desired fraction of the psf power
 ;----------------------------------------------------------------------
 if(keyword_set(psf_fn)) then $
  begin
   if(keyword_set(psf_frac)) then $
    begin
     pp = call_function(psf_fn, psf_data)
     nn = (size(pp))[1]/2
     int = dblarr(nn)
     for i=0, nn-1 do int[i] = total(pp[nn-i:nn+i, nn-i:nn+i])
     k = min(where((int / total(pp)) GE psf_frac)) + 1
    end
  end


 if(keyword_set(kmax)) then k = k<kmax
 if(keyword_set(fwhm)) then sig = fwhm / 2.354d


 ;----------------------------------------------------------------------
 ; perform the interpolation
 ;----------------------------------------------------------------------
 s = size(image)

 lgrid_x = long(grid_x)
 lgrid_y = long(grid_y)

 n = 0.
 interp = 0
 norm = dblarr(np)
 interp = dblarr(np)

 mask_sub = [-1]
 if(keyword_set(mask)) then mask_sub = where(mask GT 0) 


 ;------------------------------------------------------
 ; compute contribution at each offset in the kernel
 ;------------------------------------------------------
 for i=-k+1, k do $
  for j=-k+1, k do $
   begin
    grid_xi = lgrid_x + i
    grid_yj = lgrid_y + j
    sub = grid_xi + s[1]*grid_yj

    ;- - - - - - - - - - - - - - - - - - - - - - - -
    ; mask as needed
    ;- - - - - - - - - - - - - - - - - - - - - - - -
    ii = lindgen(np)
    if(keyword_set(zmask)) then ii = where(image[sub] NE 0) $
    else if(mask_sub[0] NE -1) then $
     begin
      uu = uniq(sub, sort(sub))
      xx = [sub[uu], mask_sub]
      h = histogram(xx, rev=rr)
      w = where(h GT 1)
      if(w[0] NE -1) then $
       begin
        iii = complement(sub[uu], rr[rr[w]])
        if(iii[0] NE -1) then ii = uu[iii]
       end
     end

    ;- - - - - - - - - - - - - - - - - - - - - - - -
    ; interpolate
    ;- - - - - - - - - - - - - - - - - - - - - - - -
    if(n_elements(ii) GT 1) then $
     begin
      x_xi = grid_x[ii] - grid_xi[ii]
      y_yj = grid_y[ii] - grid_yj[ii]

      if n_elements(ii) eq 1 then begin ;kepp psf_in from thinking the single element is a grid size
        fixx=1
        x_xi=[x_xi,x_xi]
        y_yj=[y_yj,y_yj]
      endif else fixx=0

      if(keyword_set(psf_fn)) then $
                      psf = call_function(psf_fn, psf_data, x_xi, y_yj) $
      else psf = gauss2d(x_xi, y_yj, sig)
      
      if fixx then begin ;undo the workaround created above when the grid has only one element
        x_xi=[x_xi[0]]
        y_yj=[y_yj[0]]
        psf=[psf[0]]
      endif
        
      xsinc = sinc(x_xi)
      ysinc = sinc(y_yj)

      weight = psf*xsinc*ysinc 
      norm[ii] = norm[ii] + weight

      interp[ii] = interp[ii] + weight*image[sub[ii]]
      n = n + 1
     end
   end


 valid = where(norm GT 0)

 return, interp / norm
end
;===========================================================================


