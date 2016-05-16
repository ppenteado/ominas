;=============================================================================
;+
; NAME:
;	dat_get_value
;
;
; PURPOSE:
;	Calls input translators, supplying the given keyword, and builds 
;	a list of  returned values.
;
;
; CATEGORY:
;	NV/SYS
;
;
; CALLING SEQUENCE:
;	values = dat_get_value(dd, keyword)
;
;
; ARGUMENTS:
;  INPUT:
;	dd:		Data descriptor.
;
;	keyword:	Keyword to pass to translators, describing the
;			requested quantity.
;
;  OUTPUT: NONE
;
;
; KEYWORDS:
;  INPUT: 
;	trs:		Transient argument string.
;
;	tr_disable:	If set, dat_get_value returns without performing 
;			any action.
;
;	tr_override:	Comma-delimited list of translators to use instead
;			of those stored in dd.
;
;	tr_first:	If set, dat_get_value returns after the first
;			successful translator.
;
;  OUTPUT: 
;	status:		0 if at least one translator call was successful, 
;			-1 otherwise.
;
;
; RETURN: 
;	Array of values returned from all successful translator calls.
;	Values are returned in the same order that the corresponding 
;	translators were called.  The dimensions are determined by the 
;	output of the first translator call.  Dimensions are (dim,n_values),
;	where n_objects is the total number of returned values (there may
;	be more than one per translator), and dim is the dimensions of 
;	each value.  If dim == 1, the dimensions of the dat_get_value result
;	are (n_values).
;
;
; STATUS:
;	Complete
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale
; 	Adapted by:	Spitale, 5/2016
;	
;-
;=============================================================================
function dat_get_value, dd, keyword, status=status, trs=trs, $
@nv_trs_keywords_include.pro
@nv_trs_keywords1_include.pro
                             end_keywords
@core.include

; on_error, 1
 _dd = cor_dereference(dd)

 status = -1
 value = 0

 if(keyword_set(tr_disable)) then return, 0

; if(NOT ptr_valid(_dd.input_translators_p)) then $
;        nv_message, 'No input translator available for '+keyword+'.', $
;                                                           name='dat_get_value'


 ;--------------------------------------------
 ; record any transient keyvals
 ;--------------------------------------------
 dat_add_transient_keyvals, _dd, trs


 ;--------------------------------------------
 ; build translators list
 ;--------------------------------------------
 if(NOT keyword_set(tr_override)) then $
  begin
   if(NOT ptr_valid(_dd.input_translators_p)) then $
    begin
     nv_message, /con, name='dat_get_value', $
              'No input translator available for '+keyword+'.'
     return, 0
    end
   translators = *_dd.input_translators_p
  end $
 else translators = $
           nv_match(*_dd.input_translators_p, str_nsplit(tr_override, ','))
 n = n_elements(translators)


 ;----------------------------------------------------------------
 ; call all translators, building a list of returned values
 ;----------------------------------------------------------------
 n_total = 0
 nmax = 0
 chunk_n = 20

 done = 0
 i = 0
 repeat $
  begin
   _dd.last_translator = [i,0]
   cor_rereference, dd, _dd
   val = call_function(translators[i], dd, keyword, $
                       n_obj=n_obj, dim=_dim, values=value, stat=stat, $
@nv_trs_keywords_include.pro
@nv_trs_keywords1_include.pro
                      end_keywords)
   if(stat EQ 0) then $
    begin
     ;-----------------------------------------------------------------------
     ; after the first translator, need to determine dimensionality and type
     ; of a single object
     ;-----------------------------------------------------------------------
     if(n_total EQ 0) then $
      begin
       s = size(val)
       type = s[s[0]+1]
       dim = _dim
       ndim = n_elements(dim)
       dim_prod = product(dim)
      end

     ;----------------------------------
     ; reallocate list if necessary
     ;----------------------------------
     if((n_total+n_obj) GT nmax) then $
      begin
       n_chunks = ceil(float(n_total+n_obj)/float(chunk_n))

       value1 = replicate(val[0], dim_prod*n_chunks*chunk_n)
       if(n_total GT 0) then value1[0:n_total-1]=value[0:n_total-1]

       value = value1
       value1 = 0

       nmax = n_chunks*chunk_n
      end

     ;----------------------------------
     ; add latest values to the list
     ;----------------------------------
     value[n_total*dim_prod:(n_total+n_obj)*dim_prod - 1] = $
                                       reform(val, dim_prod*n_obj, /overwrite)
     n_total = n_total+n_obj

     if(keyword_set(tr_first)) then done = 1
    end

   i = i + 1
  endrep until(done OR (i GE n))


 if(n_total GT 0) then $
  begin
   if(ndim EQ 1 AND dim[0] EQ 1) then vdim = [n_total] $
   else vdim = [dim,n_total]

   value = reform(value[0:n_total*dim_prod - 1], vdim, /overwrite)

   status = 0
  end


; cor_rereference, dd, _dd

 return, value
end
;===========================================================================
