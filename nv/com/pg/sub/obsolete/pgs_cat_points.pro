;===========================================================================
; pgs_cat_points.pro
;
; concatenates arrays of image points
;
; returns 0 if no visible points.
;
;===========================================================================
function pgs_cat_points, ps, flags_ps=flags_ps, sample=_sample, all=all, $
                               names=names, get_name=get_name
@pgs_include.pro
nv_message, /con, name='pgs_cat_points', 'This routine is obsolete.'
 nv_notify, ps, type = 1

 n_ps = n_elements(ps)

 if(NOT keyword__set(_sample)) then _sample = 1
 if(n_elements(_sample) EQ 1) then sample = make_array(n_ps, val=_sample) $
 else sample = _sample
 sample = float(sample)


 ;----------------------------------
 ; set up concatenated points array
 ;----------------------------------
 pp = ptrarr(n_ps)
 np = lonarr(n_ps)
 nt = lonarr(n_ps)
 ntot = lonarr(n_ps)

 for i=0, n_ps-1 do if(ptr_valid(ps[i])) then $
  begin
   continue = 0
   if(NOT keyword__set(get_name)) then continue = 1 $
   else if(get_name EQ names[i]) then continue = 1
   if(continue) then $
    begin
     p = *ps[i]
     s = size(p)

     np[i] = 1 & nt[i] = 1
     if(s[0] GE 2) then np[i]=s[2]
     if(s[0] EQ 3) then nt[i]=s[3]

     ntot[i] = 0
     w = lindgen(n_elements(*flags_ps[i]))
     if(NOT keyword__set(all)) then $
                    w = where((*flags_ps[i] AND PGS_INVISIBLE_MASK) EQ 0)
     if(w[0] NE -1) then $
      begin
       p = congrid((reform(p, 2,np[i]*nt[i]))[*,w], $
                                             2,ceil(n_elements(w)/sample[i]))
       pp[i] = nv_ptr_new(p)

       ntot[i] = n_elements(p)/2
      end
    end
  end

 n_points = total(ntot)
 if(n_points EQ 0) then return, 0
 points = dblarr(2,n_points,/nozero)


 ;----------------------------------
 ; populate the points array
 ;----------------------------------
 n=0
 for i=0, n_ps-1 do $
  if(ptr_valid(pp[i])) then $
   begin
    points[*,n:n+ntot[i]-1] = *pp[i]

    n = n+ntot[i]
    nv_ptr_free, pp[i]
   end




 return, points
end
;===========================================================================
