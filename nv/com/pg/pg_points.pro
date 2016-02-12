;=============================================================================
;+
; NAME:
;	pg_points
;
;
; PURPOSE:
;	Concatenates the given points_structs into an array of image
;	points.
;
;
; CATEGORY:
;	NV/PG
;
;
; CALLING SEQUENCE:
;	result = pg_points(object_ps)
;
;
; ARGUMENTS:
;  INPUT:
;	object_ps:	Array of points_struct.	
;
; KEYWORDS:
;  INPUT: 
;	all:	If set, all points are returned, regardless of flag settings.
;
;	name:	If set, points are returned only from points structures
;		with the these names.
;
;  OUTPUT: NONE
;
;
; RETURN:
;	Array (2,n) of image points.
;
;
; STATUS:
;	Complete
;
;
; SEE ALSO:
;	pg_vectors
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale, 2/1998
;	Rewritten: 	Spitale, 12/2015
;	
;-
;=============================================================================
function pg_points, ps, sample=_sample, all=all, name=get_name
@ps_include.pro

 if(NOT keyword__set(ps)) then return, 0
 n_ps = n_elements(ps)

 if(NOT keyword__set(_sample)) then _sample = 1
 if(n_elements(_sample) EQ 1) then sample = make_array(n_ps, val=_sample) $
 else sample = _sample
 sample = float(sample)

 names = ps_name(ps)


 ;----------------------------------
 ; set up concatenated points array
 ;----------------------------------
 pp = ptrarr(n_ps)
 ntot = lonarr(n_ps)

 for i=0, n_ps-1 do if(ps_valid(ps[i])) then $
  begin
   continue = 0
   if(NOT keyword__set(get_name)) then continue = 1 $
   else if(get_name EQ names[i]) then continue = 1
   if(continue) then $
    begin
     ps_get, ps[i], flags=flags, points=p, nv=np, nt=nt
     ntot[i] = 0
     w = lindgen(n_elements(flags))

     if(NOT keyword_set(all)) then w = where((flags AND PS_MASK_INVISIBLE) EQ 0)
     if(w[0] NE -1) then $
      begin
       p = congrid((reform(p, 2,np*nt))[*,w], 2,ceil(n_elements(w)/sample[i]))
       pp[i] = nv_ptr_new(p)
       ntot[i] = n_elements(p)/2
      end
    end
  end

 n_points = total(ntot)
 if(n_points EQ 0) then return, 0
 points = dblarr(2,n_points, /nozero)


 ;----------------------------------
 ; populate the points array
 ;----------------------------------
 n=0
 for i=0, n_ps-1 do $
  if(ptr_valid(pp[i])) then $
   begin
    points[*,n:n+ntot[i]-1] = *pp[i]

    n = n + ntot[i]
    nv_ptr_free, pp[i]
   end


 return, points
end
;=============================================================================
