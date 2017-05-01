;=============================================================================
;+
; NAME:
;	_cor_test_udata
;
;
; PURPOSE:
;	Tests the existence of data stored in a structure under the 
;	specified name.
;
;
; CATEGORY:
;	NV/LIB/COR
;
;
; CALLING SEQUENCE:
;	data = _cor_test_udata(_crd, name)
;
;
; ARGUMENTS:
;  INPUT:
;	_crd:	 Any subclass of CORE.  Only one structure may be provided.
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
; 	Written by:	Spitale, 1/2017
;	
;-
;=============================================================================
function _cor_test_udata, _crd, name
 if(NOT ptr_valid(_crd.udata_tlp)) then return, 0
 return, (tag_list_match(_crd.udata_tlp, name) NE -1)[0]
end
;=============================================================================
