;=============================================================================
;+
; NAME:
;	nv_extract_sn
;
;
; PURPOSE:
;	Extracts serial numbers from given descriptors.
;
;
; CATEGORY:
;	NV/SYS
;
;
; CALLING SEQUENCE:
;	result = nv_extract_sn(xd)
;
;
; ARGUMENTS:
;  INPUT:
;	xd:	Array of descriptors.
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
;	Array of extracted serial numbers; 0 if not found.
;
;
; PROCEDURE:
;	If the second field of the given descriptor is a long, then it is 
;	assumed to be the serial number.  Otherwise, the first field is assumed
;	to be a descriptor and that one is checked for a long in the second
;	position.  The process is repeated until a serial number is found or 
;	no sub-descriptor is found.
;
;
; STATUS:
;	Complete
;
;
; SEE ALSO:
;	nv_get_sn
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale, 6/2002
;	
;-
;=============================================================================
function nv_extract_sn, xdp
@nv.include
 xd = nv_dereference(xdp)


 while(1) do $
  begin
   ;-------------------------------------------------------
   ; if second field is long, then return its value
   ;-------------------------------------------------------
   if(size(xd[0].(1), /type) EQ 3) then return, xd.(1)

   ;-------------------------------------------------------------
   ; Otherwise, if first field is not a pointer, return 0
   ;-------------------------------------------------------------
   if(size(xd[0].(0), /type) NE 10) then return, 0

   ;-------------------------------------------------------
   ; Otherwise, repeat using first field as descriptor
   ;-------------------------------------------------------
   xd = nv_dereference(xd.(0))
  end


end
;=============================================================================
