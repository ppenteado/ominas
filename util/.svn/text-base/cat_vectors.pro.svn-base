;=============================================================================
;+
; NAME:
;       cat_vectors
;
;
; PURPOSE:
;       To concatenate arrays of column vectors
;
;
; CATEGORY:
;       UTIL
;
;
; CALLING SEQUENCE:
;       result = cat_vectors(ps)
;
;
; ARGUMENTS:
;  INPUT:
;       ps:     An array of vector arrays.
;
;  OUTPUT:
;       NONE
;
; RETURN:
;       Concatenated array of column vectors.
;
;
; STATUS:
;       Completed.
;
;
; MODIFICATION HISTORY:
;       Written by:     Spitale
;
;-
;=============================================================================
function cat_vectors, ps

 n_ps=n_elements(ps)

 ;-----------------------------------
 ; set up concatenated vectors array
 ;-----------------------------------
 nn=intarr(n_ps)
 nnt=intarr(n_ps)
 ntot=intarr(n_ps)
 for i=0, n_ps-1 do $
  begin
   s=size(*ps[i])
   nn[i]=s[1]
   if(s[0] EQ 3) then nnt[i]=s[3] $
   else nnt[i]=1

   ntot[i]=nn[i]*nnt[i]
  end
 n_vectors=total(ntot)

 vectors=dblarr(n_vectors,3)


 ;----------------------------------
 ; populate the vectors array
 ;----------------------------------
 n=0
 for i=0, n_ps-1 do $
  begin
   vectors[n:n+nn[i]*nnt[i]-1,*]=*ps[i]
   n=n+nn[i]*nnt[i]
  end


 return, vectors
end
;===========================================================================
