;============================================================================
; is_raw_sym
;
;============================================================================
function is_raw_sym, im, D

 sym = total(D*im[*])
;w = where(D EQ 0)
;if(w[0] NE -1) then D[w] = 1.
;sym = total(im[*]/D^2)

 return, sym
end
;============================================================================



;============================================================================
; image_sym_axis
;
;
;============================================================================
function image_sym_axis, im, axis_r0, axis_r1

 r0 = tr([axis_r0,0d])
 r1 = tr([axis_r1,0d])
 v = v_unit(r1-r0)

 s = size(im)
 n = s[1]*s[2]

 px = dindgen(s[1]) # make_array(s[2], val=1d)
 py = dindgen(s[2]) ## make_array(s[1], val=1d)
 pz = dblarr(s[1], s[2]) 

 p = tr([tr(px[*]), tr(py[*]), tr(pz[*])])

 r0 = r0 ##make_array(n, val=1d)
 v = v ##make_array(n, val=1d)

 p_r0 = p - r0
 D = v_mag(p_r0 - v*(v_inner(v, p_r0)#make_array(3,val=1d)))

 sym = is_raw_sym(im, D)

 imm = make_array(s[1], s[2], val=1d)
 max_sym = is_raw_sym(imm, D)

 sym = sym / max_sym


 return, sym
end
;============================================================================



;============================================================================
; is_compute
;
;
;============================================================================
function is_compute, _im, c=c, rad

 im = _im

 if(NOT keyword_set(rad)) then rad = 20

 im = im/max(im)

 sig = stdev(im)
 w = where(im LT 1.5*sig)
 if(w[0] NE -1) then im[w] = 0

 s = size(im)
 if(NOT keyword_set(c)) then c = [s[1]/2, s[2]/2]

 im = im[c[0]-rad:c[0]+rad, c[1]-rad:c[1]+rad]

 axis_r0 = float([c[0],0])
 axis_r1 = float([c[0],s[2]-1])
 sym_x = image_sym_axis(im, axis_r0, axis_r1)

 axis_r0 = float([0,c[1]])
 axis_r1 = float([s[1]-1,c[1]])
 sym_y = image_sym_axis(im, axis_r0, axis_r1)

 axis_r0 = float([0,0])
 axis_r1 = float([s[1]-1,s[2]-1])
 sym_xy1 = image_sym_axis(im, axis_r0, axis_r1)

 axis_r0 = float([0,s[2]-1])
 axis_r1 = float([s[1]-1,0])
 sym_xy2 = image_sym_axis(im, axis_r0, axis_r1)

 sym = [sym_x, sym_y, sym_xy1, sym_xy2]

 return, sym
end
;============================================================================



;============================================================================
; is_eval
;
;
;============================================================================
function is_eval, c, dif01=dif01, dif23=dif23
common image_sym_block, im

 sym = is_compute(im, c=c)
 dif01 = abs((sym[0]-sym[1])/(0.5*(sym[0]+sym[1])))
 dif23 = abs((sym[2]-sym[3])/(0.5*(sym[2]+sym[3])))

 return, abs(dif01) + abs(dif23)
end
;============================================================================



;============================================================================
; image_sym
;
;
;============================================================================
function image_sym, _im
common image_sym_block, im

 im = _im

 s = size(im)
 c = [s[1]/2, s[2]/2]

; n = [[1,0],[1,0]]
; powell, c, n, 1d-8, fmin, 'is_eval'

 sym = is_compute(im, c=c)

 return, sym
end
;============================================================================
