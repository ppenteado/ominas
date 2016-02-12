;=============================================================================
;+
; NAME:
;	gethost
;
;
; PURPOSE:
;	Determines the host machine type.
;
;
; CATEGORY:
;	UTIL
;
;
; CALLING SEQUENCE:
;	result=gethost()
;
;
; ARGUMENTS:
;  INPUT: NONE
;
;  OUTPUT: NONE
;
;
; KEYWORDS:
;  INPUT: NONE
;
;  OUTPUT:
;	status:	If no errors occur, status will be zero, otherwise
;		it will be a string giving an error message.
;
;
; RETURN:
;	String indicating the host machine type.
;
;
; STATUS:
;	Complete
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale, 5/1996
;	
;-
;=============================================================================
function gethost, status=status

 status=0

 arch=strupcase(!version.arch)

 if(strpos(arch, 'MIPSEB') NE -1) then return, 'SGI'
 if(strpos(arch, 'SPARC') NE -1) then return, 'SUN-4'
 if(strpos(arch, 'VAX') NE -1) then return, 'VAX-VMS'
 if(strpos(arch, 'ALPHA') NE -1) then return, 'DECSTATN'
 if(strpos(arch, 'X86') NE -1) then return, 'LINUX'


 status='Unrecognized architecture.'
 return, ''
end
;===========================================================================



