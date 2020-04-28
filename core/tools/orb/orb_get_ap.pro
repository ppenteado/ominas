;===========================================================================
; orb_get_ap
;
;
;===========================================================================
function _orb_get_ap, xd, frame_bd

 nt = n_elements(xd)

 iframe_bd = orb_inertialize(frame_bd)

 orient = bod_orient(xd)
 xx = orient[0,*,*]						; 1 x 3 x nt
 zz = orient[2,*,*]						; 1 x 3 x nt

 orient = bod_orient(iframe_bd)
 frame_xx = orient[0,*,*]					; 1 x 3 x nt
 frame_zz = orient[2,*,*]					; 1 x 3 x nt


; node = orb_get_ascending_node(xd, frame_bd)
 node = orb_get_ascending_node(xd, iframe_bd)

 ap = tr(v_angle(node, xx))					; nt
 ss = v_cross(zz, node)						; 1 x 3 x nt
 w = where(v_inner(ss, xx) LT 0)
 if(w[0] NE -1) then ap[w] = -ap[w]

 nv_free, iframe_bd

 return, ap
end
;===========================================================================



;===========================================================================
; orb_get_ap
;
;
;===========================================================================
function orb_get_ap, xd, frame_bd

 nt = n_elements(xd)

 orient = bod_orient(xd)
 xx = orient[0,*,*]						; 1 x 3 x nt
 zz = orient[2,*,*]						; 1 x 3 x nt

 node = orb_get_ascending_node(xd, frame_bd)

 ap = tr(v_angle(node, xx))					; nt
 ss = v_cross(zz, node)						; 1 x 3 x nt
 w = where(v_inner(ss, xx) LT 0)
 if(w[0] NE -1) then ap[w] = -ap[w]

 if(n_elements(ap) EQ 1) then ap = ap[0]

 return, ap
end
;===========================================================================
