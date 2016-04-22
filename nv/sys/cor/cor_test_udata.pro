;=============================================================================
;+
; NAME:
;	cor_test_udata
;
;
; PURPOSE:
;	Tests the existence of data stored in a descriptor under the 
;	specified name.
;
;
; CATEGORY:
;	NV/LIB/COR
;
;
; CALLING SEQUENCE:
;	data = cor_test_udata(crx, name)
;
;
; ARGUMENTS:
;  INPUT:
;	crx:	 Any subclass of CORE.  Only one descriptor may be provided.
;
;	name:	 Name associated with the data to test.
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
;	True if the data is stored under the given name, false otherwise.
;
;
; STATUS:
;	Complete
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale, 1/1998
;	
;-
;=============================================================================
function cor_test_udata, crxp, name, noevent=noevent
@nv_lib.include
 crdp = class_extract(crxp, 'CORE')
 nv_notify, crdp, type = 1, noevent=noevent
 crd = nv_dereference(crdp)

 if(NOT ptr_valid(crd.udata_tlp)) then return, 0
 return, (tag_list_match(crd.udata_tlp, name) NE -1)[0]
end
;=============================================================================
