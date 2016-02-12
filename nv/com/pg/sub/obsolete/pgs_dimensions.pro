;=============================================================================
;+
; NAME:
;	pgs_dimensions
;
;
; PURPOSE:
;	Determines dimensions of the points arrays on the given input 
;	points arrays.
;
;
; CATEGORY:
;	NV/PGS
;
;
; CALLING SEQUENCE:
;	pgs_dimensions, ps, nv=nv, nt=nt
;
;
; ARGUMENTS:
;  INPUT:
;	ps:		Array of points structures.
;
;  OUTPUT: NONE
;
;
; KEYWORDS:
;  INPUT: NONE
;
;  OUTPUT: 
;	nv:	Number of vectors/points.
;
;	nt:	Number of timesteps/dimensions.
;
;	npoints: Same as nv, but faster because it simply returns the 
;		 npionts fiend from the points struct.
;
;
; RETURN: NONE
;
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale		9/2012
;	
;-
;=============================================================================
pro pgs_dimensions, ps, nv=nv, nt=nt, npoints=npoints
nv_message, /con, name='pgs_dimensions', 'This routine is obsolete.'

 npoints = ps.npoints
 if(arg_present(npoints)) then return

 pgs_count_descriptors, ps, nd=nd, nt=ntt

 nv = lonarr(nd,ntt)
 nt = lonarr(nd,ntt)

 for i=0, nd-1 do $
  for j=0, ntt-1 do $
   begin
    pgs_points, ps[i,j], v=v, p=p
    if(keyword_set(v)) then $
     begin
      dim = size(v, /dim)
      nv = dim[0]
     end $
    else if(keyword_set(v)) then $
     begin
      dim = size(p, /dim)
      nv = dim[1]
     end
 
    nt = 1
    if(n_elements(dim GT 2)) then nt = dim[2]
   end


end
;=============================================================================
