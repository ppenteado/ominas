;=============================================================================
; stress_movie_sheets
;
;=============================================================================
pro stress_movie_sheets, cd, pd, sund, array_ptd, names, r=r, $
                                np=np, density_fn=density_fn, $
                            all_ray_ptd=all_ray_ptd, all_shadow_ptd=all_shadow_ptd

 narray = n_elements(array_ptd) 


 all_ray_ptd = 0
 all_shadow_ptd = 0
 for i=0, narray-1 do $
  begin
   pnt_get, array_ptd[i], name=name, v=r, /visible
   name = str_split(name, ':')
   name = name[n_elements(name)-1]

   w = where(strupcase(names) EQ strupcase(name))
   if((w[0] NE -1) OR (NOT keyword_set(names))) then $
    begin
     if(keyword_set(r)) then $
      begin
       r_body = bod_inertial_to_body_pos(pd, r)
       v_body = glb_surface_normal(pd, r_body)
       v = bod_body_to_inertial(pd, v_body)

       ray_ptd = pg_ray(/cat, r=r, v=v, cd=cd, len=(glb_radii(pd))[0]/5, $
                                              np=np, density_fn=density_fn)
       pg_shadow_points, cd=cd, od=sund, bx=pd, ray_ptd, shadow_ptd, /nosolve
       pg_hide_globe, cd=cd, gbx=pd, ray_ptd
       pg_hide_globe, cd=cd, gbx=pd, shadow_ptd
       all_ray_ptd = append_array(all_ray_ptd, ray_ptd)
       all_shadow_ptd = append_array(all_shadow_ptd, shadow_ptd)
      end
    end
  end


end
;=============================================================================
