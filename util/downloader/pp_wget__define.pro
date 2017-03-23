; docformat = 'rst'
    ;+
    ; :Author: Paulo Penteado (`http://www.ppenteado.net <http://www.ppenteado.net>`)
    ;-
    ;+
    ; :Description:
    ; 
    ;    This class is used to provide functionality similar to the UNIX wget
    ;    or IDL's wget (introduced in IDL 8.5). The main differences relative
    ;    to IDL's wget is that timestamps of the downloaded files are set to match
    ;    the timestamps informed by the server, and the optional arguments, to control
    ;    things such as overwriting of existing files, recursivenes and regular expression
    ;    matching. 
    ;    
    ;
    ; :Params:
    ;    baseurl: in, required
    ;    The root URL to be downloaded. If this is a directory (ends with /), all
    ;    files found inside it will be downloaded. If it does not end with /, just
    ;    that one file will be downloaded.
    ;
    ; :Keywords:
    ;    clobber: in, optional, default=0
    ;    If set to 0 (default), exisiting files with the same timestamp as that
    ;    returned by the server will be skipped. If set to 1, files will be downloaded, 
    ;    even if overwriting existing local files. If set to 2, existing files will
    ;    be skipped, without checking the timestamp. Setting this argument to 1
    ;    is useful to resume an interrupted download of a directory.
    ;    pattern: in, optional
    ;    A string with a regular expression that file names in the server will be
    ;    matched to. If provided, only those files matching this expression will be
    ;    downloaded.
    ;    recursive: in, optional, default=0
    ;    If set and baseurl is a directory, all directories contained inside it
    ;    will be recursively downloaded.
    ;    localdir: in, optional, default='./'
    ;    Local directory where the downloaded files are to be stored. Defaults to the
    ;    current directory.
    ;    debug: in, optional, default=0
    ;    timestamps: in, optional
    ;    If provided, a hash (empty or not) where the timestamps of the downloaded
    ;    files will be stored. Such a hash is always created internally and can be
    ;    retrieved as a property (called timestamps). The reason to provide a hash
    ;    is to have the timestamps be appended to this hash, instead of having a new
    ;    hash created. 
    ;    bdir: in, optional
    ;    For internal use by recursive calls only.
    ;    xpattern: in, optional
    ;    A string with a regular expression that file names in the server will be
    ;    matched to. If provided, only those files NOT matching this expression will be
    ;    downloaded.
    ;    absolute_paths: in, optional, default=0
    ;    If set, the timestamps hash will contain absolute paths instead of relative paths. 
    ;
    ; :Author: Paulo Penteado (`http://www.ppenteado.net <http://www.ppenteado.net>`)
    ;-
function pp_wget::init,baseurl,clobber=clobber,pattern=pattern,$
recursive=recursive,localdir=localdir,debug=debug,timestamps=timestamps,$
bdir=bdir,xpattern=xpattern,absolute_paths=absolute,_ref_extra=e,$
ssl_certificate_file=sslf
compile_opt idl2,logical_predicate,hidden

self.clobber=keyword_set(clobber)
self.localdir=n_elements(localdir) ? localdir : '.'
self.baseurl=baseurl
self.recursive=keyword_set(recursive)
self.timestamps=isa(timestamps,'hash') ? timestamps : hash()
ldir=file_expand_path(self.localdir)
self.debug=keyword_set(debug)
self.bdir=n_elements(bdir) ? bdir : ''
self.ldir=ldir+path_sep()
self.pattern=n_elements(pattern) ? pattern : ''
self.xpattern=n_elements(xpattern) ? xpattern : ''
self.absolute=keyword_set(absolute)
self.sslf=n_elements(sslf) ? file_search(sslf) : (file_search(filepath('',subdir='bin')+'*/ca-bundle.crt'))[0]
print,self.sslf
;if n_elements(e) then self.extra=ptr_new(e)

return,1
end

;+
; :Description:
;    Internal function, inteded to be used by pp_wget::geturl.
;
; :Author: Paulo Penteado (`http://www.ppenteado.net <http://www.ppenteado.net>`)
;-
function pp_wget_callback,StatusInfo,ProgressInfo,CallbackData
compile_opt idl2,logical_predicate
if callbackdata.debug then print,statusinfo
w=where(stregex(statusinfo,'Verbose:[[:blank:]]+Header In:[[:blank:]]+Content-Length:',/bool),count)
if count then begin
  tmp=stregex(statusinfo[w[0]],'Content-Length:[[:blank:]]*([[:digit:]]+)',/subexpr,/extract)
  callbackdata.content_length=fix(tmp[1])
  print,'Content Length: ',pp_readablesize(tmp[1],/string)
endif
w=where(stregex(statusinfo,'Verbose:[[:blank:]]+Header In:[[:blank:]]+Last-Modified:',/bool),count)
if count then begin
  callbackdata.last_modified=statusinfo[w[0]]
  if (~callbackdata.clobber) && callbackdata.local_file_exists then begin
    tml=callbackdata.local_file_tm
    tmr=(stregex(statusinfo[w[0]],'Last-Modified:[[:blank:]]+(.*)',/subexpr,/extract))[1]
    tmrj=pp_parse_date(tmr)
    tmlj=julday(1,1,1970)-0.5d0+tml/86400d0
    if (abs(tmrj-tmlj) lt 1d0/86400d0) then begin
      print,'This file is already present locally with same timestamp. Skipping'
      return,0
    endif
  endif
endif
return,1
end

pro pp_wget::setproperty,last_modified=last_modified,content_length=content_length
compile_opt idl2,logical_predicate
if n_elements(last_modified) then self.last_modified=last_modified
if n_elements(content_length) then self.content_length=content_length
;if n_elements(ex) then self.idlneturl::setproperty,_strict_extra=ex
end

pro pp_wget::getproperty,local_file_tm=local_file_tm,clobber=clobber,$
  debug=debug,content_length=content_length,local_file_exists=local_file_exists,$
  timestamps=timestamps
compile_opt idl2,logical_predicate
if arg_present(local_file_tm) then local_file_tm=self.local_file_tm
if arg_present(clobber) then clobber=self.clobber
if arg_present(debug) then debug=self.debug
if arg_present(local_file_exists) then local_file_exists=self.local_file_exists
if arg_present(timestamps) then timestamps=self.timestamps
;if n_elements(ex) then self.idlneturl::setproperty,_strict_extra=ex
end

;+
; :Description:
;    Starts the download of the URL set when the object was instantiated.
;    
; :Examples:
; 
;    Download all files at ,skipping exisiting files, recursively::
;    
;      
;
; :Author: Paulo Penteado (`http://www.ppenteado.net <http://www.ppenteado.net>`)
;-
pro pp_wget::geturl
compile_opt idl2,logical_predicate

if ~file_test(self.ldir,/directory) then begin
  print,'Creating directory ',self.ldir
  file_mkdir,self.ldir
endif


pu=parse_url(self.baseurl)
if ptr_valid(self.extra) then begin
  self.iu=idlneturl(url_host=pu.host,url_scheme=pu.scheme,url_port=pu.port,url_path=pu.path,$
    url_query=pu.query,/verbose,callback_function='pp_wget_callback',callback_data=self,$
    ftp_connection_mode=0,_strict_extra=*self.extra,ssl_certificate_file=self.sslf)
endif else begin
  self.iu=idlneturl(url_host=pu.host,url_scheme=pu.scheme,url_port=pu.port,url_path=pu.path,$
    url_query=pu.query,/verbose,callback_function='pp_wget_callback',callback_data=self,$
    ftp_connection_mode=0,ssl_certificate_file=self.sslf)    
endelse

if strmatch(self.baseurl,'*/') then begin ;if url is a directory
  if strlowcase(pu.scheme) eq 'ftp' then begin
    ;ind=!version.release gt '8.3' ? self.iu.getftpdirlist() : pp_jget(self.baseurl)
    ind=self.iu.getftpdirlist()
    inds=(strsplit(ind,/extract)).toarray()
    links=inds[*,-1]
    lm=inds[*,-4]+' '+inds[*,-3]+' '+inds[*,-2]
    foreach link,links,il do self.retrieve,link,lm=lm[il]
  endif else begin
    ind=self.iu.get(/string_array)
    indj=strjoin(ind,' ')
    tmp=strtrim(((stregex(indj,'<title>(.+)</title>',/extract,/subexpr))[1]),2)
    if stregex(tmp,'^index of ',/fold_case,/bool) then begin
      w=where(stregex(ind,'<a[[:blank:]]+href[[:blank:]]*="[^"]+"[^>]*>',/bool))
      indl=ind[w];lines with links
      links=reform((stregex(indl,'<a[[:blank:]]+href[[:blank:]]*="([^"]+)"[^>]*>',/extract,/subexpr))[1,*])
      links=links[where(~stregex(links,'^(\/|\?)',/bool),/null)]
      foreach link,links do self.retrieve,link
    endif
  endelse
endif else begin
  ;link=file_basename(pu.path)
  ;self.iu.setproperty,url_path=(stregex(pu.path,'(.*)'+link+'$',/extract,/subexpr))[1]
  self.retrieve,''
endelse

end

;+
; :Description:
;    Internal function, inteded to be used by pp_wget::geturl.
;
; :Author: Paulo Penteado (`http://www.ppenteado.net <http://www.ppenteado.net>`)
;-
pro pp_wget::retrieve,link,lm=lm
compile_opt idl2,logical_predicate,hidden
if ~strmatch(link,'*/') then begin ;if entry is not a directory
  self.iu.getproperty,url_scheme=us,url_port=po,url_path=up
  pu=parse_url(self.baseurl)
  if (us eq 'https') && ~(stregex(self.baseurl,'https://[^/]+:[[:digit:]]+',/bool)) then po='443'
  ;if (pu.scheme eq 'https') && ~(stregex(self.baseurl,'https://[^/]+:[[:digit:]]+',/bool)) then pu.port='443'
  ;self.iu.setproperty,url_path=up+link,url_port=po
  self.iu.setproperty,url_path=pu.path+link,url_port=po
  if self.pattern && ~stregex(link,self.pattern,/bool) then begin
    print,'skipping '+link+' because it does not match the specified pattern: '+self.pattern
    return
  endif
  if self.xpattern && stregex(link,self.xpattern,/bool) then begin
    print,'skipping '+link+' because it matches the specified xpattern: '+self.xpattern
    return
  endif
  ds=((self.bdir ? (self.bdir+'/') : '')+link)
  if ~ds then ds=self.baseurl
  print,'downloading '+ds
  self.last_modified=n_elements(lm) ? lm : ''
  self.content_length=0LL
  fi=file_info(self.ldir+link)
  if (fi.exists && self.clobber eq 2) then begin
    print,'skipping '+link+' because it already exists.'
    return
  endif
  if ~self.clobber then begin
    if fi.exists then begin
      self.local_file_exists=1
      self.local_file_tm=fi.mtime
    endif else begin
      self.local_file_exists=0
      self.local_file_tm=0
    endelse
  endif
  setts=1
  
    catch,err
    if err then begin
      catch,/cancel
      if (err ne -1005) && (err ne -1006) && (~strmatch(!error_state.msg,'*Cancel request detected*',/fold_case)) then begin
        print,'error downloading file ',link,': ',err,' ',!error_state.msg
        return
      endif else setts=0
    endif else begin
      ng=0B
      if self.last_modified then begin
        if (~self.clobber) && self.local_file_exists then begin
          tml=self.local_file_tm
          tmrj=pp_parse_date(self.last_modified)
          tmlj=julday(1,1,1970)-0.5d0+tml/86400d0
          if (abs(tmrj-tmlj) lt 1d0/86400d0) then begin
            print,'This file is already present locally with same timestamp. Skipping'
            ng=1B
          endif
        endif
      endif
      if ~ng then begin
        fn=link ? link : file_basename(pu.path)
        g=self.iu.get(filename=self.ldir+fn)
      endif
    endelse
  
  ;Set the timestamp
  if self.last_modified then begin
    if n_elements(lm) then tm=self.last_modified else begin
      tm=stregex(self.last_modified,'Last-Modified:[[:blank:]]+(.*)',/subexpr,/extract)
      tm=tm[1]
    endelse
    if tm then begin
      tmrj=pp_parse_date(tm)
      if setts then begin
        if ~strmatch(!version.os_family,'*win*',/fold) then begin ;linux-like systems
          caldat,tmrj,mon,day,yr,h,m,s
          tmstr=string(yr,mon,day,h,m,s,format='(I04,I02,I02,I02,I02,".",I02)')
          smon=(['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'])[mon-1]
          tmstr=string(day,smon,yr,h,m,s,format='(I02," ",A3," ",I04," ",I02,":",I02,":",I02," GMT")')
          ;print, 'touch -d "'+tmstr+'" '+self.ldir+link
          ;spawn,'touch -d "'+tmstr+'" '+self.ldir+link
          tmstr=string(yr,mon,day,h,m,s,format='(I04,I02,I02,I02,I02,".",I02)')
          ;print, 'touch -t "'+tmstr+'" '+self.ldir+link
          spawn, 'touch -t "'+tmstr+'" '+self.ldir+link
        endif else begin ;Windows systems
          spawn,'powershell -WindowStyle Hidden "$(Get-Item '+self.ldir+link+').lastwritetime=$(Get-Date '+"'"+tm+"'"+')"',/noshell
        endelse
      endif
      tsf=self.absolute ? file_expand_path(self.ldir+link) : self.bdir+link
      (self.timestamps)[tsf]=tmrj
    endif
  endif
endif else begin
  if self.recursive then begin ; if entry is a directory
    print,'Entering directory ',link
    iw=pp_wget(self.baseurl+'/'+link,$
      timestamps=self.timestamps,clobber=self.clobber,pattern=self.pattern,$
      recursive=self.recursive,localdir=self.localdir+path_sep()+link+path_sep(),$
      bdir=self.bdir ? self.bdir+'/'+link : link,xpattern=self.xpattern,absolute=self.absolute)
    iw.geturl
    print,'Done with directory ',link
  endif else print,'Recursive mode not set, skipping directory ',link
endelse
end

;+
; :Description:
;    Type definition for pp_wget. See the documentation on `pp_wget::init`.
;
; :Author: Paulo Penteado (`http://www.ppenteado.net <http://www.ppenteado.net>`)
;-
pro pp_wget__define
compile_opt idl2,logical_predicate
!null={pp_wget, inherits idl_object, clobber:0,recursive:0,$
  ldir:'',pattern:'',localdir:'',last_modified:'',local_file_exists:0,local_file_tm:0LL,$
  baseurl:'',iu:obj_new(),timestamps:obj_new(),debug:0,content_length:0LL,bdir:'',$
  xpattern:'',absolute:0,extra:ptr_new(),sslf:''}
end
