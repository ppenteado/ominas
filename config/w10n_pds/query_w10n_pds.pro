;=============================================================================
;+
; NAME:
;       query_w10n_pds
;
;
; PURPOSE:
;       Returns a list of w10n URLs (filenames) from the PDS website
;       given a URL with an embedded regular expression
;
;
; CATEGORY:
;       config/w10n_pds 
;
;
; CALLING SEQUENCE:
;       urls = query_w10n_pds(wildcarded_url)
;
;
; ARGUMENTS:
;  INPUT:
;    wildcarded_url:    String giving the wildcarded URL
;
;  OUTPUT:              None.
;
; KEYWORDS:
;  INPUT:
;       debug:          Print out http responses and debug info
;
; RETURN:
;       An array if URLs (filenames) from the web site.
;
;
; MODIFICATION HISTORY:
;       Written by:     Haemmerle, 4/2018
;
;-----------------------------------------------------------------
FUNCTION Query_Url_Callback, status, progress, data

   ; print the info msgs from the url object
   PRINT, status

   ; return 1 to continue, return 0 to cancel
   RETURN, 1
END

;-----------------------------------------------------------------
FUNCTION query_w10n_pds, url, debug=debug

   status = 0

   ; If the url object throws an error it will be caught here
   CATCH, errorStatus 
   IF (errorStatus NE 0) THEN BEGIN
      CATCH, /CANCEL

      ; Display the error msg 
      message, /info, !ERROR_STATE.msg

      ; Get the properties that will tell us more about the error.
      oUrl->GetProperty, RESPONSE_CODE=rspCode, $
         RESPONSE_HEADER=rspHdr, RESPONSE_FILENAME=rspFn
      if (keyword_set(debug)) then PRINT, 'rspCode = ', rspCode
      if (keyword_set(debug)) then PRINT, 'rspHdr= ', rspHdr
      if (keyword_set(debug)) then PRINT, 'rspFn= ', rspFn

      ; Destroy the url object
      OBJ_DESTROY, oUrl
      RETURN, 0
   ENDIF

   ; Parse URL
   prot_pos = strpos(url, '://')
   if (prot_pos EQ -1) then begin
      message, /info, 'URL does not have a protocol'
      return, 0
   endif
   IMAGE_PROTOCOL = strmid(url, 0, prot_pos)
   host_pos = strpos(url, '/', prot_pos+3)
   if (host_pos EQ -1) then begin
      message, /info, 'URL does not have a path'
      return, 0
   endif
   IMAGE_HOST = strmid(url, prot_pos+3, host_pos-prot_pos-3)
   path_pos = strpos(url, '/', /reverse_search)
   if (path_pos-host_pos EQ 0) then begin
      message, /info, 'URL does not have a path'
      return, 0
   endif
   IMAGE_PATH = strmid(url, host_pos+1, path_pos-host_pos)
   if (strlen(url) EQ path_pos+1) then begin
      message, /info, 'URL does not have an image name' 
      return, 0
   endif
   IMAGE_NAME = strmid(url, path_pos+1)

   if (keyword_set(debug)) then begin
      help, image_protocol
      help, image_host
      help, image_path
      help, image_name
   endif

   ; Validate URL
   if ((strcmp(IMAGE_PROTOCOL, 'http', /fold_case) NE 1) AND (strcmp(IMAGE_PROTOCOL, 'https', /fold_case) NE 1)) then begin
      message, /info, 'Only supports http or https protocol'
      return, 0
   endif
   if (strcmp(IMAGE_HOST, 'pds-imaging.jpl.nasa.gov', /fold_case) NE 1) then begin
      message, /info, 'Only supports PDS site'
      return, 0
   endif

   ; create a new IDLnetURL object 
   if (!version.release ge '8.4') then oUrl = OBJ_NEW('IDLnetUrl') else $
     oUrl = OBJ_NEW('IDLnetUrl',ssl_certificate_file=getenv('OMINAS_DIR')+path_sep()+'util'+path_sep()+'downloader'+path_sep()+'ca-bundle.crt')

   ; Specify the callback function
   if (keyword_set(debug)) then oUrl->SetProperty, CALLBACK_FUNCTION ='Query_Url_Callback'

   ; Set verbose to 1 to see more info on the transacton
   if(keyword_set(debug)) then oUrl->SetProperty, VERBOSE = 1

   ; Set the transfer protocol as http or https
   oUrl->SetProperty, url_scheme = IMAGE_PROTOCOL

   ; The PDS server
   oUrl->SetProperty, URL_HOST = IMAGE_HOST

   ; The top metadata server path of the file to download
   oUrl->SetProperty, URL_PATH = IMAGE_PATH + IMAGE_NAME + '/?output=json'

   ; Make a request to the PDS image server.
   ; Retrieve general metadata, list of images
   top_metadata_json = oUrl->Get( /STRING_ARRAY )

   ; Destroy the url object
   OBJ_DESTROY, oUrl

   ; Print the returned array of strings
   if (keyword_set(debug)) then begin
      PRINT, 'TOP_METADATA array of strings returned:'
      for i=0, n_elements(top_metadata_json)-1 do print, top_metadata_json[i]
   endif
   if(n_elements(top_metadata_json) EQ 0) then return, 0

   top_metadata = json_parse(top_metadata_json)
   if (keyword_set(debug)) then begin
      print, 'TOP_METADATA:'
      print, top_metadata
   endif

   w10n = top_metadata['w10n']
   path = ''
   type = ''
   for i=0,n_elements(w10n)-1 do if (w10n[i,'name'] EQ 'path') then path = w10n[i, 'value']
   for i=0,n_elements(w10n)-1 do if (w10n[i,'name'] EQ 'type') then type = w10n[i, 'value']
   if (keyword_set(debug)) then print, 'w10n path = ', path
   if (keyword_set(debug)) then print, 'w10n type = ', type

   leaves = top_metadata['leaves']
   if (n_elements(leaves) EQ 0) then begin
       ; Test for URL as single image or wildcard without matches
       if (type EQ 'fs.glob') then begin
          message, /info, 'Regular expression request returns no matches'
          return, 0
       endif
       return, IMAGE_PROTOCOL + '://' + IMAGE_HOST + path
   endif
   URLs = strarr(n_elements(leaves))
   for i=0,n_elements(leaves)-1 do URLs[i] = IMAGE_PROTOCOL + '://' + IMAGE_HOST + path + '/' + leaves[i, 'name']

   return, URLs

END
