;=============================================================================
;+
; NAME:
;	cor_rereference
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
;	cor_rereference, xd, _xd
;
;
; ARGUMENTS:
;  INPUT:
;	xd:	Array of pointers to the appropriate type of descriptor.
;
;	_xd:	Array of descriptors.
;
;  OUTPUT:
;	NONE
;
;
; KEYWORDS: 
;  INPUT:
;	new:	If set, new pointers will be allocated in xd.
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
;	cor_dereference
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale, 6/2002
; 	Adapted by:	Spitale, 5/2016
;	
;-
;=============================================================================
pro cor_rereference, xd, _xd, new=new
@core.include

 s = size(xd)
 n1 = (n2 = 1)
 if(s[0] GT 0) then n1 = s[1]
 if(s[0] GT 1) then n2 = s[2]

 for j=0, n2-1 do $
  for i=0, n1-1 do $
   begin
    ii = j*n1 + i
    x = xd[ii]
    if(obj_valid(x)) then x.rereference, _xd[ii]
    xd[ii] = x
   end


end
;=============================================================================
