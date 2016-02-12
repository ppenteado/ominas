;===========================================================================
; orb_get_lan
;
;
;===========================================================================
function orb_get_lan, xd, frame_bd, ref=ref

 nt = n_elements(xd)

 iframe_bd = orb_inertialize(frame_bd)

 bd = class_extract(xd, 'BODY')
 orient = bod_orient(iframe_bd)
 iframe_xx = orient[0,*,*]					; 1 x 3 x nt
 iframe_yy = orient[1,*,*]					; 1 x 3 x nt
 iframe_zz = orient[2,*,*]					; 1 x 3 x nt
 
 if(NOT keyword_set(ref)) then xref = iframe_xx $
 else xref = ref
 yref = v_cross(iframe_zz, xref)

 node = orb_get_ascending_node(xd, iframe_bd, ref=ref)		; 1 x 3 x nt
 lan = tr(v_angle(node, xref))					; nt
 w = where(v_inner(yref, node) LT 0)
 if(w[0] NE -1) then lan[w] = 2d*!dpi - lan[w]


 nv_free, iframe_bd

 if(n_elements(lan) EQ 1) then lan = lan[0]

 return, lan
end
;===========================================================================



