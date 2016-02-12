;===========================================================================
; pgs_uncat_ps
;
;===========================================================================
pro pgs_uncat_ps, ps0, ps, flags=flags, points=points, vectors=vectors
nv_message, /con, name='pgs_uncat_ps', 'This routine is obsolete.'

 n = n_elements(ps0)

 offset = 0
 for i=0, n-1 do $
  begin
   if(ptr_valid(ps0[i].flags_p)) then $
    begin
     np = n_elements(*ps0[i].flags_p)
     ii = lindgen(np) + offset

     if(keyword_set(flags)) then *ps0[i].flags_p = (*ps.flags_p)[ii]

     if(keyword_set(points)) then $
       if(ptr_valid(ps0[i].points_p)) then *ps0[i].points_p = (*ps.points_p)[*,ii]
     if(keyword_set(vectors)) then $
       if(ptr_valid(ps0[i].vectors_p)) then *ps0[i].vectors_p = (*ps.vectors_p)[ii,*]
;     if(ptr_valid(ps0[i].tags_p)) then 

     offset = offset + np
    end
  end




end
;===========================================================================
