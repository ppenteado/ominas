;========================================================================
; readrob
;
; Reads reseau object space files transcribed from vicar routine geomav.
;
; rp = readrob('data/vgr1na.res')
; plots, rp, psym=1
;
;========================================================================
function readrob, fname

 ;---------------------
 ; read file
 ;---------------------
 xx = read_txt_table(fname, /raw)
 n = (size(xx))[1]


 ;-----------------------------------------------------------------------------
 ; rearrange into image points array assuming alternating line/sample coords.
 ;-----------------------------------------------------------------------------
 line = [tr(double(xx[*,1])), tr(double(xx[*,3])), tr(double(xx[*,5]))]
 line = reform(line, 3*n, /over)
 sample = [tr(double(xx[*,2])), tr(double(xx[*,4])), tr(double(xx[*,6]))]
 sample = reform(sample, 3*n, /over)

 n = n_elements(line)

 line = line[0:n-3]			; Ignore last two marks -- they don't 
 sample = sample[0:n-3]			;  correspond to any nominals anyway

 n = n_elements(line)

 x = double(sample - 1d)
 y = double(line - 1d)

 p = dblarr(2,n)
 p[0,*] = x
 p[1,*] = y


 ;-------------------------------------------------------------------------
 ; Coords in the file are in 'object space'; convert to focal coords.
 ;-------------------------------------------------------------------------
 oaxis = [499.,499.]
 scale = 0.85 * 9.2454750d-06
 p[0,*] = (p[0,*] - oaxis[0])*scale 
 p[1,*] = (p[1,*] - oaxis[1])*scale 

 ptd = pnt_create_descriptors(points = p)
 

 return, ptd
end
;========================================================================
