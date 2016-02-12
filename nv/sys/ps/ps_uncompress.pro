;=============================================================================
;+
; NAME:
;	ps_uncompress
;
;
; PURPOSE:
;	Explodes a compressed points structure back into an array of points
;	structures using the original points structures as a template.  The 
;	compressed points structure is freed.
;
;
; CATEGORY:
;	NV/SYS/PS
;
;
; CALLING SEQUENCE:
;	new_ps = ps_uncompress(pps, ps)
;
;
; ARGUMENTS:
;  INPUT:
;	pps:	Compressed points structure.
;
;	ps:	Array of original points structures.  Must be in the same order
;		as when compressed.
;
;  OUTPUT: NONE
;
;
; KEYWORDS:
;  INPUT: 
;	nn:		If given, it is assumed that there are nn elements
;			in the compressed array for each element in the 
;			original input arrays. 
;
;  OUTPUT: NONE
;
;
; RETURN:
;	Array of points structures containing the uncompressed data.
;
;
;
; MODIFICATION HISTORY:
;  Spitale, 11/2015; 	Adapted from pgs_uncompress
;	
;-
;=============================================================================
function ps_uncompress, pps, _ps, nn=nn

 if(NOT keyword_set(nn)) then nn = 1 

 ;-------------------------------------------
 ; clone template
 ;-------------------------------------------
 ps = nv_clone(_ps)


 ;-------------------------------------------
 ; get compressed arrays
 ;-------------------------------------------
 tags = ps_tags(pps)
 ndat = n_elements(tags)
 nps = n_elements(ps)
 np = ps_nv(pps)/nn

 pp = ps_points(pps)
 vv = ps_vectors(pps)
 ff = ps_flags(pps)
 data = ps_data(pps)
 name = ps_name(pps)

 pp = reform(pp, 2,np,nn, /over)
 vv = reform(vv, np,3,nn, /over)
 ff = reform(ff, np,nn, /over)
 data = reform(data, ndat,np,nn, /over)


 ;--------------------------------
 ; uncompress arrays
 ;--------------------------------
 for i=(jj=0), nps-1 do $
  begin
   nnp = ps_nv(ps[i])

   p = reform(pp[*,jj:jj+nnp-1,*], 2,nnp*nn)
   v = reform(vv[jj:jj+nnp-1,*,*], nnp*nn,3)
   f = reform(ff[jj:jj+nnp-1,*], nnp*nn)
   dat = reform(data[*,jj:jj+nnp-1,*], ndat,nnp*nn)
   ps_set, ps[i], p=p, v=v, flags=f, name=nam, data=dat, tags=tags

   tag_list_free, ps_udata(ps[i])
   ps_set_udata, ps[i], ps_udata(pps)

   jj = jj + nnp
  end


 ;-------------------------------------------
 ; free compressed points struct
 ;-------------------------------------------
 nv_free, pps

 return, ps
end
;=============================================================================




