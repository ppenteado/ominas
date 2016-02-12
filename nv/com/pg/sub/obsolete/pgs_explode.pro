;==============================================================================
; pgs_explode
;
;==============================================================================
function pgs_explode, ps
nv_message, /con, name='pgs_explode', 'This routine is obsolete.'

 pgs_points, ps, points=points, $
                 vectors=vectors, $
                 flags=flags, $
                 data=data, tags=tags, name=name, desc=desc, $
                 uname=uname, udata=udata, assoc_idp=assoc_idp, input=input

 dim = size(points, /dim)
 nv = dim[1]
 nt = 1
 if(n_elements(dim) GT 2) then nt = dim[2]


 pps = replicate({pg_points_struct}, nv,nt)


 for i=0, nv-1 do $
  for j=0, nt-1 do $
   begin
    pps[i,j] = pgs_set_points(pps[i,j], $
                 points=points[*,i,j], $
                 flags=flags[i,j], $
                 tags=tags, name=name, desc=desc, $
                 assoc_idp=assoc_idp, input=input)
    if(keyword_set(vectors)) then $
                  pps[i,j] = pgs_set_points(pps[i,j], vectors=vectors[i,*,j])
    if(keyword_set(data)) then $
                  pps[i,j] = pgs_set_points(pps[i,j], data=data[i,j])
    if(keyword_set(uname)) then $
                  pps[i,j] = pgs_set_points(pps[i,j], uname=uname, udata=udata)
   end

 return, pps
end
;==============================================================================
