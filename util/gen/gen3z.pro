;=============================================================================
;+
; NAME:
;	gen3z
;
;
; PURPOSE:
;	Constructs nx x ny x nz array of subscripts with values incrementing 
;	in the z direction.
;
;
; CATEGORY:
;	UTIL/GEN
;
;
; CALLING SEQUENCE:
;	sub = gen3x(nx, ny, nz)
;
;
; ARGUMENTS:
;  INPUT:
;	nx:	 Number of elements in the x direction.
;
;	ny:	 Number of elements in the y direction.
;
;	nz:	 Number of elements in the z direction.
;
;
;  OUTPUT: NONE
;
;
; KEYWORDS:
;  INPUT:  NONE
;
;  OUTPUT: NONE
;
;
; RETURN:
;	Array (nx x ny x nz) of subscripts.
;
;
; STATUS:
;	Complete
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale
;	
;-
;=============================================================================
function gen3z, nx, ny, nz
; return, reform(tr(fix(findgen(nz*ny)/ny)#make_array(nx,val=1)),nx,ny,nz,/over)
 return, reform(transpose((lindgen(nz*ny)/ny)# $
                                        make_array(nx,val=1)),nx,ny,nz,/over)
end
;===========================================================================
