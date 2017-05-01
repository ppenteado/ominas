;=============================================================================
;++
; NAME:
;	dawn_cmat_to_orient_fc
;
;
; PURPOSE:
;	Converts Dawn C matrix to a OMINAS camera orientation matrix.
;
;
; CATEGORY:
;	NV/CONFIG
;
;
; CALLING SEQUENCE:
;	result = dawn_cmat_to_orient(cmat)
;
;
; ARGUMENTS:
;  INPUT:
;	cmat:	Dawn C matrix
;
;  OUTPUT:
;	NONE
;
;
; KEYWORDS:
;  INPUT:
;	NONE
;
;  OUTPUT:
;	NONE
;
;
; RETURN:
;	OMINAS camera orientation matrix.
;
;
; PROCEDURE:
;	
;
;					    / Zcm
;					  /
;			         	  ------ Xcm 	C matrix
;					|
;			   /|\		|
;			    |		| Ycm
;			  lines
;			 ---------
;			|	  |
;	   		|	  |  samples --> 
;			|	  |
;			 ---------
;	    Z	|	 
;		|	   
;    OMINAS	|  / Y    
;		|/
;		 ------- X
;
;
;
; STATUS:
;	Complete
;
;
; SEE ALSO:
;	dawn_orient_to_cmat
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale, 1/2002
;	
;-
;=============================================================================
function dawn_cmat_to_orient_fc, cmat

 s = size(cmat)
 if(s[0] EQ 2) then n = 1 $
 else n = s[3]

 orient = dblarr(3,3,n, /nozero)

; cmat to ominas (according to Dawn NAC diagram):
 orient[0,*,*] =  cmat[*,0,*]
 orient[1,*,*] =  cmat[*,2,*]
 orient[2,*,*] =  cmat[*,1,*]

 orient[0,*,*] =  -cmat[*,0,*]
 orient[1,*,*] =  cmat[*,2,*]
 orient[2,*,*] =  -cmat[*,1,*]




 return, orient
end
;=============================================================================
