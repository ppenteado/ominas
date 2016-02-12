;=============================================================================
;+
; drm_multifpick
;
; PURPOSE :
;`
;   Widget tool for selecting list of files and directories.
;  Files are shown on the right, directories on the left.
;  Click on a directory to move into it, click on a file to
;  to select it. Alternatively, edit the path or filter
;  strings to refine the search, or enter a filename into the
;  select string and press Return to select that file. The 
;  filter string is reset and refreshed whenever the directory
;  is changed. All the files, the present directory, and all 
;  the visible directories are selected when the 'All Files', 
;  'Directory' and 'All Dirs' buttons are pressed respectively.
;  Pressing 'Clear All' clears the selection box. Clicking on an
;  individual entry in the selection box removes it. If the
;  'Duplicate' button is depressed, multiple copies of the same
;  entry are allowed to be put into the selection box. Hidden
;  files are displayed in the filelist when the 'Hidden' button
;  is depressed. Pressing the 'OK' button will accept the choice
;  of files and directories already in the selection box,
;  pressing 'Cancel' will quit the process.
;
;'
; CALLING SEQUENCE :
;
;  file_list=drm_multifpick()
;
;
; ARGUMENTS
;  Same as pickfile
;
;
; KEYWORDS 
;  Same as pickfile
;
;
; RETURN : array of selected files 
;
;
; KNOWN BUGS : None. But a function getfiles usually compiled somewhere by
;		DRM and used in this program, is not the same getfiles
;		which is commented out in this file. Someday it will be good
;		to find this renegade getfiles function, and copy it into
;		this file.
;
;
; ORIGINAL AUTHOR : S.W. Ying; 7/94
;
;
; UPDATE HISTORY : 
;
;   got rid of redundant spawns, used faster spawn technique,
;     fixed some bugs, added some new ones                 - J.S. ; 8/94
;
;   rearranged the widget buttons, fixed the duplicate feature,
;     fixed the filter, modified the path text, standardised the
;     strings returned to grablist, changed update_list, took out
;     old code.					- F. L. Wong ; 8/95
;
;=============================================================================

;=========================================================================
; get_directory
;
;  Returns the current directory listing in a string array.
; If the filter is '' then it uses the /noshell keyword to spawn to
; increase the speed to a more acceptable level.
;
;  If filter is not '', then a shell must be loaded to deal with it,
; so it will be VERRRRRY slow.
;
; J.S. 8/94
;=========================================================================
function get_directory, filt, hidden=hidden

 retval = ['../']

 if(filt(0) EQ '') then $
  if(keyword__set(hidden)) then spawn, ['ls', '-aF'], list, /noshell $
  else spawn, ['ls', '-F'], list, /noshell $

 else $
  if(keyword__set(hidden)) then spawn, 'ls -aF', list $
  else spawn, 'ls -F', list

 if (n_elements(list) ne 0) then begin
   list = list(where((list ne './') and (list ne '../')))
   retval = [retval, list]
 end

 return, retval
end
;=========================================================================



;=========================================================================
; get_files
;
;  Given the directory listing, return a list of all entries which
; don't contain '/'
;
; J.S. 8/94
;=========================================================================
function get_files, directory

 i=where(strpos(directory, '/') EQ -1)
 if(i(0) NE -1) then return, directory(i)

 return, ''
end
;=========================================================================



;=========================================================================
; get_dirs
;
;  Given the directory listing, return a list of all entries which
; contain '/'
;
; J.S. 8/94
;=========================================================================
function get_dirs, directory

 i=where(strpos(directory, '/') NE -1)
 if(i(0) NE -1) then return, directory(i)

 return, ''
end
;=========================================================================




;*************************************************************************
; This function returns a 0 if 'file' is valid; otherwise, it returns
; a non-zero value
;
;*************************************************************************

Function drm_valid_file, file, dir=dir

widget_control, /hour

spawn, ['/bin/sh -c "test -r '+file+' -a -r '+file+' ";echo $?'], $ 
    result, /sh 

widget_control, hour=0
return, result(0)

END



;*************************************************************************
; This function returns a 0 if 'dir' is valid; otherwise, it returns
; a non-zero value
;
;*************************************************************************
Function drm_valid_dir, dir

widget_control, /hour

; UNIX command "test" is going to check that the 'dir' exists and that
; it is executable. "echo $? merely ensures that the valu returned by
; test is passed into IDL through result

spawn, ['/bin/csh -c "test -d '+dir+' -a -x '+dir+' ";echo $?'], $ 
    result, /sh 

widget_control, hour=0
return , result(0)

END


;*************************************************************************
; This function returns the files at the current directory level, or the
; 'dir' level if keyword is specified. The hidden keyword is for files
; which start with a period. The filter argument specifies what files the
; Unix command 'ls' returns. By default, "filter" = "*" 

;*************************************************************************

;Function getfiles, filter, dir=dir, hidden=hidden	

;widget_control, /hour

;if (keyword__set(dir)) then begin
;   if (drm_valid_dir(dir) eq 0) then $	
;	dir_search = dir +'/'
;endif $
;else dir_search = "" 
	;else CD, current=dir_search

;if (keyword__set(hidden)) then $
;spawn,['ls', '-laL', dir_search+filter] , results, /noshell $
;else spawn,['ls', '-lL', dir_search+filter] , results, /noshell

;if (n_elements(results) ne 0) then begin
;    firsts = strupcase(strmid(results, 0, 1)) 
;    fileinds = (where(((firsts eq "F") OR (firsts eq "-") OR $ 
;                       (firsts eq "l")), found)) 
;    if (found GT 0) then begin 
;      results = results(fileinds) 
;      FOR i = 0, n_elements(results) - 1 DO BEGIN 
;        spaceinds = where(byte(results(i)) eq 32) 
;        spaceindex = spaceinds(n_elements(spaceinds) - 1) 
;        results(i) = strmid(results(i), spaceindex + 1, 100) 
;      endfor
;      return, results 
;    endif 
;   endif

;widget_control, hour=0
;return, "" 

;END


;*************************************************************************
; This function returns an array of strings to be updated into a list.
; If duplicate keyword is not set, any multiple copies of a string entry
;  is discarded and an unique string array is returned.
;
; Someday someone may want to think up an algorithm to do it faster,
;  using matrix operations instead of for loops
;
;	- F L Wong 8/95
;*************************************************************************

Function update_list, new, old, duplicate

n_new=n_elements(new)
for i=0,n_new-1 do begin
trash1=strpos(new(i),'@')
trash2=strpos(new(i),'*')
if ((trash1 ne -1) OR (trash2 ne -1)) then begin
	new(i)=strmid(new(i), 0, strlen(new(i))-1)
	endif
endfor


if (old(0) eq '') then return, new

; if duplicate button is depressed, just return both strings
if (duplicate eq 1) then return, [old,new]

; if duplicate button not depressed, we need to search for string entries
; in string array new which have occurred in string array old

newlen=n_elements(new)
oldlen=n_elements(old)

; The idea is to find the indices of the relevant string entries in new,
; then put them into an integer array a

; The array a must be initialized. The variable flag is necessary to
; help distinguish whether the unavoidable presence of integer value 0 in 
; array a means new(0) is really a non-unique string or it isn't.

a=[0]
for j=0,oldlen-1 do begin
	if (new(0) eq old(j)) then a=[a,0]
endfor
if n_elements(a) gt 1 then flag=1 else flag=0

; The following for loops are to check every string entry in new
; for any occurrence in old

a=[0]
for i=0,newlen-1 do begin
	for j=0,oldlen-1 do begin
		if new(i) eq old(j) then a=[a,i]
	endfor
endfor

; Let the occurrence of any value in a be unique
a=a(uniq(a,sort(a)))
sizea=n_elements(a)


; Finally, trim new accordingly and return a concatenated
; string, where possible.

if ((flag eq 0) and (sizea eq 1)) then return, [old,new] $

else if ((flag eq 0) and (sizea gt 1)) then a=a(1:(sizea-1))

newerlen=newlen-n_elements(a)

if (newerlen eq 0) then return, old

new(a)=''
newer=strarr(newerlen)

m=0
for k=0,newlen-1 do begin
	if (new(k) ne '') then begin
		newer(m)=new(k)
		if (m lt newerlen-1) then m=m+1
	endif
endfor	
return, [old,newer]

END



;*************************************************************************
; Event handler for the selectionbox.
;
;**************************************************************************

Pro select_event, event

COMMON picker_block, pathtxt, filttxt, dirlist,filelist, selecttxt,grablist, $
	grabbase,presentdir,b_allfiles,b_alldirs, b_hidden, b_clear,$
	b_duplicate,b_dirsel, c_ok, c_cancel, c_help, oldpath
COMMON list_items, dir_list, file_list, grab_list
COMMON toggle_items, hide, bduplicate

;get the id of the widget which generated the event
widget_control, event.id, get_uvalue = uvalue


case event.id of 


   pathtxt: $
	BEGIN
	widget_control, pathtxt, get_value=newpath
	newpath=newpath(0)

	; Check for the '~' character
	i = strpos(newpath, '~',0)

	if (i ne -1) then begin
		spawn, ['echo', newpath], result, /noshell
		newpath = result(0)
	endif

	filt=''

	len = strlen(newpath)-1
	if (drm_valid_dir(newpath(0)) eq 0 ) then begin
		if (strmid(newpath(0), strlen(newpath(0))-1, 1) ne '/') then $
			presentdir=newpath(0)+'/' else $
		presentdir = newpath(0)
		oldpath=presentdir

		cd, presentdir

		if (hide eq 0) then begin
                    directory=get_directory(filt)
                    dir_list=get_dirs(directory)
                    file_list=get_files(directory)
		endif else begin
                    directory=get_directory(filt, /hidden)
                    dir_list=get_dirs(directory)
                    file_list=get_files(directory)
		endelse

	endif else begin
		presentdir=oldpath
		endelse

		widget_control, filttxt, set_value=filt, $
			set_uvalue=filt
		widget_control, filelist, set_value=file_list, $
			set_uvalue=file_list
		widget_control, dirlist, set_value=dir_list, $
			set_uvalue=dir_list
		widget_control, selecttxt, set_value = presentdir, $
			set_uvalue = presentdir
		widget_control, pathtxt, set_value = presentdir, $
			set_uvalue = presentdir
 	END


   filttxt: $
	BEGIN
	widget_control, filttxt, get_value=filt
	filt=strtrim(strcompress(filt),2)
	file_list = getfiles(filt)  
		; getfiles is a function available in drm
	widget_control, filelist, set_value=file_list, set_uvalue=file_list
	widget_control, filttxt, set_value=filt, set_uvalue=filt
	END


   dirlist: $
	BEGIN
	widget_control, dirlist,get_uvalue=dir_list

	;check that the mouse cursor has been placed over a non-empty slot
	if (event.index gt n_elements(dir_list)-1) then return

	;check that dir selected is valid
	if (drm_valid_dir(dir_list(event.index)) ne 0) then return

	cd,dir_list(event.index)
	cd ,current=presentdir
	if (strmid(presentdir,0,8) eq '/tmp_mnt') then begin
	presentdir=strmid(presentdir,8,strlen(presentdir)-8)
	end
	presentdir = presentdir+'/'
	widget_control, pathtxt,set_value=presentdir,$
		set_uvalue=presentdir

	widget_control, selecttxt, set_value=presentdir

	filt=''
	if (hide eq 0) then begin
		directory=get_directory(filt)
                dir_list=get_dirs(directory)
                file_list=get_files(directory)
		endif else begin
		directory=get_directory(filt, /hidden)
                dir_list=get_dirs(directory)
		file_list=get_files(directory)
	endelse

	oldpath=presentdir
	widget_control, pathtxt, set_value=presentdir, $
		set_uvalue=presentdir
	widget_control, filttxt, set_value=filt, set_uvalue=filt
	widget_control, filelist,set_value=file_list, $
		set_uvalue=file_list
	widget_control, dirlist,set_value=dir_list,$
		set_uvalue=dir_list
	END


   filelist: $
	BEGIN
	widget_control, selecttxt,set_value=presentdir + $
		file_list(event.index)

	grab_list = update_list(presentdir + file_list(event.index), $
	 	grab_list,bduplicate)
	widget_control,grablist,set_value=grab_list,set_uvalue=grab_list
	widget_control,grabbase,get_uvalue = auto_exit
	if (auto_exit eq 1) then goto, checkfile
	END


   selecttxt: $
	BEGIN
	widget_control, event.id, get_value=text,get_uvalue=exist

	if (text(0) eq "") then return

	if (exist eq 1) then begin

	   if (drm_valid_dir(text(0)) eq 0 or $
		drm_valid_file(text(0)) eq 0) then begin
		grab_list=update_list(text(0) ,grab_list, bduplicate)
		widget_control, grablist, set_value= grab_list
		widget_control,grabbase,get_uvalue = auto_exit
		if (auto_exit eq 1) then goto, checkfile

	   endif
			
	endif else begin
	   grab_list=update_list(text(0), grab_list, bduplicate)
	   widget_control, grablist, set_value= grab_list
	endelse	
	END
	

   grablist:  $
	BEGIN
	if (event.index gt n_elements(grab_list)-1) then return
	if (n_elements(grab_list) eq 1) then begin
		grab_list = ""
	endif else begin
		for i=event.index, n_elements(grab_list)-2 do begin
		grab_list(i)=grab_list(i+1)
		endfor
		grab_list=grab_list(0:n_elements(grab_list)-2)
		endelse
	widget_control,grablist,set_value=grab_list,set_uvalue=grab_list
	END


   b_allfiles: $
	BEGIN
		grab_list=update_list(presentdir+file_list, $
			grab_list,bduplicate)
		widget_control, grablist, set_value=grab_list, $
			set_uvalue=grab_list
		widget_control,grabbase,get_uvalue = auto_exit
		if (auto_exit eq 1) then goto, checkfile
	END
		

   b_alldirs:  $
	BEGIN
	if n_elements(dir_list) eq 1 then begin
		grab_list=update_list(presentdir,grab_list,bduplicate)
	endif else begin
		dir_listing=presentdir+dir_list(where(dir_list ne '../'))
		dir_listing=[presentdir,dir_listing]
		grab_list=update_list(dir_listing,grab_list,bduplicate)
	endelse
	widget_control, grablist, set_value=grab_list, $
		set_uvalue=grab_list
	widget_control,grabbase,get_uvalue = auto_exit
	if (auto_exit eq 1) then goto, checkfile
	END


   b_hidden: $
	BEGIN
	filt=''
	widget_control, filttxt, set_val=filt, set_uval=filt
	if (event.select eq 1) then BEGIN
		hide = 1 
                directory=get_directory(filt, /hidden)
                dir_list=get_dirs(directory)
                file_list=get_files(directory)
	endif else begin
		hide =0
                directory=get_directory(filt)
                dir_list=get_dirs(directory)
                file_list=get_files(directory)
	endelse
	widget_control,dirlist,set_value=dir_list,$
		set_uvalue=dir_list
	widget_control,filelist, set_value=file_list,$
		set_uvalue=file_list
	END


   b_duplicate: $
	BEGIN
	if (event.select eq 0) then bduplicate=0 else bduplicate=1
	END
		

   b_clear: $
	BEGIN
	grab_list=""
	widget_control, grablist, set_value=grab_list, $
		set_uvalue=grab_list
	END


   b_dirsel: $
	BEGIN
	cd, current = directory
	if (strmid(directory,0,8) eq '/tmp_mnt') then begin
	directory=strmid(directory,8,strlen(directory)-8)
	end
	grab_list = update_list(directory+'/',grab_list,bduplicate)
	widget_control, grablist,set_value= grab_list

	widget_control,grabbase,get_uvalue = auto_exit
	if (auto_exit eq 1) then goto, checkfile
	END


   c_ok : widget_control, event.top, /destroy


   c_cancel: $
	BEGIN
	grab_list=""
	widget_control, event.top, /destroy
	END


   c_help: $
	begin
;	drm_help, fname='drm_multifpick'
	end

endcase

return

checkfile:
   if (auto_exit eq 1) then $ 
   widget_control, event.top, /destroy


END
 



;*************************************************************************
; Function drm_multifpick

;*************************************************************************

Function drm_multifpick, group=group, path=path, filter=filter, $
	title=title,must_exist=must_exist, noconfirm=noconfirm, $
	file=file, fix_filter=fix_filter,get_path=get_path

;@macro.include


COMMON picker_block, pathtxt, filttxt, dirlist,filelist, selecttxt,grablist, $
	grabbase,presentdir,b_allfiles,b_alldirs, b_hidden, b_clear,$
	b_duplicate,b_dirsel, c_ok, c_cancel, c_help, oldpath
COMMON list_items, dir_list, file_list, grab_list
COMMON toggle_items, hide, bduplicate

;setting up initial/default settings

presentdir = ""
grab_list =""
hide = 0
bduplicate=0

cd, current=dirsave
if (strmid(dirsave,0,8) eq '/tmp_mnt') then begin
dirsave=strmid(dirsave,8,strlen(dirsave)-8)
end

if (NOT keyword__set(path)) then begin
	path = dirsave+'/'
	presentdir = path
	cd, presentdir
endif else begin
	path=strtrim(path, 2)
	if (strmid(path, strlen(path)-1, 1) ne '/') then $
		path = path+'/'
	if (strmid(path, 0, 1) eq '/') then begin
		presentdir=path
	endif else if (strmid(path,0,2) eq './') then begin
		path=strmid(path, 2, strlen(path)-2)
		path=dirsave+'/'+path
		presentdir=path
	endif else begin
		path=dirsave+'/'
		presentdir=path
		end
	if (drm_valid_dir(presentdir) eq 0) then begin
		cd, presentdir
		endif else begin
		path=dirsave+'/'
		presentdir=path
		cd, presentdir
		end

endelse

BEGIN

  oldpath=presentdir

  if (not (keyword__set(title))) then $
	title = "Please Select a File/Directory"

  if (keyword__set(filter)) then $
	filt = filter $
  else filt=""

  if (keyword__set(must_exist) ) then $
	exist=1 else $
	exist = 0
  if (keyword__set(fix_filter)) then mapfilter = 0 else $
	mapfilter = 1

  if (keyword__set(noconfirm)) then auto_exit = 1 else $
	auto_exit = 0

  if (NOT keyword__set(file)) then file=""


;get filelist and dirlist
  directory=get_directory(filt)
  dir_list=get_dirs(directory)
  file_list=get_files(directory)

;create the widget bases and children
version = widget_info(/version)
if (version.style eq 'Motif') then osfrm=0 else osfrm=1

base = widget_base(title=title, /column)


;widebase and children
widebase = widget_base(base, /row)
pathlabel=widget_label(widebase, value="Path:")
pathtxt = WIDGET_TEXT(widebase,VAL=presentdir,/EDIT,FR=osfrm,XS=50) 


;filtbase and children
filtbase =      WIDGET_BASE(base, /ROW, map= mapfilter) 
filtlabel =       WIDGET_LABEL(filtbase, VALUE = "Filter:") 
filttxt =       WIDGET_TEXT(filtbase,VAL=filt,/EDIT,XS =20,FR=osfrm)


;selectbase and children
selectbase = widget_base(base, /row, space=30)
dirbase = widget_base(selectbase, /column, /frame)
dirlabel = widget_label(dirbase, value = "Subdirectories     ")
dirlist = widget_list(dirbase, value = dir_list,ysize=8, $
	uvalue=dir_list)
filebase = widget_base(selectbase, /column, /frame, xsize=200)
filelabel = widget_label(filebase, value = "Files        ")
filelist = widget_list(filebase, value = file_list, ysize=8, $
	uvalue = file_list, /frame)


;selecttxtbase and children
selecttxtbase = widget_base(base, /row,space=15)
selecttxtlabel = widget_label(selecttxtbase,value=" Choose ")
selecttxt = widget_text(selecttxtbase,value= presentdir+file, $
	xsize=45, /frame, uvalue=exist, /editable)


;grabbase and children
grabbase = widget_base(base, /column, uvalue = auto_exit) 
grablabel = widget_label(grabbase, value = "Selection(s) :   ")
grablist = widget_list(grabbase, ysize=5)


;buttonbase and children

buttonbase0 = widget_base(base, space=20, /row, /nonexclusive)
b_hidden = widget_button(buttonbase0, value=" Hidden ", $
	uvalue = "Hidden")
b_duplicate=widget_button(buttonbase0,value="Duplicate", $
	uvalue="Duplicate")

buttonbase1 = widget_base(base,space=20,/row)
b_allfiles = widget_button(buttonbase1, value  = "All Files", $
	uvalue = "All Files")
b_clear = widget_button(buttonbase1, value="Clear All",$
	uvalue="Clear All")
b_dirsel = widget_button(buttonbase1,value="Directory",$
	uvalue="Directory")
b_alldirs = widget_button(buttonbase1, value="All Dirs", $
	uvalue = "All Dirs")


;controlbase and children
controlbase = widget_base(base, space = 20, /row)
c_ok = widget_button(controlbase, value= "    OK    ", $
	uvalue = "Ok")
c_cancel = widget_button(controlbase, value="  Cancel  ", $
	uvalue = "Cancel")
c_help = widget_button(controlbase, value="  Help  ")

widget_control, base, /realize
xmanager, "select", base,/modal, group_leader=group

cd, dirsave

END
get_path = presentdir
if (n_elements(grab_list) eq 0) then return, ""
return,  grab_list(0:n_elements(grab_list)-1)
             

END
