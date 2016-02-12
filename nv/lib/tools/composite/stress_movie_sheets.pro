;=============================================================================
; stress_movie_sheets
;
;=============================================================================
pro stress_movie_sheets, cd, pd, sund, array_ps, names, r=r, $
                                np=np, density_fn=density_fn, $
                            all_ray_ps=all_ray_ps, all_shadow_ps=all_shadow_ps

 narray = n_elements(array_ps) 


 all_ray_ps = 0
 all_shadow_ps = 0
 for i=0, narray-1 do $
  begin
   ps_get, array_ps[i], name=name, v=r, /visible
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

       ray_ps = pg_ray(/cat, r=r, v=v, cd=cd, len=(glb_radii(pd))[0]/5, $
                                              np=np, density_fn=density_fn)
       pg_shadow_points, cd=cd, od=sund, bx=pd, ray_ps, shadow_ps, /nosolve
       pg_hide_globe, cd=cd, gbx=pd, ray_ps
       pg_hide_globe, cd=cd, gbx=pd, shadow_ps
       all_ray_ps = append_array(all_ray_ps, ray_ps)
       all_shadow_ps = append_array(all_shadow_ps, shadow_ps)
      end
    end
  end


end
;=============================================================================
