;=============================================================================
; get_edge_points
;
;
;=============================================================================
function get_edge_points, cd=cd, bx=bx, gbx=gbx, dkx=dkx

 gbd = class_extract(bx, 'GLOBE')
 dkd = class_extract(bx, 'DISK')

 gbx = append_array(gbx, gbd)
 dkx = append_array(dkx, dkd)

 if(keyword_set(gbx)) then $

 if(keyword_set(dkx)) then $

end
;=============================================================================
