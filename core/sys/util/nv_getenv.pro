;=============================================================================
;+
; NAME:
;	nv_getenv
;
;
; PURPOSE:
;	Obtains variables from the environment, allowing for abbreviations.
;
;
; CATEGORY:
;	NV/SYS
;
;
; CALLING SEQUENCE:
;	result = nv_getenv(var)
;
;
; ARGUMENTS:
;  INPUT:
;	var:		Name of environment variable.
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
; RETURN: NONE
;
;
; STATUS:
;	Complete
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale, 2/2020
;	
;-
;=============================================================================
function nv_getenv, var, data=data, method=method

 ;--------------------------------------------------------
 ; try full variable name
 ;--------------------------------------------------------
 val = getenvs(var)
 if(keyword_set(val)) then return, val


 ;--------------------------------------------------------
 ; otherwise try abbreviating OMINAS to OM or removing
 ; the prefix altogether
 ;--------------------------------------------------------
 prefix = str_nnsplit(var, '_', rem=name)
 if(prefix EQ 'OMINAS') then $
  begin
   val = getenvs('OM_' +  name)
   if(keyword_set(val)) then return, val

   val = getenvs(name)
   if(keyword_set(val)) then return, val
  end


 return, ''
end
;=============================================================================




;=============================================================================
function __nv_getenv, var

 ;--------------------------------------------------------
 ; try full variable name
 ;--------------------------------------------------------
 val = getenv(var)
 if(keyword_set(val)) then return, val

 prefix = str_nnsplit(var, '_', rem=name)

 ;--------------------------------------------------------
 ; otherwise try abbreviating OMINAS to OM
 ;--------------------------------------------------------
 if(prefix EQ 'OMINAS') then $
  begin
   val = getenv('OM_' +  name)
   if(keyword_set(val)) then return, val
  end

 return, ''
end
;=============================================================================
