;=============================================================================
;+
; NAME:
;	cor_dereference_gd
;
;
; PURPOSE:
;	Dereferences a generic descriptor.
;
;
; CATEGORY:
;	NV/PGS
;
;
; CALLING SEQUENCE:
;	xds = cor_dereference_gd(gd, <descriptor output keywords>)
;
;
; ARGUMENTS:
;  INPUT:
;	gd:	Generic descriptor.  
;
;	name:	If given, only descriptors whose names appear in this array
;		will be returned.  If no descriptor keywords are
;		speciied (see below), then all fields are searched for
;		descriptors with these names.
;
;  OUTPUT: NONE
;
;
; KEYWORDS:
;  INPUT: 
;	<x>d:	Standard descriptor keywords.  Setting a keyword causes the
;		corresponding field of the generic descriptor to be returned.
;
;  OUTPUT: NONE
;
;
; RETURN: 
;	Array of descriptors or zero if no fields found.   
;
;
;
; MODIFICATION HISTORY:
;	Moved to CORE	Spitale		2/2017
;	
;-
;=============================================================================
function cor_dereference_gd, gd, name=name, _ref_extra=keys

 if(NOT keyword_set(gd)) then return, !null
 xds = !null

 gdtags = tag_names(gd)
 nkeys = n_elements(keys)

 ;-----------------------------------
 ; build output list
 ;-----------------------------------
 for i=0, nkeys-1 do $
  begin
   w = where(gdtags EQ keys[i])
   if(w[0] NE -1) then xds = append_array(xds, gd.(w[0]))
  end

 ;-----------------------------------
 ; filter output list
 ;-----------------------------------
 if(keyword_set(name)) then $
  begin
   if(NOT keyword_set(keys)) then xds = cor_cat_gd(gd)

   w = nwhere(cor_name(xds), name)
   if(w[0] EQ -1) then return, !null
   xds = unique(xds[w])
  end

 return, xds
end
;===========================================================================
