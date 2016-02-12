;=============================================================================
;+
; NAME:
;	nv_rereference
;
;
; PURPOSE:
;	Copies an array of descriptors into an array of pointers to descriptors.
;
;
; CATEGORY:
;	NV/SYS
;
;
; CALLING SEQUENCE:
;	nv_rereference, dp, d
;
;
; ARGUMENTS:
;  INPUT:
;	dp:	Array of pointers to the appropriate type of descriptor.
;
;	d:	Array of descriptors.
;
;  OUTPUT:
;	NONE
;
;
; KEYWORDS: 
;  INPUT:
;	new:	If set, new pointers will be alocated in dp.
;
;  OUTPUT: NONE
;
;
; RETURN:
;	NONE
;
;
; STATUS:
;	Complete
;
;
; SEE ALSO:
;	nv_dereference
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale, 6/2002
;	
;-
;=============================================================================
pro nv_rereference, dp, d, new=new
@nv.include

 s = size(dp)
 n1 = (n2 = 1)
 if(s[0] GT 0) then n1 = s[1]
 if(s[0] GT 1) then n2 = s[2]

 for j=0, n2-1 do $
  for i=0, n1-1 do $
   begin
    ii = j*n1 + i
    if(ptr_valid(dp[ii]) AND NOT keyword_set(new)) then *dp[ii] = d[ii] $
    else dp[ii] = nv_ptr_new(d[ii])
   end


end
;=============================================================================
