;===============================================================================
; ioff_peak
;
;===============================================================================
function ioff_peak, corr, grid
 grid = reform(grid, 2, n_elements(grid)/2)
 w = where(corr EQ max(corr))
 return, grid[*,w]
end
;===============================================================================




;===============================================================================
; ioff_peak
;
;===============================================================================
function ioff_peak, corr, grid
width = 10
sample = 10 

 dim0 = size(corr, /dim) 
 dim = dim0 < width
 dim_2 = dim/2

 w = where(corr EQ max(corr))
 wxy = w_to_xy(corr, w)

 ii = lindgen(dim0)

 xmin = wxy[0]-dim_2[0] > 0
 xmax = (wxy[0]+dim_2[0]-1) < (dim0[0]-1)
 ymin = wxy[1]-dim_2[1] > 0
 ymax = (wxy[1]+dim_2[1]-1) < (dim0[0]-1)
 ii = ii[xmin:xmax, ymin:ymax]
 sub = corr[ii]
 gridx = (grid[0,*,*])[ii]
 gridy = (grid[1,*,*])[ii]

 nn = width*sample

 gridx_interp = congrid(double(gridx), nn, nn, /interp)
 gridy_interp = congrid(double(gridy), nn, nn, /interp)
 sub_interp = smooth(congrid(sub, nn, nn, /interp), width)
 w = where(sub_interp EQ max(sub_interp))

 xy = [gridx_interp[w], gridy_interp[w]]


 return, xy
end
;===============================================================================




;===============================================================================
; ioff_correlate
;
;
;===============================================================================
function ioff_correlate, im1, im2, _grid, dxy=dxy

 if(NOT keyword_set(dxy)) then dxy = [0,0]
 dxy = round(dxy)

 grid_dim = (size(_grid, /dim))[1:2]
 ngrid = n_elements(_grid)/2
 grid = reform(_grid, 2, ngrid)

 dxy = dxy#make_array(ngrid,val=1d)

 dim = size(im1, /dim)
 nn = n_elements(im1)

 ;-------------------------------------------
 ; set up arrays
 ;-------------------------------------------
 ii = linegen3z(dim[0], dim[1], ngrid)
 im1_match = im1[ii]

 w = xy_to_w(dim, grid + dxy)
 ww = where(w LT 0)
 if(ww[0] NE -1) then w[ww] = w[ww] + nn

 jj = w##make_array(dim[0],val=1l)
 jj = jj[linegen3y(dim[0], dim[1], ngrid)]

 im2_shift = im2[(ii+jj) mod nn]
 ii = (jj = 0)

 ;-----------------------------------------------
 ; compute correlation coeff at each xy offset
 ;-----------------------------------------------
 prod = float(im1_match)*float(im2_shift)
 prod = total(prod, 1)
 corr = reform(total(prod, 1), grid_dim)

tvscl, congrid(corr,100,100), /order
 return, corr
end
;===============================================================================



;===============================================================================
; image_offset
;
;
;===============================================================================
function image_offset, _im1, _im2
 bin0 = 100


 ;-------------------------------------------------------------------
 ; fill with zeroes to get images to the same dimensions and convert
 ; to byte
 ;-------------------------------------------------------------------
 dim1 = size(_im1, /dim)
 dim2 = size(_im2, /dim)
 dim = [max([dim1[0],dim2[0]]), max([dim1[1],dim2[1]])]
 
 mean1 = mean(_im1)
 mean2 = mean(_im2)
 im1 = (im2 = bytarr(dim))
 im1[0:dim1[0]-1, 0:dim1[1]-1] = bytscl((_im1-mean1))
 im2[0:dim2[0]-1, 0:dim2[1]-1] = bytscl((_im2-mean2))


 ;-------------------------------------------------------------------
 ; iterate over correlation scales
 ;-------------------------------------------------------------------

 ;- - - - - - - - - - - - - - - - - - - - - -
 ; initial binning
 ;- - - - - - - - - - - - - - - - - - - - - -
 bin1 = bin0 * min(dim)/max(dim)
 bin_dim = [bin0, bin1]
 if(dim[1] GT dim[0]) then bin_dim = rotate(bin_dim,2)

 ;- - - - - - - - - - - - - - - - - - - - - -
 ; initial grid
 ;- - - - - - - - - - - - - - - - - - - - - -
 grid_dim = bin_dim


 ;- - - - - - - - - - - - - - - - - - - - - -
 ; iterate up to full image
 ;- - - - - - - - - - - - - - - - - - - - - -
 dxy = [0,0]
 repeat $
  begin
   scale = (double(dim)/double(bin_dim))[0] 

   ;- - - - - - - - - - - - - - - - - - - - -
   ; contruct correlation grid
   ;- - - - - - - - - - - - - - - - - - - - -
   ngrid = prod(grid_dim)
   grid = gridgen(grid_dim, /rec, p0=-grid_dim/2)
;stop
; grid is still screwed up
; print, grid[0,*,0]

   ;- - - - - - - - - - - - - - - - - - - - -
   ; bin images
   ;- - - - - - - - - - - - - - - - - - - - -
   im1_corr = congrid(im1, bin_dim[0], bin_dim[1])
   im2_corr = congrid(im2, bin_dim[0], bin_dim[1])

   ;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
   ; correlate images, centering the search grid at the current dxy solution
   ;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
   corr = ioff_correlate(im1_corr, im2_corr, grid, dxy=dxy/scale)

   ;- - - - - - - - - - - - - - - - - - - - -  
   ; find correlation peak
   ;- - - - - - - - - - - - - - - - - - - - -
   _dxy = ioff_peak(corr, grid)
   dxy = dxy + _dxy*scale

   ;- - - - - - - - - - - - - - - - - - - - -
   ; adjust correlation grid and binning
   ;- - - - - - - - - - - - - - - - - - - - -
   grid_dim = grid_dim / (scale/1.5)
   bin_dim = bin_dim * 5 < dim

  endrep until(scale LE 1)


 return, dxy
end
;===============================================================================




pro test

 ingrid, dd=dd, cd=cd, pd=pd, rd=rd, sund=sund
 dxy = pg_renderfit(dd, cd=cd, sund=sund, bx=[pd,rd], /show)
 pg_repoint, cd=cd, dxy

end




