;=============================================================================
;+
; NAME:
;	cor_create_gd
;
;
; PURPOSE:
;	Creates a generic descriptor from a set of given descriptors.
;
;
; CATEGORY:
;	NV/OBJ/COR
;
;
; CALLING SEQUENCE:
;	new_gd = cor_create_gd(xds, gd=gd, <descriptor output keywords>
;
;
; ARGUMENTS:
;  INPUT: 
;	xds:	Array of descriptors.  If given, any generic descriptors 
;		contained within these descriptors are also included (unless 
;		/explicit).  A generic descriptor may also be given as the
;		argument to this function.
;
;  OUTPUT: NONE
;
;
; KEYWORDS:
;  INPUT: 
;	gd:	Generic descriptor.  Fields from this descriptor will be
;		included in the output.
;
;	<x>d:	Input keyword for each descriptor type to include in 
;		new generic descriptor.
;
;	explicit:
;		If set, generic descriptors contained in input descriptors
;		are not included in the output.
;
;  OUTPUT: NONE
;
;
; RETURN: 
;	Generic descriptor containing all of the input fields, and any 
;	descripors contained in gd.  Any invalid objects are culled out.
;
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale		
;	Moved to CORE	Spitale		2/2017
;	
;-
;=============================================================================
function cor_create_gd, _xds, gd=_gd, explicit=explicit, _extra=gdx

 if(keyword_set(_gd)) then gd = _gd
 if(keyword_set(_xds)) then xds = _xds

 ;------------------------------------------------------
 ; test whether gd given as argument instead of xds 
 ;------------------------------------------------------
 if((NOT keyword_set(gd)) AND keyword_set(xds)) then $
  if(NOT cor_test(xds)) then $
   begin
    gd = xds
    xds = !null
   end

 ;------------------------------------------------------
 ; get objects from implicit gds
 ;------------------------------------------------------
 if(NOT keyword_set(explicit)) then $
            for i=0, n_elements(xds)-1 do $
                     xds = append_array(xds, cor_cat_gd(cor_gd(xds[i])))


 ;------------------------------------------------------
 ; add explicit objects
 ;------------------------------------------------------
 xds = append_array(xds, cor_cat_gd(gd))
 xds = append_array(xds, cor_cat_gd(gdx))
 if(NOT keyword_set(xds)) then return, !null

 ;------------------------------------------------------
 ; cull out dead objects
 ;------------------------------------------------------
 w = where(obj_valid(xds))
 if(w[0] EQ -1) then return, !null
 xds = xds[w]

 ;------------------------------------------------
 ; put all xds into a new generic descriptor
 ;------------------------------------------------
 all_tags = cor_tag(xds)
 tags = unique(all_tags)
 for i=0, n_elements(tags)-1 do $
  begin
   w = where(all_tags EQ tags[i])
   ww = where(obj_valid(xds[w]))
   new_gd = append_struct(new_gd, create_struct(tags[i], unique(xds[w[ww]])))
  end

 return, new_gd
end
;=============================================================================



;=============================================================================
function ___cor_create_gd, _xds, gd=_gd, explicit=explicit, _extra=gdx

 if(keyword_set(_gd)) then gd = _gd
 if(keyword_set(_xds)) then xds = _xds

 ;------------------------------------------------------
 ; test whether gd given as argument instead of xds 
 ;------------------------------------------------------
 if((NOT keyword_set(gd)) AND keyword_set(xds)) then $
  if(NOT cor_test(xds)) then $
   begin
    gd = xds
    xds = !null
   end

 ;------------------------------------------------------
 ; get objects from implicit gds
 ;------------------------------------------------------
 if(NOT keyword_set(explicit)) then $
            for i=0, n_elements(xds)-1 do $
                     xds = append_array(xds, cor_cat_gd(cor_gd(xds[i])))


 ;------------------------------------------------------
 ; add explicit objects
 ;------------------------------------------------------
 xds = append_array(xds, cor_cat_gd(gd))
 xds = append_array(xds, cor_cat_gd(gdx))


 ;-------------------------------------------------
 ; sort xds into descriptor keyword arrays 
 ;-------------------------------------------------
 if(keyword_set(xds)) then $
  for i=0, n_elements(xds)-1 do if(obj_valid(xds[i])) then $
   begin
    tag = (cor_tag(xds[i]))[0]
    stat = execute(tag + '=unique(append_array(' + tag + ', xds[i]))')
    all_tags = append_array(all_tags, tag)
   end
 if(NOT keyword_set(all_tags)) then return, !null
 all_tags = unique(all_tags)


 ;------------------------------------------------
 ; put all xds into a new generic descriptor
 ;------------------------------------------------
 for i=0, n_elements(all_tags)-1 do $
            stags = append_array(stags, all_tags[i]+':'+all_tags[i]) 
 stat = execute('new_gd={' + str_comma_list(stags) + '}')


 return, new_gd
end
;=============================================================================
