;=============================================================================
;+
; NAME:
;       get_username
;
;
; PURPOSE:
;       To obtain the username of the person running the function
;
;
; CATEGORY:
;       UTIL
;
;
; CALLING SEQUENCE:
;       result = get_username()
;
;
; ARGUMENTS:
;       NONE
;
; RETURN:
;       String variable containing the username.  This routine is operating
;       system dependent and only works for unix and VMS currently.
;
;
; STATUS:
;       Completed.
;
;
; MODIFICATION HISTORY:
;       Written by:     Spitale
;
;-
;=============================================================================
function get_username

 case !version.os_family of $
	'unix' :	return, getenv('USER')
	'vms' :		return, getenv('USER')
	'Windows':	return, 'Not Available'
	'MacOS' :	return, 'Not Available'
	default :	return, 'Not Available'
 endcase

end
;===========================================================================



