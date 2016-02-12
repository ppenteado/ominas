;=============================================================================
;+
; NAME:
;       ptloc
;
;
; PURPOSE:
;       To locate a point in an image that best fits a psf model.
;
;
; CATEGORY:
;       UTIL
;
;
; CALLING SEQUENCE:
;       result = ptloc(image, model, width)
;
;
; ARGUMENTS:
;  INPUT:
;       image:  Image, or subimage in which to find the point.
;               Size of image should be at least width + size of model.
;
;       model:  Model of the point spread function.
;
;       width:  Width of box around calculated point in which to
;               find the point.
;
;  OUTPUT:
;	sigma:	Position uncertainty.
;
;         ccp:  The correlation coefficient at the point found.
;
;
; RETURN:
;       The point (x,y) in the image that best fits the model.
;
;
; PROCEDURE:
;       The correlation between the image and the model is calculated.  
;	If possible, a gaussian is fit to the correlation peak and the
;	sub-pixel location of the center of the gaussian is the result.  
;	If that fit does not converge, then the location of the pixel with
;	the maximum correlation is returned and a warning is printed.
;
;
; STATUS:
;       Completed.
;
;
; MODIFICATION HISTORY:
;       Written by:     Haemmerle, 6/1998
;	Modified:	Spitale, 9/2002 -- Fit to gaussian to determine
;				  subpixel location of correlation peak.
;
;-
;=============================================================================
function ptloc, image, model, width, ccp=ccp, sigma=sigma, chisq=chisq, $
                  status=status, round=round, spike=spike

 chisq = 1d8
 status = -1

 si = size(image)
 sm = size(model)
 dimage = double(image)
 sx = double(sm[1])
 sy = double(sm[2])

 ;------------------------------------------------
 ; compute correlation coefficient at each pixel
 ;------------------------------------------------
 cc = c_correlate_2d(dimage, model, sigma=image_sigma, mean=image_mean)

 ;-------------------------------------------
 ; extract centered sub image; width x width
 ;-------------------------------------------
 box_subs = (indgen(width)-width/2.)#make_array(width,val=1) + $
                    ((indgen(width)-width/2.)*si[1])##make_array(width,val=1)
 subs = dblarr(width,width)
 w = fix(si[1]/2)+si[1]*fix(si[2]/2)
 subs[*,*] = box_subs+w
 sub_ccs = cc[subs]

 ;------------------------------------------------------------
 ; find subpixel cc peak by fitting cc profile to a gaussian
 ;------------------------------------------------------------
 sub_cc = sub_ccs[*,*]

 catch, err
 if(keyword__set(err)) then return, 0
 xx = gauss2d_fit(sub_cc, coeff)
 catch, /cancel
 points = dblarr(2)

 successful = 0
 if(total(finite(coeff)) EQ n_elements(coeff)) then $
  begin
   successful = 1
   dx = coeff[4]
   dy = coeff[5]

   if((abs(dx) GT si[1]-width) OR (abs(dy) GT si[2]-width)) then successful = 0
  end

 ;------------------------------------------------------------
 ; if gaussian fit succeeds, sigma is gaussian width
 ;------------------------------------------------------------
 if(successful) then $
  begin
   points[0] = dx + (w mod si[1]) - width/2.
   points[1] = dy + fix(w/si[1]) - width/2.
   sigma = sqrt(coeff[2]^2 + coeff[3]^2)
  end $
 ;------------------------------------------------------------
 ; otherwise, sigma is half-width of correlation peak
 ;------------------------------------------------------------
 else $
  begin
   status = 1
;   nv_message, /cont, name='ptloc', 'Cannot obtain sub-pixel precision.'

   max_sub_cc = max(sub_cc)
   ww = where(sub_cc EQ max_sub_cc)

   dx = (ww[0] mod width)
   dy = fix(ww[0]/width)

   points[0] = dx + (w mod si[1]) - width/2.
   points[1] = dy + fix(w/si[1]) - width/2.

   wx = where(smooth(cc[*,points[1]], 3) GT max_sub_cc/2.)
   wy = where(smooth(cc[points[0],*], 3) GT max_sub_cc/2.)

   sigma = 0.5 * sqrt(max([points[0]-min(wx), max(wx)-points[0]])^2 + $
                            max([points[1]-min(wy), max(wy)-points[1]])^2)


  end

 ;------------------------------------------------------------
 ; determine actual c.c. at peak.
 ;------------------------------------------------------------
 ccp = interpolate(cc, points[0], points[1])
; plots, /dev, points, ps=1, col=ctblue()


 ;------------------------------------------------------------
 ; compute chisq value between model and image 
 ;------------------------------------------------------------

 ;- - - - - - - - - - - - - - - - - - - - - - - - - - - - -
 ; interpolate model to best image dxy
 ;- - - - - - - - - - - - - - - - - - - - - - - - - - - - -
 xx = dindgen(si[1]) # make_array(si[2],val=1)
 yy = dindgen(si[2]) ## make_array(si[1],val=1d)
 xx = xx - (si[1]-sm[1])/2. - (dx-width/2.)
 yy = yy - (si[2]-sm[2])/2. - (dy-width/2.)

 mm = bilinear(model, xx, yy)

 im = dimage - median(dimage)
 mm = mm - median(mm)

;im = im - smooth(im, 25)
im = im - smooth(im, 15)

;surface, im
;tvscl, im
 ;- - - - - - - - - - - - - - - - - - - - - - - - - - - - -
 ; iterate to find best offset, scale to match mm, im
 ;- - - - - - - - - - - - - - - - - - - - - - - - - - - - -
 modfit, im, mm, chisq=chisq, scale=scale, off=off, sample=5
;print, chisq
;stop

;print, chisq
;stop
;plot, im[*,25]
;oplot, (mm[*,25]-off)*scale, col=ctred()


 ;- - - - - - - - - - - - - - - - - - - - - - - - - - - - -
 ; measure roundness
 ;- - - - - - - - - - - - - - - - - - - - - - - - - - - - -
 if(keyword_set(round)) then $
  begin
   catch, err
   if(keyword__set(err)) then return, 0
   yy = gauss2d_fit(smooth(im,2), coeff, /tilt)
   catch, /cancel

   wx = coeff[2]
   wy = coeff[3]

;surface, xx
;tvscl, im
;print, coeff
;if(counter() GT 100) then stop

   if((wx/wy GT round) OR (wy/wx GT round)) then return, 0
  end


 ;- - - - - - - - - - - - - - - - - - - - - - - - - - - - -
 ; remove single-pixel spikes
 ;- - - - - - - - - - - - - - - - - - - - - - - - - - - - -
 if(keyword_set(spike)) then $
                   if(max(im)/max(smooth(im,2)) GT 5.) then return, 0 



;print, ccp
;tvscl, image<20
;stop

 status = 0
 return, points
end
;===========================================================================
