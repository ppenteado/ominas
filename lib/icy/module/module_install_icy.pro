;=============================================================================
; module_install_icy_test
;
;=============================================================================
function module_install_icy_test, icy_dir, method_dir

 print, 'Testing precompiled binaries'

 command = getenv('idlbin') + ' -IDL_DLM_PATH "<IDL_DEFAULT>":' $
   + icy_dir + '/lib/ -e "!path+=' + "':" + method_dir + ':' $
   + icy_dir + '/lib/' + "'" +  ' & icy_test"'
 spawn, command + '>& /dev/null', result, exit_status=status

 return, status
end
;=============================================================================



;=============================================================================
; module_install_icy_build
;
;=============================================================================
pro module_install_icy_build, icy_dir, method_dir

 print, 'Building icy'

 catch,err
 if(err) then $
  begin
   catch, /cancel
   return
  end

 ff = file_search('/bin/csh')
 if(NOT keyword_set(ff)) then return

 cd, icy_dir, current=pwd
 command = '/bin/csh makeall.csh'
 spawn, command
 cd, pwd

end
;=============================================================================



;=============================================================================
; module_install_icy
;
;=============================================================================
function module_install_icy, data

 ;----------------------------------------------------------
 ; downlioad tar file into temp dir
 ;----------------------------------------------------------
 print, 'Downloading archive'

 baseurl = 'http://naif.jpl.nasa.gov/pub/naif/toolkit//IDL/'

 oss = 'PC_Linux_GCC'
 if(!version.os EQ 'Darwin') then oss = 'MacIntel_OSX_AppleC'
 bits = strtrim(!version.memory_bits,2) + 'bit'
 tmpdir = getenv('OMINAS_TMP')

 url = baseurl + oss + '_IDL8.x_' + bits + '/packages/icy.tar.Z'
 wcp, url, tmpdir, /verbose


 ;----------------------------------------------------------
 ; extract tar file into specified dir
 ;----------------------------------------------------------
 print, 'Extracting tar file'

 Zfile = file_search(tmpdir + '/*icy*.Z')
 file_unz, Zfile		; this involves a spawn call; better to replace
				; with file_gunzip if NAIF ever provides
				; a .gz file instead of a .Z file.
; file_gunzip, Zfile

 tarfile = ext_rep(Zfile, '')
 file_untar, tarfile, data.dir + '/..'


 ;----------------------------------------------------------
 ; test the icy binaries
 ;----------------------------------------------------------
 status = module_install_icy_test(data.dir, data.method_dir)

 if(status NE 0) then $
  begin
   print, 'Precompiled binaries failed'
   module_install_icy_build, data.dir, data.method_dir
   status = module_install_icy_test(data.dir, data.method_dir)
  end

 print, 'Installation ' + (status ? 'failed' : 'complete') + '.'
 return, status
end
;=============================================================================
