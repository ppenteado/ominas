;=============================================================================
;+
; NAME:
;       read_w10n_pds
;
;
; PURPOSE:
;       Reads a w10n file from the PDS website
;
;
; CATEGORY:
;       config/w10n_pds 
;
;
; CALLING SEQUENCE:
;       data = read_w10n_pds(url, label)
;
;
; ARGUMENTS:
;  INPUT:
;         url:          String giving the URL of the file to be read.
;
;  OUTPUT:
;       label:          Named variable in which the metadata (JSON format or PDS) label will be
;                       returned.
;
; KEYWORDS:
;  INPUT:
;         pds:          Return label as PDS label
;
;       debug:          Print out http responses and debug info
;
;      nodata:          Do not return data
;
;      silent:          Do not print messages
;
;         gif:          Write a local gif file of the data
;
;         dim:          Returned dimension of array
;
; RETURN:
;       The data array read from the file.
;
;
; MODIFICATION HISTORY:
;       Written by:     Haemmerle, 2/2018
;
;-----------------------------------------------------------------
FUNCTION Url_Callback, status, progress, data

   ; print the info msgs from the url object
   PRINT, status

   ; return 1 to continue, return 0 to cancel
   RETURN, 1
END

;-----------------------------------------------------------------
FUNCTION read_w10n_pds, url, label, dim=dim, nodata=_nodata, silent=silent, $
                        pds=pds, gif=gif, debug=debug

   nodata = keyword_set(_nodata)
   status = 0

   ; If the url object throws an error it will be caught here
   CATCH, errorStatus 
   IF (errorStatus NE 0) THEN BEGIN
      CATCH, /CANCEL

      ; Display the error msg 
      if (NOT keyword_set(silent)) then message, !ERROR_STATE.msg

      ; Get the properties that will tell us more about the error.
      oUrl->GetProperty, RESPONSE_CODE=rspCode, $
         RESPONSE_HEADER=rspHdr, RESPONSE_FILENAME=rspFn
      if (NOT keyword_set(silent)) then PRINT, 'rspCode = ', rspCode
      if (NOT keyword_set(silent)) then PRINT, 'rspHdr= ', rspHdr
      if (NOT keyword_set(silent)) then PRINT, 'rspFn= ', rspFn

      ; Destroy the url object
      OBJ_DESTROY, oUrl
      RETURN, 0
   ENDIF

   ; Parse URL
   prot_pos = strpos(url, '://')
   if (prot_pos EQ -1) then begin
      if (NOT keyword_set(silent)) then message, 'URL does not have a protocol'
      return, 0
   endif
   IMAGE_PROTOCOL = strmid(url, 0, prot_pos)
   host_pos = strpos(url, '/', prot_pos+3)
   if (host_pos EQ -1) then begin
      if (NOT keyword_set(silent)) then message, 'URL does not have a path'
      return, 0
   endif
   IMAGE_HOST = strmid(url, prot_pos+3, host_pos-prot_pos-3)
   path_pos = strpos(url, '/', /reverse_search)
   if (path_pos-host_pos EQ 0) then begin
      if (NOT keyword_set(silent)) then message, 'URL does not have a path'
      return, 0
   endif
   IMAGE_PATH = strmid(url, host_pos+1, path_pos-host_pos)
   if (strlen(url) EQ path_pos+1) then begin
      if (NOT keyword_set(silent)) then message, 'URL does not have an image name' 
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
      if (NOT keyword_set(silent)) then message, 'Only supports http or https protocol'
      return, 0
   endif
   if (strcmp(IMAGE_HOST, 'pds-imaging.jpl.nasa.gov', /fold_case) NE 1) then begin
      if (NOT keyword_set(silent)) then message, 'Only supports PDS site'
      return, 0
   endif

   ; create a new IDLnetURL object 
   oUrl = OBJ_NEW('IDLnetUrl')

   ; Specify the callback function
   if (keyword_set(debug)) then oUrl->SetProperty, CALLBACK_FUNCTION ='Url_Callback'

   ; Set verbose to 1 to see more info on the transacton
   if(keyword_set(debug)) then oUrl->SetProperty, VERBOSE = 1

   ; Set the transfer protocol as http or https
   oUrl->SetProperty, url_scheme = IMAGE_PROTOCOL

   ; The PDS server
   oUrl->SetProperty, URL_HOST = IMAGE_HOST

   ; The top metadata server path of the file to download
   oUrl->SetProperty, URL_PATH = IMAGE_PATH + IMAGE_NAME + '/'

   ; Make a request to the PDS image server.
   ; Retrieve general metadata, list of images
   top_metadata_json = oUrl->Get( /STRING_ARRAY )

   ; Print the returned array of strings
   if (keyword_set(debug)) then begin
      PRINT, 'TOP_METADATA array of strings returned:'
      for i=0, n_elements(top_metadata_json)-1 do print, top_metadata_json[i]
   endif
   top_metadata = json_parse(top_metadata_json)
   if (keyword_set(debug)) then begin
      print, 'TOP_METADATA:'
      print, top_metadata
   endif
   nodes = top_metadata['nodes']
   if (n_elements(nodes) NE 1) then begin
      if (NOT keyword_set(silent)) then message, 'Node contains more than one image'
      return, 0
   endif
   nodes = nodes[0]
   node_name = nodes['name']
   if (NOT keyword_set(silent)) then print, 'IMAGE node found, named "' + node_name + '"'

   ; The top metadata server path of image id from node_name
   oUrl->SetProperty, URL_PATH = IMAGE_PATH + IMAGE_NAME + '/' + node_name + '/'

   ; Retrieve image metadata, list of images
   image_metadata_json = oUrl->Get( /STRING_ARRAY )

   ; Print the returned array of strings
   if (keyword_set(debug)) then begin
      PRINT, 'IMAGE_METADATA array of strings returned:'
      for i=0, n_elements(image_metadata_json)-1 do print, image_metadata_json[i]
   endif
   image_metadata = json_parse(image_metadata_json)
   if (keyword_set(debug)) then begin
       print, 'IMAGE_METADATA:'
       print, image_metadata
   endif

   ; Get image size
   attributes = image_metadata['attributes']
   image_size = (attributes[0])['value']
   isize = image_size.ToArray(type=3)
   if (keyword_set(debug)) then print, 'Image size = ', isize
   metadata = (attributes[1])['value']
   label = json_serialize(metadata)

   if (keyword_set(gif)) then begin

      ; Make a request to the PDS image server.
      ; Retrieve a binary gif image file and write it 
      ; to the local disk's IDL main directory.
      oUrl->SetProperty, URL_PATH = IMAGE_PATH + IMAGE_NAME + '/0/image[]?output=gif'

      fn = oUrl->Get(FILENAME = IMAGE_NAME + '.gif')  

      ; Print the path to the file retrieved from the remote server
      if (NOT keyword_set(silent)) then print, 'gif filename written = ', fn

   endif

   ; Make a request for binary data
   if (NOT keyword_set(nodata)) then begin
      big_endian = 1b - (byte(1,0,1))[0]
      if (big_endian EQ 1) then oUrl->SetProperty, URL_PATH = IMAGE_PATH + IMAGE_NAME + '/0/raster/data[]?output=big-endian' $
      else oUrl->SetProperty, URL_PATH = IMAGE_PATH + IMAGE_NAME + '/0/raster/data[]?output=little-endian'

      data = oURL->Get( /BUFFER )

      ; Reformat data
      pixels = n_elements(data)
      ; If Byte data
      if (pixels EQ isize[0]*isize[1]*isize[2]) then begin
         if (isize[2] EQ 1 ) then begin
            dim = isize[0:1]
            data = reform(data, isize[0], isize[1], /overwrite)
         endif else begin
            dim = isize
            data = reform(data, isize[0], isize[1], isize[2], /overwrite)
         endelse
      endif $
      ; If Half (short) data
      else if (pixels EQ 2*isize[0]*isize[1]*isize[2]) then begin
         short_data = make_array(isize[0]*isize[1]*isize[2], /uint)
         if (big_endian EQ 1) then begin
            for i=0, isize[0]*isize[1]-1 do short_data[i] = 256*data[2*i] + data[2*i+1]
         endif else begin
            for i=0, isize[0]*isize[1]-1 do short_data[i] = data[2*i] + 256*data[2*i+1]
         endelse
         if (isize[2] EQ 1 ) then begin
            dim = isize[0:1]
            data = reform(short_data, isize[0], isize[1], /overwrite)
         endif else begin
            dim = isize
            data = reform(short_data, isize[0], isize[1], isize[2], /overwrite)
         endelse
      endif else begin $
         n_pix = pixels/isize[0]/isize[1]/isize[2]
         message, 'Pixel size of ' + strtrim(string(n_pix),2) + ' not supported'
      endelse

   endif else begin
     data = 0
     if(NOT keyword_set(silent)) then print, 'Not reading image data.'
   endelse

   if (keyword_set(pds)) then begin
 
      ; Read the PDS label (if exists)
      label = ''
      ext_pos = strpos(IMAGE_NAME, '.', /reverse_search)
      extension = strmid(IMAGE_NAME, ext_pos+1)
      pds_ext = ''
      if (strcmp(extension, 'IMG') EQ 1) then pds_ext = 'LBL'
      if (strcmp(extension, 'img') EQ 1) then pds_ext = 'lbl'
      if (strcmp(extension, 'qub') EQ 1) then pds_ext = 'lbl'
      if (strcmp(extension, 'DAT') EQ 1) then pds_ext = 'LBL'

      if (strlen(pds_ext) NE 0) then begin
         LBL_NAME = strmid(IMAGE_NAME, 0, ext_pos+1) + pds_ext

         ; PDS label URL
         oUrl->SetProperty, URL_PATH = IMAGE_PATH + LBL_NAME

         ; Retrieve label file
         label = oUrl->Get( /STRING_ARRAY )

      endif else print, 'PDS label not found'
   endif

   ; Destroy the url object
   OBJ_DESTROY, oUrl

   return, data

END
