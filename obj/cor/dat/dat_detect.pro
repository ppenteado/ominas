;=============================================================================
;+
; NAME:
;	dat_detect
;
;
; PURPOSE:
;	Attempts to detect the identity of a module by calling the module 
;	detector functions.  Detectors that crash are ignored and a 
;	warning is issued.  This behavior is disabled if $OMINAS_DEBUG is set.
;
;
; CATEGORY:
;	NV/SYS
;
;
; CALLING SEQUENCE:
;	name = dat_detect(dd)
;
;
; ARGUMENTS:
;  INPUT:
;	dd:		Data descriptor.  
;
;  OUTPUT: NONE
;
;
; KEYWORDS:
;  INPUT: 
;	null:      Value to return if no detectors found.
;
;	all:       If set, all names are returned.
;
;  OUTPUT: NONE
;
;
; RETURN: 
;	String giving the module name, or '' if none detected.
;
;
; STATUS:
;	Complete
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale	2/2021
;	
;-
;=============================================================================
function dat_detect, dd, detectors, null=null, all=all, _extra=arg
@nv_block.common
@core.include


 ;==============================================================
 ; Call detectors until a name is obtained.
 ;
 ; Detector crashes are handled by issuing a warning and 
 ; contnuing to the next detector.
 ;==============================================================
 strings = ''
 catch_errors = NOT keyword_set(nv_getenv('OMINAS_DEBUG'))
 for i=0, n_elements(detectors)-1 do $
  begin
   detect_fn = detectors[i]
   nv_message, verb=0.8, 'Calling detector ' + detect_fn

   if(NOT catch_errors) then err = 0 $
   else catch, err

   if(err EQ 0) then string = call_function(detect_fn, dd, arg) $
   else nv_message, /warning, $
         'Module detector ' + strupcase(detect_fn) + ' crashed; ignoring.', $
          exp='Run with OMINAS_DEBUG set to see error.'
   catch, /cancel

   if(keyword_set(string)) then $
    begin
     nv_message, verb=0.8, string + ' detected.'
     if(NOT keyword_set(all)) then return, string
     strings = append_array(strings, string)
    end
  end

 if(NOT keyword_set(strings)) then if(keyword_set(null)) then return, null
 return, strings
end
;===========================================================================
