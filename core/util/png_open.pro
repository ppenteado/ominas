;=============================================================================
; png_open
;
; This is how it's intended to be used, but it hasn't been tested...
;  png_open, image, 500, zimage
;  ctmod
;  tvim, zim, /nowin, /order
;  png_close, filename
;
;=============================================================================
;pro png_open, im, size, zim
pro png_open, im, xsize, ysize, zim

 ;- - - - - - - - - - - - - - - - - - - - -
 ; set up Z buffer
 ;- - - - - - - - - - - - - - - - - - - - -
 set_plot, 'Z' 
; device, set_resolution=[size,size]
 device, set_resolution=[xsize,ysize]


 ;- - - - - - - - - - - - - - - 
 ; output image
 ;- - - - - - - - - - - - - - - 
 zim = shift(rotate(im, 7), 0,1)

end
;=============================================================================
