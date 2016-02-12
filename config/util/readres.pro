;========================================================================
; readres
;
; Reads vicar reseau files.
;
; rp = readres('data/vgr1na.res')
; plots, rp, psym=1
;
;========================================================================
function readres, fname

 ;---------------------
 ; read file
 ;---------------------
 xx = read_vicar(fname, label, /silent)


 ;-----------------------------------------------------------------------------
 ; rearrange into image points array assuming alternating line/sample coords.
 ;-----------------------------------------------------------------------------
 n = n_elements(xx)/2
 w = lindgen(n)*2

 line = xx[w]
 sample = xx[w+1]

 x = double(sample - 1d)
 y = double(line - 1d)

 p = dblarr(2,n)
 p[0,*] = x
 p[1,*] = y



 ps = ps_init(points = p)

 return, ps
end
;========================================================================
