;=============================================================================
;+
; NAME:
;	ps_compress
;
;
; PURPOSE:
;	Compresses many points structs into one.  Arrays are concatenated
;	in the nv/np directions unless /nt is specified.  Point-by-point data
;	arrays must be identical.
;
;
; CATEGORY:
;	NV/SYS/PS
;
;
; CALLING SEQUENCE:
;	new_ps = ps_compress(ps)
;
;
; ARGUMENTS:
;  INPUT:
;	ps:	Array of points structures.
;
;  OUTPUT: NONE
;
;
; KEYWORDS:
;  INPUT: 
;	nt:		If given, arrays are concatenated in the nt dimension.
;			this requires that all input arrays have the same number
;			of points (nv/np), and only one element in the nt 
;			direction.
;
;  OUTPUT: NONE
;
;
; RETURN:
;	Points structure containing the concatenated data.
;
;
;
; MODIFICATION HISTORY:
;  Spitale, 11/2015; 	Adapted from pgs_compress
;	
;-
;=============================================================================
function ps_compress, _ps, nt=nt

 ;--------------------------------
 ; set up compressed arrays
 ;--------------------------------
 ps = ps_cull(_ps, /nofree)
 if(NOT keyword_set(ps)) then return, ptr_new()

 tags = ps_tags(ps[0])				; assume all data arrays identical
 ndat = n_elements(tags)
 nv0 = ps_nv(ps[0])
 nvv = ps_nv(ps)

 np = total(nvv)
 if(np EQ 0) then return, ptr_new()

 nps = n_elements(ps)

 pp = dblarr(2,np)
 vv = dblarr(np,3)
 ff = bytarr(np)
 names = strarr(nps)
 data = dblarr(ndat,np)


 ;--------------------------------
 ; compress arrays
 ;--------------------------------
 for i=(jj=0), nps-1 do $
  begin
   ps_get, ps[i], points=p, vectors=v, flags=f, data=dat, name=nam, nv=nv

   if(nv GT 0) then $
    begin
     pp[*,jj:jj+nv-1] = p
     vv[jj:jj+nv-1,*] = v
     ff[jj:jj+nv-1] = f
     data[*,jj:jj+nv-1] = dat
     names[i] = nam
    end
  jj = jj + nv
  end
 name = str_comma_list(names)

 if(keyword_set(nt)) then $
  begin
   pp = reform(pp, 2,nv0,nps, /over)
   vv = reform(vv, nv0,3,nps, /over)
   ff = reform(ff, nv0,nps, /over)
   data = reform(data, ndat,nv0,nps, /over)
  end


 ;-------------------------------------------
 ; create the compressed points structure
 ;-------------------------------------------
 pps = ps_template(ps[0])
 ps_set, pps, points=pp, vectors=vv, flags=ff, data=data, name=name


 return, pps
end
;=============================================================================



