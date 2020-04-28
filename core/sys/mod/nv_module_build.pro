;==============================================================================
;+
; NAME:
;	nv_module_build
;
;
; PURPOSE:
;	Builds the ominas configuration, consisting of the setup script
;	(.ominas/ominas_set.sh) and detector tables.
;
;
; CATEGORY:
;	NV/SYS
;
;
; CALLING SEQUENCE:
;	nv_module_build
;
;
; ARGUMENTS:
;  INPUT: NONE
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
; RETURN:  NONE
;
;
; STATUS:
;	Complete
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale		1/2020
;	
;-
;==============================================================================



;==============================================================================
; nvmb_add_table
;
;==============================================================================
function nvmb_add_table, env, file
 return, 'export '+ env + '=${' + env + '}:'  + file
end
;==============================================================================



;==============================================================================
; nvmb_descend
;
;==============================================================================
pro nvmb_descend, module, lines, level

 if(NOT keyword_set(level)) then level = 0
 profile_dir =  nv_module_get_profile_dir(module)
 setup_file = profile_dir + '/setup.sh'
 submodules = nv_get_submodules(module)

 indent = str_pad(' ', level)

 ;------------------------------------------------------
 ; comment
 ;------------------------------------------------------
 bar = '#' + str_pad('-', 75-strlen(indent), c='-')
 lines = append_array(lines, ' ')
 lines = append_array(lines, indent + bar)
 lines = append_array(lines, indent + '# ' + strupcase(module.qname))
 lines = append_array(lines, indent + bar)

 ;------------------------------------------------------
 ; build conditional for suppressing module
 ;------------------------------------------------------
 suppress_env = module.vname+'_SUPPRESS'
 suppress_start = indent + $
    [ 'if [ ! -v ' + suppress_env + ' ];', $
      ' then' ]
 suppress_end = indent + ' fi'

 ;------------------------------------------------------
 ; add module methods to IDL_PATH
 ;------------------------------------------------------
 lines = append_array(lines, $
                      indent + 'export IDL_PATH=${IDL_PATH}:' + module.method_dir)

 ;------------------------------------------------------
 ; check for setup script, go no deeper if none present
 ;------------------------------------------------------
 ff = file_search(setup_file)
 if(NOT keyword_set(ff)) then return

 ;------------------------------------------------------
 ; standard module variables
 ;------------------------------------------------------
 standard_lines = ''
 if(module.name NE 'ominas') then $
  begin
   standard_lines = append_array(standard_lines, $
                      indent + 'export '+ module.vname + '=' + module.dir)
   standard_lines = append_array(standard_lines, $
                      indent + 'export '+ module.vname + '_DATA=' + module.data_dir)
  end

 ;------------------------------------------------------
 ; add module code to IDL_PATH
 ;------------------------------------------------------
 plus = keyword_set(submodules) ? '' : '+'
 standard_lines = append_array(standard_lines, $
                        indent + 'export IDL_PATH=${IDL_PATH}:' + plus + module.dir)

 ;------------------------------------------------------
 ; setup code
 ;------------------------------------------------------
 code = strip_comment(read_txt_file(setup_file, /raw))
 if(keyword_set(code)) then code_lines = append_array(code_lines, indent + code)

 ;------------------------------------------------------
 ; detectors 
 ;------------------------------------------------------
 det_env = nv_env_name(/detector)
 det_file = file_search(profile_dir + '/detect_*.pro')
 if(keyword_set(det_file)) then det_lines = indent + nvmb_add_table(det_env, det_file)

 ;------------------------------------------------------
 ; tables 
 ;------------------------------------------------------
 trs_env = nv_env_name(/translator)
 trf_env = nv_env_name(/transform)
 io_env = nv_env_name(/io)
 ftp_env = nv_env_name(/filetype)
 ins_env = nv_env_name(/instrument)

 trs_file = file_search(profile_dir + '/translators.tab')
 if(keyword_set(trs_file)) then trs_lines = indent + nvmb_add_table(trs_env, trs_file)

 trf_file = file_search(profile_dir + '/transforms.tab')
 if(keyword_set(trf_file)) then trf_lines = indent + nvmb_add_table(trf_env, trf_file)

 io_file = file_search(profile_dir + '/io.tab')
 if(keyword_set(io_file)) then io_lines = indent + nvmb_add_table(io_env, io_file)

 ftp_file = file_search(profile_dir + '/filetype_detectors.tab')
 if(keyword_set(ftp_file)) then ftp_lines = indent + nvmb_add_table(ftp_env, ftp_file)

 ins_file = file_search(profile_dir + '/instrument_detectors.tab')
 if(keyword_set(ins_file)) then ins_lines = indent + nvmb_add_table(ins_env, ins_file)

 tab_lines = append_array(trs_lines, trf_lines)
 tab_lines = append_array(tab_lines, io_lines)
 tab_lines = append_array(tab_lines, ftp_lines)
 tab_lines = append_array(tab_lines, ins_lines)


 ;------------------------------------------------------
 ; assemble new lines
 ;------------------------------------------------------
 new_lines = append_array(standard_lines, tab_lines)
 new_lines = append_array(new_lines, det_lines)
 new_lines = append_array(new_lines, code_lines)

; if(keyword_set(new_lines)) then lines = append_array(lines, new_lines)
 if(keyword_set(new_lines)) then $
        lines = append_array(lines, [suppress_start, '  ' + new_lines, suppress_end])


 ;------------------------------------------------------
 ; add submodules
 ;------------------------------------------------------
 if(keyword_set(submodules)) then $
    for i=0, n_elements(submodules)-1 do $
                               nvmb_descend, submodules[i], lines, level+1


end
;==============================================================================



;==============================================================================
; nv_module_build
;
;==============================================================================
pro nv_module_build, setup_dir=setup_dir

 setup_dir = nv_module_get_setup_dir(setup_dir=setup_dir)

 ;------------------------------------------------
 ; build script
 ;------------------------------------------------
 ominas = nv_get_module()
 nvmb_descend, ominas, lines
 if(NOT keyword_set(lines)) then lines = '### no module setup code ### '

 ;------------------------------------------------
 ; header and footer
 ;------------------------------------------------
 header = [ $
   '#!/usr/bin/env bash', $
   '###############################################################################', $
   '# OMINAS setup script', $
   '#', $
   '#  This file is automatically generated by the OMINAS module API.  Its', $
   '#  contents may be controlled via the OMIN interface.  Default code is', $
   '#  provided in the individual setup.sh files inside each module.  If you', $
   '#  need to add commands to be executed before starting OMINAS, we suggest', $
   '#  placing them in either your ~/.bashrc or your ~/.profile (in which case', $
   '#  they will be executed before ~/.ominas/ominas_setup.sh), or in ', $
   '#  ~/.ominas/ominas_postsetup.sh (which is executed at the end of this script, ', $
   '#  so it can make use of other OMINAS variables).  That file is never ', $
   '#  overwritten.', $
   '#', $
   '###############################################################################' $
  ]

 profile = nv_module_get_profiles(/current)
 header = [header, '# Using profile: ' + profile]
      


 footer = [ $
   ' ', $
   ' ', $
   '###############################################################################', $
   '# User post-setup code', $
   '###############################################################################', $
   '. ' + setup_dir + '/ominas_postsetup.sh']

 ;------------------------------------------------
 ; write script
 ;------------------------------------------------
 script = [header, lines, footer]
 write_txt_file, setup_dir + '/_ominas_setup.sh', script

end
;=============================================================================
