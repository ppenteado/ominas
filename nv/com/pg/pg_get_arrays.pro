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
;	no_sort:	Unless this keyword is set, only the first descriptor 
;			encountered with a given name is returned.  This allows
;			translators to be arranged in the translators table such
;			by order of priority.
;
;	override:	Create a data descriptor and initilaize with the 
;			given values.  Translators will not be called.
;
;	arr_*:		All array override keywords are accepted.  See
;			array_keywords.include. 
;
;			If arr_name is specified, then only descriptors with
;			those names are returned.
;
;	verbatim:	If set, the descriptors requested using arr_name
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
;	values (except arr_name) can still be overridden by specifying 
;	them as keyword parameters.  If arr_name is specified, then
;	only descriptors corresponding to those names will be returned.
;	
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale, 10/2012
;	
;-
;=============================================================================
function pg_get_arrays, dd, trs, od=od, bx=bx, ard=_ard, gd=gd, no_sort=no_sort, $
                          override=override, verbatim=verbatim, $
@array_keywords.include
@nv_trs_keywords_include.pro
		end_keywords

 ;-----------------------------------------------
 ; dereference the generic descriptor if given
 ;-----------------------------------------------
 pgs_gd, gd, dd=dd, bx=bx


 ;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
 ; if names requested, the force tr_first
 ;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
 if(keyword_set(arr__name)) then tr_first = 1
;tr_first = 1

 ards = dat_get_value(dd, 'ARR_DESCRIPTORS', key1=od, key2=bx, key4=_ard, key6=arr__primary, $$
                             key8=arr__name, trs=trs, $
@nv_trs_keywords_include.pro
	end_keywords)

 if(NOT keyword_set(ards)) then return, obj_new()

 n = n_elements(ards)

 ;---------------------------------------------------
 ; If arr__name given, determine subscripts such that
 ; only values of the named objects are returned.
 ;
 ; Note that each translator has this opportunity,
 ; but this code guarantees that it is done.
 ;
 ; If arr_name is not given, then all descriptors
 ; will be returned.
 ;---------------------------------------------------
 if(keyword__set(arr__name)) then $
  begin
   tr_names = cor_name(ards)
   sub = nwhere(strupcase(tr_names), strupcase(arr__name))
   if(sub[0] EQ -1) then return, obj_new()
   if(NOT keyword__set(verbatim)) then sub = sub[sort(sub)]
  end $
 else sub=lindgen(n)

 n = n_elements(sub)
 ards = ards[sub]


 ;------------------------------------------------------------
 ; Make sure that for a given name, only the first 
 ; descriptor obtained from the translators is returned.
 ; Thus, translators can be arranged in order in the table
 ; such the the first occurence has the highest priority.
 ;------------------------------------------------------------
 if(NOT keyword_set(no_sort)) then ards = ards[pgs_name_sort(cor_name(ards))]


 return, ards
end
;===========================================================================








