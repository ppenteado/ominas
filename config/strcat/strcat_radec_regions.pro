;=============================================================================
; strcat_radec_regions
;
;=============================================================================
function strcat_radec_regions, ra_fov, dec_fov, $
     ra1_regions, ra2_regions, dec1_regions, dec2_regions

 n = n_elements(ra1_regions)

 ;---------------------------------------------------
 ; convert to vectors
 ;---------------------------------------------------
 radec_fov = dblarr(4,3)
 radec_fov[*,0] = [ra_fov[0], ra_fov[1], ra_fov[1], ra_fov[0]]
 radec_fov[*,1] = [dec_fov[0], dec_fov[0], dec_fov[1], dec_fov[1]]
 radec_fov[*,2] = 1

 radec_regions = dblarr(4*n, 3)
 radec_regions[*,0] = [ra1_regions, ra2_regions, ra2_regions, ra1_regions]
 radec_regions[*,1] = [dec1_regions, dec1_regions, dec2_regions, dec2_regions]
 radec_regions[*,2] = 1

 bd = bod_inertial()
 v_fov = bod_radec_to_body(bd, radec_fov)
 v_regions = bod_radec_to_body(bd, radec_regions)


 ;---------------------------------------------------
 ; check for region corners within fov
 ;---------------------------------------------------
 w = v_interior_convex(v_fov, v_regions)
 if(w[0] NE -1) then return, unique(w mod n)


 ;---------------------------------------------------
 ; check for fov corners within regions
 ;---------------------------------------------------
 for i=0, n-1 do $
  begin
   ii = lindgen(4)*n + i
   w = v_interior_convex(v_regions[ii,*], v_fov)
   if(w[0] NE -1) then ww = append_array(ww, i)
  end

 return, ww
end
;=============================================================================



;=============================================================================
; strcat_radec_regions
;
;=============================================================================
function _______strcat_radec_regions, radec0, field, ramins, ramaxes, decmins, decmaxes

 n = n_elements(ramins)

 radec1 = transpose([transpose(ramins), $
                        transpose(decmins), make_array(1,n,val=1d)])
 radec2 = transpose([transpose(ramins), $
                        transpose(decmaxes), make_array(1,n,val=1d)])
 radec3 = transpose([transpose(ramaxes), $
                        transpose(decmaxes), make_array(1,n,val=1d)])
 radec4 = transpose([transpose(ramaxes), $
                        transpose(decmins), make_array(1,n,val=1d)])

 bd = bod_inertial()
 v0 = bod_radec_to_body(bd, radec0) ## make_array(n,val=1d)

 ;------------------------------------------------------
 ; regions whose corners fall within fov
 ;------------------------------------------------------
 v1 = bod_radec_to_body(bd, radec1)
 v2 = bod_radec_to_body(bd, radec2)
 v3 = bod_radec_to_body(bd, radec3)
 v4 = bod_radec_to_body(bd, radec4)

 theta1 = v_angle(v0, v1) 
 theta2 = v_angle(v0, v2) 
 theta3 = v_angle(v0, v3) 
 theta4 = v_angle(v0, v4) 

 f2 = field/2

 w = where((theta1 LE f2) OR (theta2 LE f2) OR (theta3 LE f2) OR (theta4 LE f2))
 if(w[0] NE -1) then return, w


 ;------------------------------------------------------
 ; regions [[]]
 ;------------------------------------------------------
 theta1_min = min(theta1)
 theta2_min = min(theta2)
 theta3_min = min(theta3)
 theta4_min = min(theta4)

 w1 = where(theta1 EQ theta1_min)
 w2 = where(theta2 EQ theta2_min)
 w3 = where(theta3 EQ theta3_min)
 w4 = where(theta4 EQ theta4_min)

 theta_min = min([theta1_min, theta2_min, theta3_min, theta4_min])

 if(theta1_min EQ theta_min) then result = append_array(result, w1)
 if(theta2_min EQ theta_min) then result = append_array(result, w2)
 if(theta3_min EQ theta_min) then result = append_array(result, w3)
 if(theta4_min EQ theta_min) then result = append_array(result, w4)

stop
 return, result
end
;=============================================================================
