;=============================================================================
;+
; NAME:
;	pgs_compress
;
;
; PURPOSE:
;	Compresses many points structs into one.  Arrays are concatenated
;	in the nv/np directions unless /nt is specified.  Point-by-point data
;	arrays must be identical.
;
;
; CATEGORY:
;	NV/PGS
;
;
; CALLING SEQUENCE:
;	new_ps = pgs_compress(ps)
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
; 	Written by:	Spitale		11/2015
;	
;-
;=============================================================================
function pgs_compress, ps, nt=nt
nv_message, /con, name='pgs_compress', 'This routine is obsolete.'

 ;--------------------------------
 ; set up compressed arrays
 ;--------------------------------
 pgs_points, ps[0], tags=tags			; assume all data arrays identical
 ndat = n_elements(tags)

 np = total(ps.npoints)
 if(np EQ 0) then return, pgs_null()
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
   pgs_points, ps[i], p=p, v=v, flags=f, name=nam, data=dat
   if(ps[i].npoints GT 0) then $
    begin
     pp[*,jj:jj+ps[i].npoints-1] = p
     vv[jj:jj+ps[i].npoints-1,*] = v
     ff[jj:jj+ps[i].npoints-1] = f
     data[*,jj:jj+ps[i].npoints-1] = dat
     names[i] = nam
    end
   jj = jj + ps[i].npoints
  end
 name = str_comma_list(names)

 if(keyword_set(nt)) then $
  begin
   pp = reform(pp, 2,ps[0].npoints,nps, /over)
   vv = reform(vv, ps[0].npoints,3,nps, /over)
   ff = reform(ff, ps[0].npoints,nps, /over)
   data = reform(data, ndat,ps[0].npoints,nps, /over)
  end


 ;-------------------------------------------
 ; create the compressed points structure
 ;-------------------------------------------
 pps = nv_clone(ps[0])
 pps = pgs_set_points(pps, p=pp, v=vv, flags=ff, name=name, data=data)


 return, pps
end
;=============================================================================



