;=============================================================================
;+
; NAME:
;	spice_input
;
;
; PURPOSE:
;	Generic NAIF/SPICE input translator core.  This routine is not a 
;	OMINAS input translator; it is intended to be called by an input
;	translator that is taylored to a specific mission. 
;
;
; CATEGORY:
;	NV/CONFIG
;
;
; CALLING SEQUENCE:
;	result = spice_input(dd, keyword, prefix)
;
;
; ARGUMENTS:
;  INPUT:
;	dd:		Data descriptor.
;
;	keyword:	String giving the name of the translator quantity.
;			The following keywords are recognized:
;
;			'CAM_DESCRIPTORS': The function [prefix]_spice_cameras
;					   Is called.
;
;			'PLT_DESCRIPTORS': The function [prefix]_spice_planets
;					   Is called.
;
;			'STR_DESCRIPTORS': The function [prefix]_spice_sun
;					   Is called.  Only the sun is
;				           recognized.
;
;	prefix:		String giving a prefix to use in constructing the names
;			of the input functions:
;
;			  [prefix]_spice_cameras
;			  [prefix]_spice_planets
;			  [prefix]_spice_sun
;
;			These functions are wrappers that prepare the relevant
;			inputs for a specific mission and call either
;			spice_cameras or spice_planets to obtain the appropriate
;			descriptors.  To obtain sun data, a planet descriptor is
;			obtained from spice_planets and converted to a star
;			descriptor.  See cas_spice_input for an example of how
;			to write such functions.
;
;  OUTPUT:
;	NONE
;
;
; KEYWORDS:
;  INPUT:
;	key1:		Camera descriptor.
;
;	key7:		Requested object time.
;
;	key8:		Array of requested object names.  Planets are requested
;			in the order given, except that the primary target body
;			is placed at the front of the list.
;
;  OUTPUT:
;	status:		Zero if valid data is returned.
;
;
;  TRANSLATOR KEYWORDS:
;	ref:		Name of the reference frame for the output quantities.
;			Default is 'j2000'.
;
;	j2000:		/j2000 is equivalent to specifying ref=j2000.
;
;	b1950:		/b1950 is equivalent to specifying ref=b1950.
;
;	klist:		Name of a file giving a list of SPICE kernels to use.
;			If no path is included, the path is taken from the 
;			NV_SPICE_KER environment variable.  Note that this
;			keyword is effective only before any kernels have been
;			loaded or when /reload is specified.  This file 
;			contains a list of file specifications, one per line.  
;			Lines beginning with '#' are ignored.  Kernels may
;			also be selected by image time using the keywords
;			START_TIME, STOP_TIME, and DEFAULT as in the 
;			following example:
;
;
;			$NV_SPICE_SPK/010419_SE_SAT077.bsp
;			$NV_SPICE_CK/051008_051217_s15s16_port3_pa.bc
;
;			START_TIME = 2002-270T10:57:56.870
;			 $NV_SPICE_SPK/000331R_SK_LP0_V1P32.bsp
;			 $NV_SPICE_SPK/010419_SE_SAT077.bsp
;			STOP_TIME = 2002-281T20:57:56.870
;
;			START_TIME = 2002-290T20:57:56.870
;			 $NV_SPICE_SPK/000331R_SK_LP0_V1P32.bsp
;			 $NV_SPICE_SPK/010419_SE_SAT077.bsp
;			STOP_TIME = 2002-291T20:57:56.870
;
;			DEFAULT
;			 $NV_SPICE_SPK/000331R_SK_LP0_V1P32.bsp
;			 $NV_SPICE_SPK/010419_SE_SAT077.bsp-bb
;
;
;			Files appearing before the first START_TIME are always
;			loaded.  If the image time is not covered in a
;			START/STOP_TIME block, then the DEFAULT kernels are
;			loaded.  Keywords must appear at the beginning of
;			the line and DEFAULT must come last.
;
;	<type>_in:	List of input kernels of the given type; e,g, ck_in,
;			spk_in, lsk_in, etc.  List must be delineated by 
;			semimcolons with no space.  The kernel list
;			file is still used, but these kernels take
;			precedence.  Entries in this list may be file
;			specification strings.  On each call, kernels are 
;			loaded and unloaded such that the kernel pool will 
;			consist of the klist kernels and these kernels.  
;			If the value 'auto' is given, then an attempt may be 
;			made to detect the correct kernel file for the given
;			image, depending on the instrument.  Kernels specified 
;			explicitly by name here take precedence over those 
;			determined using the auto-detection.  If a path
;			is specified with 'auto', the kernels that path
;			is used to autodetection instead of the path given
;			by the relevant environment variable.
;
;	reverse:	If set, klist kernels are loaded last, causing them to
;			take precedence.
;
;	<type>_reverse:	If set, the type of kernel will be loaded before
;			the klist, demoting their precedence.
;
;	<type>_strict:	Causes /strict to be passed to the corresponding
;			kernel auto-detection routine.  The behavior 
;			depends on the routine, but typically this will
;			result in fewer kernels being loaded.  
;
;	<type>_all:	Causes /all to be passed to the corresponding
;			kernel auto-detection routine.  The behavior 
;			depends on the routine, but typically this should
;			result in all kernels of the given type being loaded.  
;
;	protect:	Semicolon-delimited list of file specifications.  All
;			kernels matched are left untouched in the kernel pool.
;			If a file specification starts with '!', then only 
;			kernels not matched will be left untouched in the
;			kernel pool.
;
;	kloaded:	If set, the names of all loaded kernels are placed 
;			in the data descriptor in a user value with the
;			name LOADED_SPICE_KERNELS.  
;
;	reload:		If set, all kernels are unloaded and the current 
;			kernel pool is loaded from scratch.  The interface
;			operates very reliably, but very inefficiently using
;			this option.
;
;	constants:	If set, only kernels containing constants are loaded.
;			Only those quantities are filled in.
;
;	targets:	Name of text file listing the targets to be requested
;			from the kernel pool.  If not given, the name of the
;			file is taken from the environment variable
;			[prefix]_SPICE_TARGETS.
;
;	nokernels:	If set, the kernel pool will not be modified.
;
;	name:		If given, objects names are taken from this keyword
;			rather than from key8.
;
;	obs:		Name or NAIF ID of observer.  Default is SSB.
;
;	pos:		Get only position information, not pointing.
;
;	silent:		If set, various diagnostic messages will be suppressed.
;
;	strict_priority:If set, previously loaded kernels are uncloded and 
;			reloaded in order to preserve thei priority.  This is
;			potentially very slow.
;
;
;  ENVIRONMENT VARIABLES:
;	NV_SPICE_KER:		Directory containing the kernel list file.
;
;	NV_SPICE_<type>:	Directory containing the kernel files specified
;				using <type>_in.  Multiple directories can be
;				delimited using the ':' character.
;
;
; RETURN:
;	Data associated with the requested keyword.
;
;
; STATUS:
;	Complete
;
;
; SEE ALSO:
;	spice_output
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale, 10/2002
;	
;-
;=============================================================================
function spice_input, dd, keyword, prefix, values=values, status=status, $
@nv_trs_keywords_include.pro
@nv_trs_keywords1_include.pro
	end_keywords

 status=0
 n_obj=0
 dim = [1]

 if((keyword NE ('CAM_DESCRIPTORS')) AND $
    (keyword NE ('PLT_DESCRIPTORS')) AND $
    (keyword NE ('STR_DESCRIPTORS'))) then $
  begin
   status = -1
   return, 0
  end

 if(NOT spice_test()) then $
  begin
   status = -1
   return, 0
  end


 ;------------------------------------------------------------
 ; primary planet descriptors (key4) must not be present
 ;------------------------------------------------------------
 if(keyword_set(key4)) then $
  begin
   status = -1
   return, 0
  end

 ;-----------------------------------------------
 ; observer descriptor passed as key1
 ;-----------------------------------------------
 if(keyword_set(key1)) then od = key1
 if(keyword_set(od) AND (keyword EQ 'CAM_DESCRIPTORS')) then $
  begin
   status = -1
   return, 0
  end

 ;-----------------------------------------------
 ; default orientation passed as key3
 ;-----------------------------------------------
 if(keyword_set(key3)) then orient = key3
 
 ;-----------------------------------------------
 ; object times passed as key7
 ;-----------------------------------------------
 if(defined(key7)) then $
  begin
   if(size(key7, /type) NE 7) then time = key7 $
   else if(keyword_set(key7)) then time = key7
  end

 ;-----------------------------------------------
 ; object names passed as key8
 ;-----------------------------------------------
 if(keyword_set(key8)) then names = key8


 ;-----------------------------------------------
 ; translator arguments
 ;-----------------------------------------------

 ;- - - - - - - - - - - - - - - - - - -
 ; obs
 ;- - - - - - - - - - - - - - - - - - -
 obs = tr_keyword_value(dd, 'obs')
 if(str_isnum(obs) EQ 0) then obs = long(obs)

 ;- - - - - - - - - - - - - - - - - - -
 ; pos
 ;- - - - - - - - - - - - - - - - - - -
 pos = tr_keyword_value(dd, 'pos')

 ;- - - - - - - - - - - - - - - - - - -
 ; ref
 ;- - - - - - - - - - - - - - - - - - -
 ref = tr_keyword_value(dd, 'ref')
 if(NOT keyword_set(ref)) then ref = 'j2000'

 ;- - - - - - - - - - - - - - - - - - -
 ; j2000
 ;- - - - - - - - - - - - - - - - - - -
 j2000 = fix(tr_keyword_value(dd, 'j2000'))
 if(keyword_set(j2000)) then ref = 'j2000'

 ;- - - - - - - - - - - - - - - - - - -
 ; b1950
 ;- - - - - - - - - - - - - - - - - - -
 b1950 = fix(tr_keyword_value(dd, 'b1950'))
 if(keyword_set(b1950)) then ref = 'b1950'

 ;- - - - - - - - - - - - - - - - - - -
 ; silent
 ;- - - - - - - - - - - - - - - - - - -
 silent = fix(tr_keyword_value(dd, 'silent'))

 ;- - - - - - - - - - - - - - - - - - -
 ; reload
 ;- - - - - - - - - - - - - - - - - - -
 reload = fix(tr_keyword_value(dd, 'reload'))

 ;- - - - - - - - - - - - - - - - - - -
 ; constants
 ;- - - - - - - - - - - - - - - - - - -
 constants = fix(tr_keyword_value(dd, 'constants'))
 if(keyword_set(constants)) then time = -1

 ;- - - - - - - - - - - - - - - - - - -
 ; name
 ;- - - - - - - - - - - - - - - - - - -
 name = tr_keyword_value(dd, 'name')
 if(keyword_set(name)) then names = name

 ;- - - - - - - - - - - - - - - - - - -
 ; time
 ;- - - - - - - - - - - - - - - - - - -
 _time = tr_keyword_value(dd, 'time')
 if(defined(_time)) then $
  begin
   if(keyword_set(_time)) then time = _time $
   else if((size(_time, /type) NE 7)) then time = _time
  end

 ;- - - - - - - - - - - - - - - - - - -
 ; nokernels
 ;- - - - - - - - - - - - - - - - - - -
 nokernels = fix(tr_keyword_value(dd, 'nokernels'))

 ;- - - - - - - - - - - - - - - - - - -
 ; strict_priority
 ;- - - - - - - - - - - - - - - - - - -
 strict_priority = fix(tr_keyword_value(dd, 'strict_priority'))

 ;- - - - - - - - - - - - - - - - - - -
 ; /strict keywords
 ;- - - - - - - - - - - - - - - - - - -
 ck_strict = fix(tr_keyword_value(dd, 'ck_strict'))
 spk_strict = fix(tr_keyword_value(dd, 'spk_strict'))
 pck_strict = fix(tr_keyword_value(dd, 'pck_strict'))
 fk_strict = fix(tr_keyword_value(dd, 'fk_strict'))
 ik_strict = fix(tr_keyword_value(dd, 'ik_strict'))
 sck_strict = fix(tr_keyword_value(dd, 'sck_strict'))
 lsk_strict = fix(tr_keyword_value(dd, 'lsk_strict'))
 xk_strict = fix(tr_keyword_value(dd, 'xk_strict'))

 ;- - - - - - - - - - - - - - - - - - -
 ; /all keywords
 ;- - - - - - - - - - - - - - - - - - -
 ck_all = fix(tr_keyword_value(dd, 'ck_all'))
 spk_all = fix(tr_keyword_value(dd, 'spk_all'))
 pck_all = fix(tr_keyword_value(dd, 'pck_all'))
 fk_all = fix(tr_keyword_value(dd, 'fk_all'))
 ik_all = fix(tr_keyword_value(dd, 'ik_all'))
 sck_all = fix(tr_keyword_value(dd, 'sck_all'))
 lsk_all = fix(tr_keyword_value(dd, 'lsk_all'))
 xk_all = fix(tr_keyword_value(dd, 'xk_all'))

 ;- - - - - - - - - - - - - - - - - - -
 ; targets
 ;- - - - - - - - - - - - - - - - - - -
 targ_list = tr_keyword_value(dd, 'targets')
 if(NOT keyword_set(targ_list)) then $
  begin
   var = strupcase(prefix) + '_SPICE_TARGETS'
   targ_list = getenv(var)
  end 

 ;- - - - - - - - - - - - - - - - - - -
 ; reverse keywords
 ;- - - - - - - - - - - - - - - - - - -
 reverse= fix(tr_keyword_value(dd, 'reverse'))

 ck_reverse= fix(tr_keyword_value(dd, 'ck_reverse'))
 spk_reverse= fix(tr_keyword_value(dd, 'spk_reverse'))
 pck_reverse= fix(tr_keyword_value(dd, 'pck_reverse'))
 fk_reverse= fix(tr_keyword_value(dd, 'fk_reverse'))
 ik_reverse= fix(tr_keyword_value(dd, 'ik_reverse'))
 sck_reverse= fix(tr_keyword_value(dd, 'sck_reverse'))
 lsk_reverse= fix(tr_keyword_value(dd, 'lsk_reverse'))
 xk_reverse= fix(tr_keyword_value(dd, 'xk_reverse'))


 ;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
 ; protect keyword
 ;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
 protect = tr_keyword_value(dd, 'protect')


 ;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
 ; get time if needed
 ;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
 if((NOT keyword_set(time)) AND keyword_set(od)) then $
  begin
   if(NOT cor_isa(od[0], 'BODY')) then $
    begin
     status = -1
     return, 0
    end
   time = bod_time(od)
  end


 ;----------------------------------
 ; manage kernels
 ;----------------------------------
 if(NOT keyword_set(nokernels)) then $
  begin
   ;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
   ; Handle LS kernels now so that times can be compared in the kernel
   ; list file.
   ;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
   if(NOT keyword_set(constants)) then $
    begin
     lsk_in = spice_kernel_parse(dd, prefix, 'lsk', $
                exp=lsk_exp, strict=lsk_strict, all=lsk_all, time=time)

     spice_sort_kernels, lsk_in, $
       reload=reload, reverse=reverse, protect=protect, $
       lsk_in=lsk_in, lsk_exp=lsk_exp, $
       kernels_to_load=lsk_to_load, kernels_to_unload=lsk_to_unload, $
       lsk_reverse=lsk_reverse
     spice_load, lsk_to_load


     if(defined(time)) then $
         if(size(time, /type) EQ 7) then time = spice_str2et(time)

     ;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -  
     ; kernel list file
     ;  Kernels are read from this file and inserted into the kernel list
     ;  in front of the kernels input using translator keywords.  
     ;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
     klist = tr_keyword_value(dd, 'klist')
     if(keyword_set(klist)) then $
      begin
       if(strpos(klist, '/') EQ -1) then $
        begin
         kpath = spice_get_kpath('NV_SPICE_KER', klist)
         klist = kpath + '/' + klist
        end
       k_in = spice_read_klist(dd, klist, silent=silent, time=time, prefix=prefix)
      end
    end

   ;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
   ; kernel input keywords
   ;  Each type of kernel may be specified using a keyword named as <type>_in; 
   ;  e.g., "ck_in".  These kernels are appended to the kernel list after those 
   ;  read from the kernel list file, so they take precedence.
   ;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
   ck_in = ''
   if(NOT keyword_set(pos) AND (NOT keyword_set(od))) then $
     if(NOT keyword_set(constants)) then $
       ck_in = spice_kernel_parse(dd, prefix, 'ck', $
                 exp=ck_exp, strict=ck_strict, all=ck_all, time=time)

   if(NOT keyword_set(constants)) then spk_in = spice_kernel_parse(dd, prefix, 'spk', $
                    exp=spk_exp, strict=spk_strict, all=spk_all, time=time)
   pck_in = spice_kernel_parse(dd, prefix, 'pck', $
                    exp=pck_exp, strict=pck_strict, all=pck_all, time=time)
   fk_in = spice_kernel_parse(dd, prefix, 'fk', $
                    exp=fk_exp, strict=fk_strict, all=fk_all, time=time)
   ik_in = spice_kernel_parse(dd, prefix, 'ik', $
                    exp=ik_exp, strict=ik_strict, all=ik_all, time=time)
   if(NOT keyword_set(constants)) then sck_in = spice_kernel_parse(dd, prefix, 'sck', $
                    exp=sck_exp, strict=sck_strict, all=sck_all, time=time)
   xk_in = spice_kernel_parse(dd, prefix, 'xk', $
                    exp=xk_exp, strict=xk_strict, all=xk_all, time=time)


   all_kernels = ''
   if(keyword_set(k_in)) then all_kernels = append_array(all_kernels, k_in)
   if(keyword_set(ck_in)) then all_kernels = append_array(all_kernels, ck_in)
   if(keyword_set(spk_in)) then all_kernels = append_array(all_kernels, spk_in)
   if(keyword_set(pck_in)) then all_kernels = append_array(all_kernels, pck_in)
   if(keyword_set(fk_in)) then all_kernels = append_array(all_kernels, fk_in)
   if(keyword_set(ik_in)) then all_kernels = append_array(all_kernels, ik_in)
   if(keyword_set(sck_in)) then all_kernels = append_array(all_kernels, sck_in)
   if(keyword_set(lsk_in)) then all_kernels = append_array(all_kernels, lsk_in)
   if(keyword_set(xk_in)) then all_kernels = append_array(all_kernels, xk_in)

   ;-----------------------------------------------------------------
   ; Determine kernels to load / unload.  If no kernels specified, 
   ; the pool is left untouched.
   ;-----------------------------------------------------------------
   spice_sort_kernels, all_kernels, $
     reload=reload, reverse=reverse, protect=protect, $
     k_in=k_in, ck_in=ck_in, spk_in=spk_in, pck_in=pck_in, $
     fk_in=fk_in, ik_in=ik_in, sck_in=sck_in, lsk_in=lsk_in, xk_in=xk_in, $
     ck_exp=ck_exp, spk_exp=spk_exp, pck_exp=pck_exp, $
     fk_exp=fk_exp, ik_exp=ik_exp, sck_exp=sck_exp, lsk_exp=lsk_exp, xk_exp=xk_exp, $
     kernels_to_load=kernels_to_load, kernels_to_unload=kernels_to_unload, $
     ck_reverse=ck_reverse, spk_reverse=spk_reverse, pck_reverse=pck_reverse, $
     fk_reverse=fk_reverse, ik_reverse=ik_reverse, sck_reverse=sck_reverse, $
     lsk_reverse=lsk_reverse, xk_reverse=xk_reverse, strict_priority=strict_priority

   ;--------------------------------------------------------
   ; Only unload kernels when camera data requested
   ;  This is a hack to keep the C code working properly.
   ;--------------------------------------------------------
   if(keyword NE 'CAM_DESCRIPTORS') then kernels_to_unload = ''

   ;-----------------------------------------
   ; load/unload kernels
   ;-----------------------------------------
   spice_load, kernels_to_load, uk_in=kernels_to_unload
;   spice_cull
  end


 if(defined(time)) then $
         if(size(time, /type) EQ 7) then time = spice_str2et(time)


 ;--------------------------
 ; match keyword
 ;--------------------------
 case keyword of
  ;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  ; CAM_DESCRIPTORS
  ;  Construct a descriptor for the relevant camera.
  ;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  'CAM_DESCRIPTORS': $
	result = call_function(prefix + '_spice_cameras', time=time, pos=pos, $
                      constants=constants, dd, ref, n_obj=n_obj, dim=dim, $
                      status=status, orient=orient, obs=obs)

  ;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  ; PLT_DESCRIPTORS
  ;  Construct descriptors for all planets, or for those requested.  
  ;  Although the SUN is returned by NAIFLIB, it is not returned
  ;  here unless specifically requested.
  ;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  'PLT_DESCRIPTORS': $
	begin
         names0 = ''
         if(keyword_set(names)) then names0 = names
	 result = call_function(prefix + '_spice_planets', dd, ref, $
                     time=time, targ_list=targ_list, constants=constants, $
	             n_obj=n_obj, dim=dim, status=status, planets=names, obs=obs)
	 if(NOT keyword_set(result)) then status = -1 $
	 else if((where(names0 EQ 'SUN'))[0] EQ -1) then $
	  begin
	   names = cor_name(result)
  	   w = where(strupcase(names) EQ 'SUN')
	   if(w[0] NE -1) then $
            begin
             result = rm_list_item(result, w[0], only=nv_ptr_new())
             n_obj = n_obj - 1
            end
	  end
	end

  ;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  ; STR_DESCRIPTORS
  ;  Construct descriptors for all stars.  The only star that would be 
  ;  returned by NAIFLIB is the sun.
  ;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  'STR_DESCRIPTORS': $
	result = call_function(prefix + '_spice_sun', dd, ref, $
	                       time=time, constants=constants, $
	                       n_obj=n_obj, dim=dim, status=status, obs=obs)

  else: $
	begin
	 status = -1
	 result = 0
	end
 endcase

 if(NOT keyword_set(result)) then status = -1
	

 ;- - - - - - - - - - - - - - - - - - - - - - - - - - - - -
 ; kloaded
 ;  One may obtain the names of loaded kernels by calling
 ;  spice_loaded() directly, but that requires the caller 
 ;  to interact directly with the spice interface instead 
 ;  working through standard OMINAS channels.
 ;- - - - - - - - - - - - - - - - - - - - - - - - - - - - -
 kloaded = tr_keyword_value(dd, 'kloaded')
 if(keyword_set(kloaded)) then $
  begin
   names = spice_loaded()
   if(keyword_set(names)) then $
    begin
     tag = 'LOADED_SPICE_KERNELS'
     cor_set_udata, dd, tag, names
    end
  end



 return, result
end
;===========================================================================
