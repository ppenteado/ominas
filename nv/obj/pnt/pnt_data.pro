;=============================================================================
;+
; NAME:
;	pnt_data
;
;
; PURPOSE:
;	Returns the point-by-point data associated with a POINT object.
;
;
; CATEGORY:
;	NV/OBJ/PNT
;
;
; CALLING SEQUENCE:
;	data = pnt_data(ptd)
;
;
; ARGUMENTS:
;  INPUT:
;	ptd:	POINT object.  If multiple POINT object are given, 
;		and /cat is not specified, only pointers to the arrays are 
;		returned, and conditions and tags are not applied.
;
;  OUTPUT: NONE
;
;
; KEYWORDS:
;  INPUT: 
;	tags:	If given, data arrays are returned only for these tags,
;		and are arranged in this order.
;
;	condition:	Structure specifing a mask and a condition with which to
;			match flag values.  The structure must contain the fields
;			MASK and STATE.  MASK is a bitmask to test against
;			the flags field of the POINT object, and STATE
;			is either PS_TRUE and PS_FALSE.  Note that in this case, 
;			the values will be returned as a list, with no separation 
;			into nv and nt dimensions.
;
;	cat:		If set, arrays from mulitple input objets are 
;			concatenated.
;
;	sample:		Sampling interval in the nv direction.  Default is 1.
;
;	<condition>:	All of the predefined conditions (e.g. /visible) are 
;			accepted; see pnt_condition_keywords.include.
;
;	noevent:	If set, no event is generated.
;
;  OUTPUT: NONE
;
;
; RETURN:
;	The point-by-point data associated with the POINT object.
;
;
; STATUS:
;	Complete
;
;
; SEE ALSO:
;	pnt_set_data
;
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale, 11/2015
;	
;-
;=============================================================================
function pnt_data, ptd0, tags=select_tags, $
    sample=sample, cat=cat, condition=condition, noevent=noevent, $
@pnt_condition_keywords.include
end_keywords

 condition = pnt_condition(condition=condition, $
@pnt_condition_keywords.include 
end_keywords)

 ptd = ptd0
 if(keyword_set(cat)) then ptd = pnt_compress(ptd)

 nv_notify, ptd, type = 1, noevent=noevent
 _ptd = cor_dereference(ptd)

 result = _pnt_data(_ptd, condition=condition, tags=select_tags, ii=ii)

 if(keyword_set(cat)) then nv_free, ptd

 if(keyword_set(sample)) then $
  begin
   ii = lindgen(_ptd.nv/sample)*sample
   result = result[*,ii]
  end

 return, result
end
;===========================================================================
