;=============================================================================
; data_vs_device
;
;=============================================================================
function data_vs_device

 pxdv = [0, !d.x_size-1]
 pydv = [0, !d.y_size-1]

 pxy = transpose((convert_coord(pxdv, pydv, /device, /to_data))[0:1,*])
 px = pxy[*,0]
 py = pxy[*,1]

 ndv = abs(difference(pxdv)*difference(pydv))
 n = abs(difference(px)*difference(py))

 return, ndv GT n
end
;=============================================================================
