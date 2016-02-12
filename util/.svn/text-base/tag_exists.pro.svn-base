;=============================================================================
;+
; NAME:
;	tag_exists
;
;
; PURPOSE:
;	Determines whether a structure contains a given field.
;
;
; CATEGORY:
;	UTIL
;
;
; CALLING SEQUENCE:
;	result = tag_exists(struct, tag)
;
;
; ARGUMENTS:
;  INPUT:
;	struct:	Structure to test.
;
;	tag:	String giving tag name to test for.
;
; RETURN:
;	True if the tag exists, false otherwise.
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale, 8/28/2001
;	
;-
;=============================================================================
function tag_exists, struct, tag
 return, (where(tag_names(struct) EQ tag))[0] NE -1
end
;=============================================================================
