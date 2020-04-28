;==============================================================================
;+
; NAME:
;	nv_module_list
;
;
; PURPOSE:
;	Lists all known modules along with their status.
;
;
; CATEGORY:
;	NV/SYS
;
;
; CALLING SEQUENCE:
;	nv_module_list
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
; 	Written by:	Spitale		3/2020
;	
;-
;==============================================================================



;==============================================================================
; nvmb_query
;
;==============================================================================
pro nvmb_query, module, level, status, name, abbr, qname

 if(NOT keyword_set(level)) then level = 0

 ;------------------------------------------------------
 ; print module info
 ;------------------------------------------------------
 stat = strarr(6)
 stat[*] = '-'
 if(nv_module_query(module, /active)) then stat[0] = 'A'
 if(nv_module_query(module, /installed)) then stat[1] = 'I'
 if(nv_module_query(module, /installing)) then stat[1] = 'i'
 if(nv_module_query(module, /suppressed)) then stat[2] = 'S'
 if(nv_module_query(module, /broken)) then stat[3] = 'B'
 if(nv_module_query(module, /protected)) then stat[4] = 'P'
 if(nv_module_query(module, /locked)) then stat[5] = 'L'

 status = append_array(status, str_cat(stat))
 name = append_array(name, strupcase(module.name))
 abbr = append_array(abbr, strupcase(module.abbr))
 qname = append_array(qname, strupcase(module.qname))

 ;------------------------------------------------------
 ; query submodules
 ;------------------------------------------------------
 submodules = nv_get_submodules(module)
 if(keyword_set(submodules)) then $
    for i=0, n_elements(submodules)-1 do $
           nvmb_query, submodules[i], level+1, status, name, abbr, qname


end
;==============================================================================



;==============================================================================
; nv_module_list
;
;==============================================================================
pro nv_module_list

 ominas = nv_get_module()
 nvmb_query, ominas, 0, status, name, abbr, qname

 nstat = max(strlen(status)) + 1
 nabbr = max(strlen(abbr)) + 1
 nname = max(strlen(name)) + 1
 n_name_abbr = nabbr + nname + 2

 print
 print, str_pad('Status', nstat) + $
          str_pad('Name [abbr]', n_name_abbr) + 'Fully qualified name'
 print, str_pad('', 80, c='-')
 print, transpose(status + ' ' + $
         str_pad(name + ' [' + abbr + ']', n_name_abbr, c='.') + qname)
end
;=============================================================================
