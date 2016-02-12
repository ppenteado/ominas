;=============================================================================
; _eval_omd
;
;=============================================================================
function _eval_omd, p
common _eval_omd_block, xd1, xd2, frame_bd

 lon1 = p[0] & lon2 = p[1]

 bod_pt1 = orb_lon_to_body(xd1, lon1, frame=frame_bd)
 bod_pt2 = orb_lon_to_body(xd2, lon2, frame=frame_bd)

 return, v_mag(bod_pt1 - bod_pt2)
end
;=============================================================================



;=============================================================================
; orb_min_distance
;
;  Computes the minimum distance between two orbits.  
;  NOT the bodies themselves.
;
;=============================================================================
function orb_min_distance, _xd1, _xd2, frame_bd=_frame_bd, $
                 lon1=lon1, lon2=lon2, distances=distances, lons=lons
common _eval_omd_block, xd1, xd2, frame_bd

 xd1 = _xd1
 xd2 = _xd2
 frame_bd = _frame_bd

 n = 1000.
 lon = dindgen(n)/n * 2d*!dpi

 ;-------------------------------------------------------------------
 ; compute body positions on each orbit at many inertial longitudes
 ;-------------------------------------------------------------------
 bod_pts1 = orb_lon_to_body(xd1, lon, frame=frame_bd)
 bod_pts2 = orb_lon_to_body(xd2, lon, frame=frame_bd)

 ;-------------------------------------------------------------------
 ; interpolate to find minimum lon-by-lon distance and 
 ; corresponding longitude
 ;-------------------------------------------------------------------
 distance = v_mag(bod_pts1 - bod_pts2)
 lonmin = peak_interp(lon, -distance)


 ;-------------------------------------------------------------------
 ; use lonmin as starting point to iterate for actual min distance,
 ; which doesn't necessarily occur at the same longitude on each
 ; orbit
 ;-------------------------------------------------------------------
 p = [lonmin, lonmin]
 powell, p, tr([[1d, 0d], [0d, 1d]]), 1d-8, min_distance, '_eval_omd'

 lon1 = p[0] & lon2 = p[1]

 distances = distance
 lons = lon

 return, min_distance
end
;=============================================================================
