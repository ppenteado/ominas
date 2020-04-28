;==============================================================================
;+
; NAME:
;	wcp
;
;
; type:
;	Copy files from the web.
;
;
; CATEGORY:
;	NV/SYS
;
;
; CALLING SEQUENCE:
;	wcp, url, dir
;
;
; ARGUMENTS:
;  INPUT:
;	url:	 	URL from which to copy.  If a directory is pointed to
;			then multiple files are copied, subject to the 
;			keywords below.
;
;	dir:		Local directory.
;
;  OUTPUT: NONE
;
;
; KEYWORDS:
;  INPUT:  
;	update:		If set, only files that do not already exist in the 
;			local directory are transferred,
;
;	extension:	If set, only files with these extensions are 
;			transferred.
;
;	exclude:	Names of files or directories to exclude from the
;			transfer.
;
;	recursive:	If set, remote directories are descended.
;
;	verbose:	If set, some messages are printed.
;
;	callback:	Name of a procedure to call after each file is
;			transferred.
;
;	data:		Data argument for the callback procedure.
;
;	cancel:		If set (typically from within a callback procedure), 
;			the callback procedure is cleared and the transfer 
;			is aborted.
;
;  OUTPUT: NONE
;
;
; RETURN:  NONE
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



;=============================================================================
; wcp_transfer
;
;=============================================================================
pro wcp_transfer, url, local, files, verbose=verbose, update=update, status=status
common wcp_block, wcp__callback, wcp__data, wcp__cancel

 ;-----------------------------------------------------------------
 ; if /update, remove files that already exist on client
 ;-----------------------------------------------------------------
 if(keyword_set(update)) then $
  begin
   local_files = file_search(local + '/*')
   if(keyword_set(local_files)) then $
    begin
     local_files = file_basename(local_files)
     w = nwhere(files, local_files)
     ww = complement(files, w)
     if(ww[0] EQ -1) then return
     files = files[ww]
    end
  end


 ;-----------------------------------------------------------
 ; transfer files
 ;-----------------------------------------------------------
 for i=0, n_elements(files)-1 do $
  begin
   net_o = IDLnetUrl(ssl_verify_host=0, ssl_verify_peer=0)
   src = url + '/'+ files[i]
   dst = local + '/' + files[i]

   if(keyword_set(verbose)) then print, dst
   stat = net_o->get(url=src, filename=dst)

   if(keyword_set(wcp__callback)) then call_procedure, wcp__callback, wcp__data
   if(wcp__cancel) then $
    begin
     if(keyword_set(verbose)) then print, 'Canceled.'
     status = -1
     return
    end
  end

end
;=============================================================================



;=============================================================================
; wcp_multi
;
;=============================================================================
pro wcp_multi, baseurl, filespec, local, update=update, verbose=verbose, $
                status=status, recursive=recursive, exclude=exclude

 ;----------------------------------------------------------------------
 ; get remote directory listing
 ;----------------------------------------------------------------------
 files = wls(baseurl)
 if(NOT keyword_set(files)) then return

 ;----------------------------------------------------------------------
 ; exclude files
 ;----------------------------------------------------------------------
 if(keyword_set(exclude)) then $
  for i=0, n_elements(exclude)-1 do $
   begin
    w = where(strpos(files, exclude[i]) NE -1)
    if(w[0] NE -1) then files = rm_list_item(files, w)
   end
  if(NOT keyword_set(files)) then return

 ;----------------------------------------------------------------------
 ; create local directory
 ;----------------------------------------------------------------------
 file_mkdir_decrapified, local

 ;----------------------------------------------------------------------
 ; attempt to descend into directories if /recursive
 ;----------------------------------------------------------------------
 if(keyword_set(recursive)) then $
  for i=0, n_elements(files)-1 do $
   begin
    wcp_multi, baseurl + '/' + files[i], filespec, local + '/' + files[i] + '/', $
            update=update, verbose=verbose, exclude=exclude, $
            status=status, recursive=recursive  
    if(status EQ -1) then return
   end  

 ;----------------------------------------------------------------------
 ; match file specification
 ;----------------------------------------------------------------------
 if(keyword_set(filespec)) then $
  begin
   w = where(strmatch(files, filespec))
   if(w[0] EQ -1) then return
   files = files[w]
  end

 ;-----------------------------------------------------------------
 ; copy files
 ;-----------------------------------------------------------------
 wcp_transfer, baseurl, local, files, verbose=verbose, update=update, status=status

end
;=============================================================================




;=============================================================================
; wcp
;
;=============================================================================
pro wcp, url, local, update=update, verbose=verbose, $
      callback=callback, data=data, cancel=cancel, status=status, $
      recursive=recursive, exclude=exclude
common wcp_block, wcp__callback, wcp__data, wcp__cancel


 status = 0

 ;-----------------------------------------------------------------
 ; set callback fn and return
 ;-----------------------------------------------------------------
 if(keyword_set(callback)) then $
  begin
   if(NOT keyword_set(data)) then data = 0
   wcp__callback = callback
   wcp__data = data
   return
  end

 ;-----------------------------------------------------------------
 ; cancel callback fn and return
 ;-----------------------------------------------------------------
 if(keyword_set(cancel)) then $
  begin
   wcp__callback = ''
   wcp__data = 0
   wcp__cancel = 1
   return
  end
 wcp__cancel = 0


 ;-----------------------------------------------------------------
 ; parse url components
 ;-----------------------------------------------------------------
 urlcomp = parse_url(url)
 split_filename, url, baseurl, filespec
 baseurl = baseurl[0]


 ;----------------------------------------------------------------------
 ; otherwise full filespecession parsing with optional recursion
 ;----------------------------------------------------------------------
 wcp_multi, baseurl, filespec, local, update=update, $
      verbose=verbose, status=status, recursive=recursive, exclude=exclude

end
;=============================================================================
