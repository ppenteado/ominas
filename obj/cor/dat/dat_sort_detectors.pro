;=============================================================================
;+
; NAME:
;	dat_sort_detectors
;
;
; PURPOSE:
;	Parses the OMINAS_DETECTORS variable and sorts detectors into
;	instrument and filetype detectors.
;
;
; CATEGORY:
;	NV/SYS
;
;
; CALLING SEQUENCE:
;	dat_sort_detectors
;
;
; ARGUMENTS:
;  INPUT: NONE
;
;  OUTPUT: NONE
;
;
; KEYWORDS:
;  INPUT: 
;	instrument_detectors:  Names of all instrument detectors.
;
;	filetype_detectors:    Names of all filetype detectors.
;
;  OUTPUT: NONE
;
;
; RETURN: List of detector functions from the environment.
;
;
; STATUS:
;	Complete
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale; 2/2021
;	
;-
;=============================================================================
pro dat_sort_detectors, $
      instrument_detectors=instrument_detectors, $
      filetype_detectors=filetype_detectors
@nv_block.common
@core.include

 instrument_detectors = *nv_state.ins_detectors_p
 filetype_detectors = *nv_state.ftp_detectors_p

 if(keyword_set(instrument_detectors)) then return
 if(keyword_set(filetype_detectors)) then return


 ;-----------------------------------------------------------------
 ; get all detectors
 ;-----------------------------------------------------------------
 detectors = getenvs('OMINAS_DETECTORS')
 if(NOT keyword_set(detectors[0])) then $
   nv_message, name='dat_sort_detectors', /con, $
     'Unable to obtain OMINAS_DETECTORS from the environment.', $                         
       exp=['OMINAS_DETECTORS is a colon-separated list of files that are concatenated', $
            'into a single master list.']

 ;-----------------------------------------------------------------
 ; sort into filetype and instrument detectors
 ;-----------------------------------------------------------------
 for i=0, n_elements(detectors)-1 do $
  begin
   type = call_function(detectors[i], /query)
   if(type EQ 'INSTRUMENT') then $
       instrument_detectors = append_array(instrument_detectors, detectors[i])
   if(type EQ 'FILETYPE') then $
           filetype_detectors = append_array(filetype_detectors, detectors[i])
  end


 ;-----------------------------------------------------------------
 ; save results
 ;-----------------------------------------------------------------
 if(keyword_set(instrument_detectors)) then $
                      *nv_state.ins_detectors_p = instrument_detectors
 if(keyword_set(filetype_detectors)) then $
                      *nv_state.ftp_detectors_p = filetype_detectors


end
;===========================================================================



;=============================================================================
function dat_sort_detectors, env
@core.include

 detectors = getenvs(env)
 if(NOT keyword_set(detectors[0])) then $
   nv_message, name='dat_sort_detectors', /con, $
     'Unable to obtain ' + env + ' from the environment.', $                         
       exp=[env + ' is a colon-separated list of files that are concatenated', $
            'into a single master list.']
 return, detectors
end
;===========================================================================
