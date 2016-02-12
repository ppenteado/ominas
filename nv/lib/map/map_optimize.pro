;=============================================================================
; map_optimize
;
;=============================================================================
function map_optimize, md=_md, $
	type=type, size=size, origin=origin, $
	latmin=latmin, lonmin=lonmin, radmin=radmin












 if(keyword_set(_md)) then md = nv_clone(_md) $
 else md = map_init_descriptors(1, $
			type=type, $
			size=size, $
			scale=scale, $
			origin=origin, $
			units=units, $
			center=center

 return, md
end
;=============================================================================
