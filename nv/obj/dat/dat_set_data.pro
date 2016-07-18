;=============================================================================
;+
; NAME:
;	dat_set_data
;
;
; PURPOSE:
;	Replaces the data array associated with a data descriptor.
;
;
; CATEGORY:
;	NV/SYS
;
;
; CALLING SEQUENCE:
;	dat_set_data, dd, data
;
;
; ARGUMENTS:
;  INPUT:
;	dd:	Data descriptor.
;
;	data:	New data array.
;
;  OUTPUT:
;	dd:	Modified data descriptor.
;
;
; KEYWORDS:
;  INPUT: 
;	abscissa: If set, the given array is taken as the abscissa.
;
;	update:	Update mode flag.  If not given, it will be taken from dd.
;
;	silent:	If set, messages are suppressed.
;
;  OUTPUT: NONE
;
;
; RETURN: NONE
;
;
; STATUS:
;	Complete
;
;
; SEE ALSO:
;	dat_data
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale, 2/1998
; 	Adapted by:	Spitale, 5/2016
;	
;-
;=============================================================================
pro dat_set_data, dd, _data, silent=silent, update=update, noevent=noevent, abscissa=_abscissa
@core.include
 _dd = cor_dereference(dd)

 if(NOT defined(update)) then update = _dd.update
 if(update EQ -1) then return

 if((NOT keyword_set(silent)) and (_dd.maintain GT 0)) then $
  nv_message, /con, name='dat_set_data', $
   'WARNING: Changes to data array may be lost due to the maintainance level.'


 ;--------------------------------------------
 ; compress data if necessary
 ;--------------------------------------------
 if(keyword_set(_abscissa)) then abscissa = _abscissa
 if(keyword_set(_dd.compress)) then $
     data = call_function('dat_compress_data_' + _dd.compress, _dd, _data, abscissa=abscissa) $
 else data = _data


 ;--------------------------------------------
 ; modify data array if update = 0
 ;--------------------------------------------
 if(NOT keyword_set(update)) then $
  begin
   dap = 0
   if(keyword_set(_dd.data_dap)) then dap = _dd.data_dap
   data_archive_set, dap, data, index=_dd.dap_index
   _dd.data_dap = dap

   if(keyword_set(abscissa)) then $
    begin
     dap = 0
     if(keyword_set(_dd.abscissa_dap)) then dap = _dd.abscissa_dap
     data_archive_set, dap, abscissa, index=_dd.dap_index
     _dd.abscissa_dap = dap
    end

   _dd.dap_index = 0

   if(NOT ptr_valid(_dd.dim_p)) then _dd.dim_p = nv_ptr_new(0)
   if(keyword_set(_data)) then *_dd.dim_p = size(_data, /dim)
  end


 ;-----------------------------------------------------------------------------
 ; if update = 1, put the new data on a new descriptor; output the new pointer
 ;-----------------------------------------------------------------------------
 if(update EQ 1) then $
  begin
   dd_new = nv_clone(dd)
   dat_set_sibling, dd, dd_new
   dat_set_data, dd_new, data, update=0, abscissa=abscissa
   dd = dd_new
  end


 ;----------------------------------------------
 ; update type code
 ;----------------------------------------------
 _dd.type = size(data, /type)
 _dd.min = min(data)
 _dd.max = max(data)

 ;----------------------------------------------
 ; generate write event on original descriptor
 ;----------------------------------------------
 cor_rereference, dd, _dd
 nv_notify, dd, type=0, desc='DATA', noevent=noevent
 nv_notify, /flush, noevent=noevent

end
;===========================================================================



