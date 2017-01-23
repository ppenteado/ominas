;=============================================================================
;+-+
; NAME:
;	dh_std_input
;
;
; PURPOSE:
;	Input translator for detached header
;
;
; CATEGORY:
;	NV/CONFIG
;
;
; CALLING SEQUENCE(only to be called by dat_get_value):
;	result = dh_std_input(dd, keyword)
;
;
; ARGUMENTS:
;  INPUT:
;	dd:		Data descriptor.
;
;	keyword:	String giving the name of the translator quantity to
;			read.
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
;	status:		Zero if valid data is returned
;
;
;  TRANSLATOR KEYWORDS:
;	history:	History index to use in matching the keyword.  If not 
;			specified, the keyowrd with the highest history index
;			is matched.
;
;
; RETURN:
;	Data associated with the requested keyword.
;
;
; STATUS:
;	Complete
;
;
; SEE ALSO:
;	dh_std_output
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale, 1998
;	
;-
;=============================================================================



;=============================================================================
; dhsi_associate_object
;
;=============================================================================
function dhsi_associate_object, name, dd, all_xds

 if(name EQ cor_name(dd)) then return, dd

 w = where(name EQ cor_name(all_xds))
 xd = all_xds[w]

 w = where(cor_assoc_xd(xd) EQ dd)

 return, xd[w[0]]
end
;=============================================================================



;=============================================================================
; dhsi_get
;
;=============================================================================
function dhsi_get, dh, prefix, dd, all_xds, obj=obj, hi=hi

 ;--------------------------
 ; create blank objects
 ;--------------------------
 fn = prefix + '_create_descriptors'
 xd = call_function(fn, 1)
 _xd = cor_dereference(xd)

 ;--------------------------
 ; get object fields
 ;--------------------------
 fields = tag_names(_xd[0])
 nfields = n_elements(fields)

 ;------------------------------------------------------
 ; read fields from dh; first 3 fields are internal
 ;------------------------------------------------------
 for i=3, nfields-1 do $
  begin
   field = fields[i]
   continue = 1

   ;- - - - - - - - - - - - - - - - - - - - - - - - - - - -
   ; ignore user data (for now)
   ;- - - - - - - - - - - - - - - - - - - - - - - - - - - -
   p = strpos(field, 'UDATA')
   if(p[0] NE -1) then continue = 0

   if(continue) then $
    begin   
     ;- - - - - - - - - - - - - - - - - - - - - - - - - - - -
     ; create the field name
     ;- - - - - - - - - - - - - - - - - - - - - - - - - - - -
     name = dh_field_name(field, prefix)

     ;- - - - - - - - - - - - - - - - - - - - - - - - - - - -
     ; read object field
     ;- - - - - - - - - - - - - - - - - - - - - - - - - - - -
     val = dh_get_value(dh, name, history_index=hi, obj=obj, $
                                               section=section, /all_match)

     ;- - - - - - - - - - - - - - - - - - - - - - - - - - - -
     ; populate object field
     ;- - - - - - - - - - - - - - - - - - - - - - - - - - - -
     type = size(_xd.(i), /type)

     if(keyword_set(val)) then $
      begin
       if(type LE 7) then _xd.(i) = val $
       else if(type EQ 11) then $
                       _xd.(i) = dhsi_associate_object(val[0], dd, all_xds) $
       else if(type EQ 10) then if(ptr_valid(_xd.(i))) then *_xd.(i) = val $
       else nv_message, 'Invalid object member type: ' + name
      end

     ;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
     ; handle ASSOC field specially: assign to dd if not matched
     ;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
     if(field EQ 'ASSOC') then if(NOT keyword_set(_xd.(i))) then _xd.(i) = dd
    end   
  end

 return, _xd
end
;=============================================================================



;=============================================================================
; dh_std_input
;
;=============================================================================
function dh_std_input, dd, keyword, values=values, status=status, $
@nv_trs_keywords_include.pro
@nv_trs_keywords1_include.pro
	end_keywords
common dhsi_block, all_xds


 status = -1
 n_obj = 0
 prefix = strlowcase(str_nnsplit(keyword, '_'))
 fn = prefix + '_create_descriptors'

 ;-----------------------------------------------
 ; translator keywords
 ;-----------------------------------------------
 history = tr_keyword_value(dd, 'history')
 if(keyword_set(history)) then hi = fix(history)


 ;------------------------------------------------------------
 ; primary planet descriptors (key4) must not be present
 ;------------------------------------------------------------
 if(keyword_set(key4)) then $
  begin
   status = -1
   return, 0
  end


 ;-----------------------------------------------
 ; get descriptors
 ;-----------------------------------------------
 xds = !null
 ndd = n_elements(dd)
 for j=0, ndd-1 do $
  begin
   ;- - - - - - - - - - - - - - - - -
   ; get detached header
   ;- - - - - - - - - - - - - - - - -
   dh = dh_get(dd[j])
   if(NOT keyword_set(dh)) then return, 0

   ;- - - - - - - - - - - - - - - - -
   ; determine # objects
   ;- - - - - - - - - - - - - - - - -
   name = dh_get_string(dh, prefix + '_name', n_obj=n_obj, hi=hi, status=status)

   ;- - - - - - - - - - - - - - - - -
   ; get descriptors
   ;- - - - - - - - - - - - - - - - -
   for i=0, n_obj-1 do $
           _xd = append_array(_xd, $
                          dhsi_get(dh, prefix, dd[j], all_xds, obj=i, hi=hi))

   xd = !null
   if(keyword_set(_xd)) then $
    begin
     xd = call_function(fn, n_obj)
     cor_rereference, xd, _xd
    end

   ;- - - - - - - - - - - - - - - - -
   ; add to output list
   ;- - - - - - - - - - - - - - - - -
   xds = append_array(xds, xd)
  end


 ;------------------------------------------------------------
 ; record all xds that have been loaded via this translator
 ;------------------------------------------------------------
 all_xds = unique(append_array(all_xds, xds))

 return, xds
end
;===========================================================================
