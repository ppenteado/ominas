;=============================================================================
; dsk_loncor
;
; ****doesn't work yet!!***
;
;  Converts disk longitudes referenced to the original incorrect frame 
;  to the new frame.  Only one descriptor allowed.
;
;=============================================================================
function dsk_loncor, dkx, dlon
@nv_lib.include
 dkd = class_extract(dkx, 'DISK')
 dkd = nv_dereference(dkdp)

 node = bod_inertial_to_body(dkd.bd, dsk_get_node(dkdp))
 dtheta = -atan(node[1], node[0])


 return, dlon + dtheta
end
;=============================================================================
