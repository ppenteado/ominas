;==============================================================================
;+
; NAME:
;	wls
;
;
; type:
;	Get a directory listing from the web.
;
;
; CATEGORY:
;	NV/SYS
;
;
; CALLING SEQUENCE:
;	files = wls(url)
;
;
; ARGUMENTS:
;  INPUT:
;	url:	 	URL from which to obtain the listing.
;
;  OUTPUT: NONE
;
;
; KEYWORDS:
;  INPUT:  NONE
;
;  OUTPUT: NONE
;
;
; RETURN:  List of files contained under the romte URL.
;
;
; STATUS:
;	Complete
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale		2/2020
;	
;-
;==============================================================================
function wls, url

 catch, error
 if(error NE 0) then $
  begin
   return, ''
   catch, /cancel
  end

 urlcomp = parse_url(url + '/')
 url_o = obj_new('IDLnetUrl')
 url_o->SetProperty, url_scheme = 'ftp'
 url_o->SetProperty, url_host = urlcomp.host
 url_o->SetProperty, url_path = urlcomp.path
 return, url_o->GetFtpDirList(/short)
end
;=============================================================================
