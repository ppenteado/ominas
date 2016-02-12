;=============================================================================
; png_overlays
;
;=============================================================================
pro png_overlays, fname, im, size, overlay_pro, data

 sim = size(im)

 ;- - - - - - - - - - - - - - - - - - - - -
 ; construct image in Z buffer
 ;- - - - - - - - - - - - - - - - - - - - -
 set_plot, 'Z' 
 device, set_resolution=[size,size]

 ctmod, top=top
 zoom = size/float(sim[1])

 ;- - - - - - - - - - - - - - - - - - - - - - - - - - - - -
 ; display image
 ;- - - - - - - - - - - - - - - - - - - - - - - - - - - - -
 tvim, shift(rotate(im, 7), [0,1]), z=zoom, top=top, /nowin
 tvim, im, /noplot, /order, z=zoom, /nowin


 ;- - - - - - - - - - - - - - - - - - - - -
 ; compute and draw overlays
 ;- - - - - - - - - - - - - - - - - - - - -
 call_procedure, overlay_pro, data


 ;--------------------------------------------------
 ; read pixmap image into array and get color table
 ;--------------------------------------------------
 image = tvrd()
 tvlct, r, g, b, /get

 device, /close
 set_plot, 'X'


 ;-------------------------------------------
 ; write png image
 ;-------------------------------------------
 s = size(image)
 im = bytarr(3,s[1],s[2])
 im[0,*,*] = r[image]
 im[1,*,*] = g[image]
 im[2,*,*] = b[image]
 write_png, fname, im

end
;=============================================================================
