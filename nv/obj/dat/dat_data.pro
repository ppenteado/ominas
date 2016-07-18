;=============================================================================
;+
; NAME:
;	dat_data
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
;	data = dat_data(dd)
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
;	abscissa: If set, the abscissa array is returned instead of the data 
;		  array.
;
;	samples:  Sampling indices.  If set, only these data elements are
;		  returned.  May be 1D or the same number of dimensions as
;		  the data array.   
;
;	nd:       If set, the samples input is taken to be an ND coordinate
;	          rather than a 1D subscript.  dat_data can normally tell
;	          the difference automatically, but there is an ambiguity
;	          if a single ND point is requested.  In that case, dat_data
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
;	dat_set_data
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale, 2/1998
; 	Adapted by:	Spitale, 5/2016
;	
;-
;=============================================================================
function dat_data, dd, samples=_samples, nd=nd, true=true, noevent=noevent, abscissa=_abscissa
@core.include
 nv_notify, dd, type = 1, noevent=noevent
 _dd = cor_dereference(dd)

 sampled = 0

 if(NOT ptr_valid(_dd.data_dap)) then return, 0

 ;-------------------------------------------------------------------------
 ; If there is a sampling function, but no samples are given, then 
 ; generate sampling for the entire data array.  This way the sampling
 ; function always gets called and a sensible result is obtained.
 ;-------------------------------------------------------------------------
 full_array = 0
 if(keyword_set(_dd.sampling_fn) $
        AND (NOT keyword_set(_samples)) $
               AND NOT keyword_set(true)) then $
   begin
    _samples = gridgen(*_dd.dim_p) 
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
   if(keyword_set(_dd.sampling_fn)) then $
      samples = call_function(_dd.sampling_fn, dd, samples, $
                                              *(_dd.sampling_fn_data_p))

   ; - - - - - - - - - - - - - - - - -
   ; convert samples to 1D
   ; - - - - - - - - - - - - - - - - -
   samples = round(samples)
   sdim = size(samples, /dim)
   if((n_elements(sdim) NE 1) OR keyword_set(nd)) then $
                                 samples = nd_to_w(*(_dd.dim_p), samples)
  end



 ;-------------------------------------------------------------------------
 ; Load data array if necessary. 
 ;  Need to add sampling to this call to allow sampling portions of huge
 ;  files.  The problem is that we need to know whether to reload a data 
 ;  array that has previously been subsampled.
 ;-------------------------------------------------------------------------
 if(NOT data_archive_defined(_dd.data_dap, _dd.dap_index)) then $
                                      dat_load_data, dd, sample=samples
 _dd = cor_dereference(dd)

 ;-------------------------------------------------------------------------
 ; Compression
 ;-------------------------------------------------------------------------
 if(NOT keyword_set(_dd.compress)) then $
  begin
   data = data_archive_get(_dd.data_dap, _dd.dap_index, samples=samples)
   abscissa = data_archive_get(_dd.abscissa_dap, _dd.dap_index, samples=samples)
   if(keyword_set(data)) then sampled = 1
  end $
 else $
  begin
   data = data_archive_get(_dd.data_dap, _dd.dap_index)
   data = call_function('dat_uncompress_data_' + _dd.compress, _dd, data, abscissa=abscissa)
  end


 ;-------------------------------------------------------------------------
 ; Sample if not already sampled
 ;-------------------------------------------------------------------------
 if(defined(samples)) then $
  begin
   if(NOT sampled) then $
    begin
     data = data[samples]
     if(keyword_set(abscissa)) then abscissa = abscissa[samples]
    end

   w = where(samples EQ -1)
   if(w[0] NE -1) then samples[w] = 0
  end


 ;-------------------------------------------------------------------------
 ; If possible, reorganize to the proper dimensions.  This is not possible
 ; if the data array is being subsampled.
 ;-------------------------------------------------------------------------
 if(full_array) then $
  begin
   data = reform(data, *_dd.dim_p, /over)
   if(keyword_set(abscissa)) then abscissa = reform(abscissa, *_dd.dim_p, /over)
  end


 ;-------------------------------------------------------------------------
 ; compute data ranges -- not accurate if data array is being subsampled
 ;-------------------------------------------------------------------------
 max = max(data)
 min = min(data)

 if(max GT _dd.max) then _dd.max = max
 if(min LT _dd.min) then _dd.min = min

 cor_rereference, dd, _dd

 ;-------------------------------------------------------------------------
 ; get abscissa
 ;-------------------------------------------------------------------------
 if(keyword_set(abscissa)) then _abscissa = abscissa $
 else $
  begin
   if(keyword_set(samples)) then _abscissa = samples $
   else _abscissa = lindgen(*_dd.dim_p)
  end

 return, data
end
;===========================================================================



