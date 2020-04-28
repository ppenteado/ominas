;============================================================================
; subimage_centroid
;
;  Assumes that the corners bound an area containing only one source and
;  that the edges of the bounded region are sky.
;  
;
;============================================================================
function subimage_centroid, _im, _corners, nsig=nsig, nit=nit, show=show

 if(NOT defined(nsig)) then nsig = 3.
 if(NOT keyword_set(nit)) then nit = 10

 ccx = (ccy = 0.)

 _corners = float(_corners)
 c = (0.5*total(_corners, 2)) # make_array(2,val=1d)

 ;---------------------------------------------------------------------
 ; perform this calculation nit times using various boxes
 ; and average the results
 ;---------------------------------------------------------------------
 for i=0, nit-1 do $
  begin
   corners = (_corners-c)*(1.-float(i)/float(nit)*0.5) + c

   im = double(_im)

   ;--------------------------------------------
   ; extract subimage
   ;--------------------------------------------
   if(keyword_set(corners)) then $
    begin
     xmin = min(corners[0,*])
     xmax = max(corners[0,*])
     ymin = min(corners[1,*])
     ymax = max(corners[1,*])

     im = double(im[xmin:xmax, ymin:ymax])

     if(keyword_set(show)) then $
        plots, [xmin, xmax, xmax, xmin, xmin], $
                  [ymin, ymin, ymax, ymax, ymin], col=ctred()
    end


   ;--------------------------------------------
   ; threshold the image and zero the bg
   ;--------------------------------------------
   s = size(im)
   n = n_elements(im)

   ;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
   ; compute statistics around edge only so as to exclude the source
   ;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
   ls1 = lindgen(s[1])
   ls2 = lindgen(s[2]) * s[1]
   ii = [ls1, ls2, ls1+s[1]*(s[2]-1), ls2+s[1]-1]

   sig = stdev(im[ii], mean)
   thresh = mean+nsig*sig

   im = (im > thresh) - thresh


   ;--------------------------------------------
   ; compute centroid
   ;--------------------------------------------
   x = dindgen(s[1]) # make_array(s[2], val=1d)
   y = dindgen(s[2]) ## make_array(s[1], val=1d)

   imtot = total(im)

   cx = total(x*im) / imtot
   cy = total(y*im) / imtot


   if(keyword_set(corners)) then $
    begin
     cx = cx + xmin
     cy = cy + ymin
    end

   ccx = ccx + cx
   ccy = ccy + cy
  end

 if(keyword_set(show)) then wait, 0.005

 return, [ccx, ccy]/nit
end
;============================================================================
