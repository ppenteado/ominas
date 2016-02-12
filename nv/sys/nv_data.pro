;=============================================================================
;+
; NAME:
;	nv_data
;
;
; PURPOSE:
;	Returns the data array associated with a data descriptor.
;
;
; CATEGORY:
;	NV/SYS
;
;
; CALLING SEQUENCE:
;	data = nv_data(dd)
;
;
; ARGUMENTS:
;  INPUT:
;	dd:	Data descriptor.
;
;  OUTPUT: NONE
;
;
; KEYWORDS:
;  INPUT: 
;	samples:  Samping indices.  If set, only these data elements are
;		  returned.  May be 1D or the same number of dimensions as
;		  the data array.   
;
;	nd:       If set, the samples input is taken to be an ND coordinate
;	          rather than a 1D subscript.  nv_data can normally tell
;	          the difference automatically, but there is an ambiguity
;	          if a single ND point is requested.  In that case, nv_data
;	          interprets that as an array of 1D subscripts, unless /nd
;	          is set.
;
;	true:     If set, the actual data array is returned, even if there is
;	          a sampling function.
;
;  OUTPUT: NONE
;
;
; RETURN:
;	The data array associated with the data descriptor.
;
;
; STATUS:
;	Complete
;
;
; SEE ALSO:
;	nv_set_data
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale, 2/1998
;	
;-
;=============================================================================
function nv_data, ddp, samples=_samples, nd=nd, true=true
@nv.include
 nv_notify, ddp, type = 1
 dd = nv_dereference(ddp)

 sampled = 0

 if(NOT ptr_valid(dd.data_dap)) then return, 0

 ;-------------------------------------------------------------------------
 ; If there is a sampling function, but no samples are given, then 
 ; generate sampling for the entire data array.  This way the sampling
 ; function always gets called and a sensible result is obtained.
 ;-------------------------------------------------------------------------
 full_array = 0
 if(keyword_set(dd.sampling_fn) $
        AND (NOT keyword_set(_samples)) $
               AND NOT keyword_set(true)) then $
   begin
    _samples = gridgen(*dd.dim_p) 
    full_array = 1
   end


 ;-------------------------------------------------------------------------
 ; sampling
 ;-------------------------------------------------------------------------
 if(keyword_set(_samples)) then $
  begin
   ; - - - - - - - - - - - - - - - - -
   ; call sampling function
   ; - - - - - - - - - - - - - - - - -
   samples = _samples
   if(keyword_set(dd.sampling_fn)) then $
      samples = call_function(dd.sampling_fn, ddp, samples, $
                                              *(dd.sampling_fn_data_p))

   ; - - - - - - - - - - - - - - - - -
   ; convert samples to 1D
   ; - - - - - - - - - - - - - - - - -
   samples = round(samples)
   sdim = size(samples, /dim)
   if((n_elements(sdim) NE 1) OR keyword_set(nd)) then $
                                 samples = nd_to_w(*(dd.dim_p), samples)
  end



 ;-------------------------------------------------------------------------
 ; Load data array if necessary. 
 ;  Need to add sampling to this call to allow sampling portions of huge
 ;  files.  The problem is that we need to know whether to reload a data 
 ;  array that has previously been subsampled.
 ;-------------------------------------------------------------------------
 if(NOT data_archive_defined(dd.data_dap, dd.dap_index)) then nv_load_data, ddp
 dd = nv_dereference(ddp)


 ;-------------------------------------------------------------------------
 ; Compression
 ;-------------------------------------------------------------------------
 if(NOT keyword_set(dd.compress)) then $
  begin
   data = data_archive_get(dd.data_dap, dd.dap_index, samples=samples)
   if(keyword_set(data)) then sampled = 1
  end $
 else $
  begin
   data = data_archive_get(dd.data_dap, dd.dap_index)
   data = call_function('nv_uncompress_data_' + dd.compress, dd, data)
  end


 ;-------------------------------------------------------------------------
 ; Sample if not already sampled
 ;-------------------------------------------------------------------------
 if(defined(samples)) then $
  begin
   if(NOT sampled) then data = data[samples]

   w = where(samples EQ -1)
   if(w[0] NE -1) then samples[w] = 0
  end


 ;-------------------------------------------------------------------------
 ; If possible, reorganize to the proper dimensions.  This is not possible
 ; if the data array is being subsampled.
 ;-------------------------------------------------------------------------
 if(full_array) then data = reform(data, *dd.dim_p, /over)


 ;-------------------------------------------------------------------------
 ; compute data ranges
 ;-------------------------------------------------------------------------
 max = max(data)
 min = min(data)

 if(max GT dd.max) then dd.max = max
 if(min LT dd.min) then dd.min = min

 nv_rereference, ddp, dd

 return, data
end
;===========================================================================



