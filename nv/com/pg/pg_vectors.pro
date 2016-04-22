;=============================================================================
;+
; NAME:
;	pg_vectors
;
;
; PURPOSE:
;	Concatenates the given points_structs into an array of inertial
;	vectors.
;
;
; CATEGORY:
;	NV/PG
;
;
; CALLING SEQUENCE:
;	result = pg_vectors(ps)
;
;
; ARGUMENTS:
;  INPUT:
;	ps:	Array of points_struct.	
;
;
;
; RETURN:
;	Array (n,3) of inertial vectors.
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
function pg_vectors, ps, sample=_sample, all=all, name=get_name
@ps_include.pro

 if(NOT keyword__set(ps)) then return, 0
 n_ps = n_elements(ps)

 if(NOT keyword__set(_sample)) then _sample = 1
 if(n_elements(_sample) EQ 1) then sample = make_array(n_ps, val=_sample) $
 else sample = _sample
 sample = float(sample)

 names = cor_name(ps)


 ;----------------------------------
 ; set up concatenated vectors array
 ;----------------------------------
 vv = ptrarr(n_ps)
 ntot = lonarr(n_ps)

 for i=0, n_ps-1 do if(ps_valid(ps[i])) then $
  begin
   continue = 0
   if(NOT keyword__set(get_name)) then continue = 1 $
   else if(get_name EQ names[i]) then continue = 1
   if(continue) then $
    begin
     ps_get, ps[i], flags=flags, vectors=v, nv=np, nt=nt
     ntot[i] = 0
     w = lindgen(n_elements(flags))

     if(NOT keyword_set(all)) then w = where((flags AND PS_MASK_INVISIBLE) EQ 0)
     if(w[0] NE -1) then $
      begin
       v = congrid((reform(v, np*nt,3))[w,*], ceil(n_elements(w)/sample[i]),3)
       vv[i] = nv_ptr_new(v)
       ntot[i] = n_elements(v)/3
      end
    end
  end

 n_vectors = total(ntot)
 if(n_vectors EQ 0) then return, 0
 vectors = dblarr(n_vectors,3, /nozero)


 ;----------------------------------
 ; populate the vectors array
 ;----------------------------------
 n=0
 for i=0, n_ps-1 do $
  if(ptr_valid(vv[i])) then $
   begin
    vectors[n:n+ntot[i]-1,*] = *vv[i]

    n = n + ntot[i]
    nv_ptr_free, vv[i]
   end


 return, vectors
end
;=============================================================================
