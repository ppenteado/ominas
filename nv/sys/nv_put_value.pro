;=============================================================================
;+
; NAME:
;	nv_put_value
;
;
; PURPOSE:
;	Calls output translators, supplying the given keyword and value.
;
;
; CATEGORY:
;	NV/SYS
;
;
; CALLING SEQUENCE:
;	nv_put_value, dd, keyword, value
;
;
; ARGUMENTS:
;  INPUT:
;	dd:		Data descriptor.
;
;	keyword:	Keyword to pass to translators, describing the
;			requested quantity.
;
;	value:		Value to write through the translators.
;
;  OUTPUT: NONE
;
;
; KEYWORDS:
;  INPUT: 
;	trs:		Transient argument string.
;
;	tr_disable:	If set, nv_get_value returns without performing 
;			any action.
;
;	tr_override:	Comma-delimited list of translators to use instead
;			of those stored in dd.
;
;	tr_first:	If set, nv_get_value returns after the first
;			successful translator.
;
;  OUTPUT: 
;	status:		0 if at least one translator call was successful, 
;			-1 otherwise.
;
;
; RETURN: NONE
;
;
; STATUS:
;	Complete
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale
;	
;-
;=============================================================================
pro nv_put_value, ddp, keyword, value, trs=trs, status=status, $
@nv_trs_keywords_include.pro
@nv_trs_keywords1_include.pro
                             end_keywords
@nv.include

 status = 0

; on_error, 1
 dd = nv_dereference(ddp)

 if(keyword__set(tr_disable)) then return

 if(NOT ptr_valid(dd.output_translators_p)) then $
  begin
   status = -1
   return
  end
;        nv_message, 'No output translator available for '+keyword+'.', $
;                                                           name='nv_put_value'


 ;--------------------------------------------
 ; record any transient keyvals
 ;--------------------------------------------
 nv_add_transient_keyvals, dd, trs

 ;--------------------------------------------
 ; send value through all output translators
 ;--------------------------------------------
; i=0
; translators=*dd.output_translators_p
; n=n_elements(translators)

 if(NOT keyword__set(tr_override)) then translators=*dd.output_translators_p $
 else translators = $
           nv_match(*dd.output_translators_p, str_nsplit(tr_override, ','))
 n=n_elements(translators)

 for i=0, n-1 do $
  begin
   dd.last_translator = [i,1]
   nv_rereference, ddp, dd
   call_procedure, translators[i], ddp, keyword, value, stat=stat, $
@nv_trs_keywords_include.pro
@nv_trs_keywords1_include.pro
                      end_keywords
   dd = nv_dereference(ddp)
  end


 nv_rereference, ddp, dd
end
;===========================================================================
