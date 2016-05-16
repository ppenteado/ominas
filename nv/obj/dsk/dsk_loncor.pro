;=============================================================================
; dsk_loncor
;
; ****doesn't work yet!!***
;
;  Converts disk longitudes referenced to the original incorrect frame 
;  to the new frame.  Only one descriptor allowed.
;
;=============================================================================
function dsk_loncor, dkd, dlon
@core.include
 
 _dkd = cor_dereference(dkd)

 node = bod_inertial_to_body(_dkd.bd, dsk_get_node(dkd))
 dtheta = -atan(node[1], node[0])


 return, dlon + dtheta
end
;=============================================================================
