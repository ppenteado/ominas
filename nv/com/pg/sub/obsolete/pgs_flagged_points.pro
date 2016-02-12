;===========================================================================
; pgs_flagged_points.pro
;
;===========================================================================
pro pgs_flagged_points, pp, mask=mask, val=val, $
                            points=points, $
                            vectors=vectors, $
                            flags=flags, $
                            data=data, name=name, desc=desc, input=input, sub=w
nv_message, /con, name='pgs_flagged_points', 'This routine is obsolete.'
 nv_notify, pp, type = 1

 if(NOT ptr_valid(pp.points_p)) then return

 if(NOT defined(val)) then val = mask

 ;---------------------------------------------------
 ; get flags and determine which points are flagged
 ;---------------------------------------------------
 xflags = *pp.flags_p

 xval = xflags AND mask
 w = where(xval EQ val)

 if(w[0] EQ -1) then $
  begin
   points=0
   vectors=0
   flags=0
   data=0
   tags=0
   name=''
   desc=''
   input=''
   return
  end

 pgs_size, pp, nn=nn, nt=nt, nd=nd

 ;-----------------------------------------------------------------
 ; if there are more than one timestep, then need to rearrange
 ;-----------------------------------------------------------------
 sf = size(xflags)
 if(sf[0] EQ 2) then $
  begin
   if(arg_present(points)) then if(ptr_valid(pp.points_p)) then cpoints = reform(*pp.points_p, 2,nn*nt)
   if(arg_present(vectors)) then if(ptr_valid(pp.vectors_p)) then cvectors = reform(*pp.vectors_p, nn*nt,3)
   if(arg_present(data)) then if(ptr_valid(pp.data_p)) then cdata = reform(*pp.data_p, nd, nn*nt)
   if(ptr_valid(pp.flags_p)) then cflags = reform(*pp.flags_p, nn*nt)
  end $
 else $
  begin
   if(arg_present(points)) then if(ptr_valid(pp.points_p)) then cpoints = *pp.points_p
   if(arg_present(vectors)) then if(ptr_valid(pp.vectors_p)) then cvectors = *pp.vectors_p
   if(arg_present(data)) then if(ptr_valid(pp.data_p)) then cdata = *pp.data_p
   if(ptr_valid(pp.flags_p)) then cflags = *pp.flags_p
  end

 ;-----------------------------
 ; extract the flagged points
 ;-----------------------------
 if(keyword_set(cpoints)) then points = cpoints[*,w]
 if(keyword_set(cvectors)) then vectors = cvectors[w,*]
 if(keyword_set(cdata)) then data = cdata[*,w]
; if(keyword_set(cdata)) then data = cdata[w,*]
 flags = cflags[w]
 name = pp.name
 desc = pp.desc
 input = pp.input
 if(ptr_valid(pp.tags_p)) then tags = *pp.tags_p


end
;===========================================================================
