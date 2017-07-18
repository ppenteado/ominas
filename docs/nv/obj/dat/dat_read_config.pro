;=============================================================================
;+
; NAME:
;	dat_read_config
;
;
; PURPOSE:
;	Reads an NV configuration table.
;
;
; CATEGORY:
;	NV/SYS
;
;
; CALLING SEQUENCE:
;	dat_read_config, env, table_p, filenames_p
;
;
; ARGUMENTS:
;  INPUT:
;	env:	Name of an environment variable giving the names of the
;		configuration files to read, delimited by ':'.
;
;  OUTPUT:
;	table_p:	Pointer to the configuration table contructed by
;			concatenating the contents of each file.
;
;	filenames_p:	List of configuration filenames that were read.
;
;
; KEYWORDS:
;  INPUT: NONE
;
;  OUTPUT: NONE
;
;
; RETURN: NONE
;
;
; STATUS:
;	Complete
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale
;	
;-
;=============================================================================
pro dat_read_config, env, table_p, filenames_p, continue=continue, status=status
@core.include

 status = 0

 ;----------------------------------
 ; separate files list
 ;----------------------------------
 path = getenv(env)
 if(NOT keyword_set(path)) then $
    nv_message, /con, 'Environment variable ' + env + ' not defined.'

 filenames = str_nsplit(path, ':')

 w = where(filenames NE '')
 if(w[0] EQ -1) then $
  begin
   status = -1
   return
  end
 filenames = filenames[w]

 if(NOT keyword_set(filenames[0])) then $
  begin
   nv_message, name='dat_read_config', /con, $
     'Unable to obtain ' + env +' from the environment.', $                         
       exp=[env + ' is a colon-separated list of files that are concatenated', $
            'into a single master table.']
   status = -1
   return
  end


 ;----------------------------------
 ; concatenate all files
 ;----------------------------------
 n = n_elements(filenames)
 for i=0, n-1 do $
  begin
   s = read_txt_file(filenames[i], status=status)
   if(status EQ 0) then lines = append_array(lines, s) $
   else nv_message, /con, 'Not found: ' + filenames[i]
  end

 w = where(lines NE '')
 if(w[0] EQ -1) then return
 lines = lines[w]


 ;----------------------------------
 ; parse table
 ;----------------------------------
 table = read_txt_table(lines=lines)




 *filenames_p = filenames
 *table_p = table
end
;===========================================================================
