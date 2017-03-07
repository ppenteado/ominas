;=============================================================================
;+
; NAME:
;	pg_get_arrays
;
;
; PURPOSE:
;	Obtains a array descriptor for the given data descriptor.  
;
;
; CATEGORY:
;	NV/PG
;
;
; CALLING SEQUENCE:
;	result = pg_get_arrays(dd)
;	result = pg_get_arrays(dd, trs)
;
;
; ARGUMENTS:
;  INPUT:
;	dd:	data descriptor
;
;	trs:	String containing keywords and values to be passed directly
;		to the translators as if they appeared as arguments in the
;		translators table.  These arguments are passed to every
;		translator called, so the user should be aware of possible
;		conflicts.  Keywords passed using this mechanism take 
;		precedence over keywords appearing in the translators table.
;
;  OUTPUT: NONE
;
;
; KEYWORDS:
;  INPUT:
;	ard:		Input array descriptors; used by some translators.
;
;	override:	Create a data descriptor and initilaize with the 
;			given values.  Translators will not be called.
;
;	arr_*:		All array override keywords are accepted.  See
;			array_keywords.include. 
;
;			If name is specified, then only descriptors with
;			those names are returned.
;
;	verbatim:	If set, the descriptors requested using name
;			are returned in the order requested.  Otherwise, the 
;			order is determined by the translators.
;
;	tr_override:	String giving a comma-separated list of translators
;			to use instead of those in the translators table.  If
;			this keyword is specified, no translators from the 
;			table are called, but the translators keywords
;			from the table are still used.  
;
;
; RETURN:
;	Array of array descriptors, 0 if an error occurs.
;
;
; PROCEDURE:
;	If /override, then a array descriptor is created and initialized
;	using the specified values.  Otherwise, the descriptor is obtained
;	through the translators.  Note that if /override is not used,
;	values (except name) can still be overridden by specifying 
;	them as keyword parameters.  If name is specified, then
;	only descriptors corresponding to those names will be returned.
;	
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale, 10/2012
;	
;-
;=============================================================================
function pg_get_arrays, dd, trs, od=od, bx=bx, ard=_ard, $
                          override=override, verbatim=verbatim, $
@arr__keywords.include
@nv_trs_keywords_include.pro
		end_keywords

 ;-----------------------------------------------
 ; dereference the generic descriptor if given
 ;-----------------------------------------------
 if(NOT keyword_set(bx)) then bx = dat_gd(gd, dd=dd, /bx)


 ;-----------------------------------------------
 ; call translators
 ;-----------------------------------------------

 ;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
 ; if names requested, the force tr_first
 ;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;; if(keyword_set(name)) then tr_first = 1
;tr_first = 1

 ard = dat_get_value(dd, 'ARR_DESCRIPTORS', key1=od, key2=bx, key4=_ard, key6=primary, $$
                             key8=name, trs=trs, $
@nv_trs_keywords_include.pro
	end_keywords)

 if(NOT keyword_set(ard)) then return, obj_new()

 n = n_elements(ard)

 ;---------------------------------------------------
 ; If name given, determine subscripts such that
 ; only values of the named objects are returned.
 ;
 ; Note that each translator has this opportunity,
 ; but this code guarantees that it is done.
 ;
 ; If arr_name is not given, then all descriptors
 ; will be returned.
 ;---------------------------------------------------
 if(keyword__set(name)) then $
  begin
   tr_names = cor_name(ard)
   sub = nwhere(strupcase(tr_names), strupcase(name))
   if(sub[0] EQ -1) then return, obj_new()
   if(NOT keyword__set(verbatim)) then sub = sub[sort(sub)]
  end $
 else sub=lindgen(n)

 n = n_elements(sub)
 ard = ard[sub]


 ;--------------------------------------------------------
 ; update generic descriptors
 ;--------------------------------------------------------
 if(keyword_set(dd)) then dat_set_gd, dd, gd, bx=bx
 dat_set_gd, ard, gd, bx=bx

 return, ard
end
;===========================================================================








