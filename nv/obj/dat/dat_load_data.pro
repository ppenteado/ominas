;=============================================================================
;+
; NAME:
;	dat_load_data
;
;
; PURPOSE:
;	Loads the data array for a given data descriptor.  Adds to 
;	NV state maintained list if maintain == 1.
;
;
; CATEGORY:
;	NV/SYS
;
;
; CALLING SEQUENCE:
;	data = dat_load_data(dd)
;
;
; ARGUMENTS:
;  INPUT:
;	dd:	Data descriptor to test.
;
;  OUTPUT: NONE
;
;
; KEYWORDS:
;  INPUT: NONE
;
;  OUTPUT: NONE
;
;
; RETURN: 
;	Loaded data array.
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
pro dat_load_data, dd, sample=sample, data=data
@nv_block.common
@core.include
 _dd = cor_dereference(dd)


 sample0 = *_dd.sample_p
 if(data_archive_defined(_dd.data_dap, _dd.dap_index)) then $
                                             if(sample0[0] EQ -1) then return

 ;----------------------------------
 ; manage loaded data
 ;----------------------------------
 if(_dd.maintain EQ 1) then dat_manage_dd, dd
 if(NOT keyword_set(_dd.input_fn)) then return

 ;-------------------------------------------------------------
 ; determine samples such that no loaded samples are reloaded
 ;-------------------------------------------------------------
 if(keyword_set(sample)) then $
  begin
   ss = sort(sample)
   uu = uniq(sample[ss])
   requested_samples = sample[uu[ss]]

   samples_to_load = requested_samples

   if(sample0[0] NE -1) then $
    begin
;stop
     loaded_samples = set_intersection(sample0, requested_samples)
     if(loaded_samples[0] NE -1) then $
                  samples_to_load = set_difference(loaded_samples, requested_samples)
    end
   if(samples_to_load[0] EQ -1) then return
samples_to_load = sample
  end

 ;----------------------------------
 ; unload older samples if necessary
 ;----------------------------------
; if(_dd.cache NE -1) then $
;  begin
;   overflow = $
;         _dat_compute_size(_dd, [loaded_samples, samples_to_load) - _dd.cache
;   if(overflow GT 0) then $
;    begin
;     _dat_unload_samples, _dd, overflow
;    end
;  end


 ;----------------------------------
 ; read data
 ;----------------------------------
_dd.cache = 0
 if((_dd.cache NE -1) AND ptr_valid(_dd.gffp)) then $
               data = gff_read(*_dd.gffp, subscripts=samples_to_load) $
 else data = call_function(_dd.input_fn, _dd.filename, /silent, $
                       header, udata, abscissa=abscissa, sample=samples_to_load)

 ;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
 ; test whether input fn actually samples the data as requested
 ;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
 if(n_elements(data) NE n_elements(samples_to_load)) then samples_to_load = -1

 ;----------------------------------
 ; transform data
 ;----------------------------------
 data = dat_transform_input(_dd, data, header, silent=silent)

 ;----------------------------------
 ; set data on descriptor
 ;----------------------------------
 if(_dd.maintain LT 2) then $
  begin
   nv_suspend_events
   dat_set_data, dd, data, abscissa=abscissa, $
                                /silent, sample=samples_to_load
   if(keyword_set(udata)) then cor_set_udata, dd, '', udata;, /silent
   if(keyword_set(header)) then dat_set_header, dd, header, /silent
   nv_resume_events
  end

end
;=============================================================================
