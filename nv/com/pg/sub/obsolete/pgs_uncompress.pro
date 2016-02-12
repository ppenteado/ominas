;=============================================================================
;+
; NAME:
;	pgs_uncompress
;
;
; PURPOSE:
;	Explodes a compressed points structure back into an array of points
;	structures using the original points structures as a template.  The 
;	compressed points structure is freed.
;
;
; CATEGORY:
;	NV/PGS
;
;
; CALLING SEQUENCE:
;	new_ps = pgs_uncompress(pps, ps)
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
; 	Written by:	Spitale		11/2015
;	
;-
;=============================================================================
function pgs_uncompress, pps, _ps, nn=nn
nv_message, /con, name='pgs_uncompress', 'This routine is obsolete.'

 if(NOT keyword_set(nn)) then nn = 1 

 ;-------------------------------------------
 ; clone template
 ;-------------------------------------------
 ps = nv_clone(_ps)


 ;-------------------------------------------
 ; get compressed arrays
 ;-------------------------------------------
 pgs_points, pps, tags=tags
 ndat = n_elements(tags)
 nps = n_elements(ps)
 np = pps.npoints/nn
 pgs_points, pps, p=pp, v=vv, flags=ff, name=name, data=data

 pp = reform(pp, 2,np,nn, /over)
 vv = reform(vv, np,3,nn, /over)
 ff = reform(ff, np,nn, /over)
 data = reform(data, ndat,np,nn, /over)


 ;--------------------------------
 ; uncompress arrays
 ;--------------------------------
 for i=(jj=0), nps-1 do $
  begin
   nnp = ps[i].npoints

   p = reform(pp[*,jj:jj+nnp-1,*], 2,nnp*nn)
   v = reform(vv[jj:jj+nnp-1,*,*], nnp*nn,3)
   f = reform(ff[jj:jj+nnp-1,*], nnp*nn)
   dat = reform(data[*,jj:jj+nnp-1,*], ndat,nnp*nn)
   ps[i] = pgs_set_points(ps[i], p=p, v=v, flags=f, name=nam, data=dat, tags=tags)

   tag_list_free, ps[i].udata_tlp
   ps[i].udata_tlp = tag_list_clone(pps.udata_tlp)

   jj = jj + nnp
  end


 ;-------------------------------------------
 ; free compressed points struct
 ;-------------------------------------------
 nv_free, pps

 return, ps
end
;=============================================================================




