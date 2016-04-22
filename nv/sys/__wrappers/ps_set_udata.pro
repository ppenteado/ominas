;=============================================================================
;+
; NAME:
;	ps_set_udata
;
;
; PURPOSE:
;	Creates or replaces a user data array associated with a points struct.
;
;
; CATEGORY:
;	NV/SYS
;
;
; CALLING SEQUENCE:
;	ps_set_udata, ps, uname, udata
;
;
; ARGUMENTS:
;  INPUT:
;	ps:	Points struct.
;
;	udata:	New user data array.
;
;  OUTPUT: NONE
;
;
; KEYWORDS:
;  INPUT: 
;	name:		String giving the name of the user data array.  If the 
;			name exists, then the corresponding data array is 
;			replaced.  Otherwise, a new array is created with this 
;			name. 
;
;	noevent:	If set, no event is generated.
;
;  OUTPUT: NONE
;
;
; RETURN: NONE
;
;
; STATUS:
;	Complete
;
;
; SEE ALSO:
;	ps_udata
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale, 11/2015
;	
;-
;=============================================================================
pro ps_set_udata, psp, name=uname, udata, noevent=noevent
cor_set_udata, psp, uname, udata, noevent=noevent
return



@nv.include
 ps = nv_dereference(psp)

 ;-----------------------------
 ; modify udata array 
 ;-----------------------------
 if(NOT keyword_set(uname)) then ps.udata_tlp = udata $
 else $
  begin
   tlp = ps.udata_tlp
   tag_list_set, tlp, uname, udata
   ps.udata_tlp = tlp
  end

 ;--------------------------------------------
 ; generate write event
 ;--------------------------------------------
 nv_rereference, psp, ps
 if(NOT keyword_set(noevent)) then $
  begin
   nv_notify, psp, type = 0, noevent=noevent
   nv_notify, /flush, noevent=noevent
  end
end
;===========================================================================



