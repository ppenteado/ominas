;=============================================================================
;++
; NAME:
;	dawn_orient_to_cmat
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
;	result = dawn_orient_to_cmat(cmat)
;
;
; ARGUMENTS:
;  INPUT:
;	orient:		OMINAS camera orientation matrix.
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
;	Dawn C matrix.
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
;	dawn_cmat_to_orient
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale, 1/2002
;	
;-
;=============================================================================
function dawn_orient_to_cmat, orient

 s = size(orient)
 if(s[0] EQ 2) then n = 1 $
 else n = s[3]

 cmat = dblarr(3,3,n, /nozero)

; ominas to cmat (according to Dawn NAC diagram):
 cmat[*,0,*] =  orient[0,*,*]
 cmat[*,1,*] =  orient[2,*,*] 
 cmat[*,2,*] =  orient[1,*,*]

 cmat[*,0,*] =  -orient[0,*,*]
 cmat[*,1,*] =  -orient[2,*,*] 
 cmat[*,2,*] =  orient[1,*,*]

 return, cmat
end
;=============================================================================
