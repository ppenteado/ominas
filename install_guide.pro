; docformat = 'rst'
;==============================================================================
;+
;
;	User Installation Guide 
;	=======================
;
;	This guide will cover the installation of OMINAS and common issues with
;	configuration, as well as present some common errors and possible
;	solutions. Please see the section entitled `Troubleshooting` for more
;	information regarding installation issues with OMINAS.
;
;	Requirements
;	============
;	To process images from a particular mission, that mission's kernels will
;	need to be downloaded separately from the 
;	`NAIF website <http://naif.jpl.nasa.gov/pub/naif/>`. A set of kernels can
;	be obtained using the UNIX wget or rsync commands, as desired.It is 
;	recommended to download the set of 
;	`generic_kernels <http://naif.jpl.nasa.gov/pub/naif/generic_kernels/>` to
;	supplement kernels from other missions.
;
;	OMINAS makes use of the NAIF Icy Toolkit to process SPICE kernels. The Icy
;	toolkit may optionally be obtained manually from 
;	`NAIF <https://naif.jpl.nasa.gov/naif/toolkit_IDL.html>`. However, the
;	installer utility provided with OMINAS can download and compile Icy
;	automatically. Installation of Icy is somewhat platform-dependent, so
;	troubleshooting information can be found in `Troubleshooting`.
;
;	Procedure
;	=========
;
;	1. Please ensure that OMINAS has been properly downloaded from the
;	`Github repository <https://github.com/ppenteado/ominas>` by entering
;	the following command at the terminal::
;
;	 git clone https://github.com/ppenteado/ominas
;
;	A local copy of the OMINAS source will be cloned automatically.
;
;	2. Configuration of OMINAS should be performed using the configuration
;	script, configure.sh, which is located in the top-level ominas directory.
;	This script can be run from the command line with::
;
;	 source configure.sh
;
;	3. A prompt will appear asking which packages should be installed. The
;	user should type the numbers of the desired packages separated by spaces.
;	If no packages are desired, the default package can be installed by typing
;	"def". Star catalogs or SEDR data may be configured without installing
;	packages. If no modifications to the package configuration are desired,
;	the "no" keyword skips this step.
;
;	4. Enter the location of the mission kernel pool for each desired
;	mission package. If the location is not known, or there is a typo,
;	the utility will attempt to find the kernel pool automatically by using
;	the default name in the NAIF archive (e.g., Cassini kernels are stored
;	in a folder called Cassini).
;
;	5. The installer will optionally attempt to install the Icy Toolkit from
;	the internet automatically. If a local copy of Icy is present, its
;	location may be entered manually or detected automatically. Once Icy
;	is installed, this step does not need to be performed again if further
;	modifications to the OMINAS configuration are desired.
;
;	6. Test the install of OMINAS has been completed correctly by running the
;	the following example scripts::
;
;	 idl saturn_example.pro
;	 idl jupiter_example.pro
;
;	7. A successful Icy installation can be tested with the following IDL
;	command::
;
;	 help, 'icy', /dlm
;
;	Some text on the installed version of Icy should be displayed. Additionally,
;	use the following command::
;
;	 print, cspice_tkvrsn('TOOLKIT')
;
;	The version of Icy should be printed. If both of these functions return
;	successfully, then Icy has been installed correctly.
;
;	Note: Demo
;	==========
;
;	If the demo configuration is set for OMINAS, no other types of images can
;	be processed other than the example scripts. To change this setting at a
;	later point, run the uninstall.sh script to unconfigure OMINAS, then run
;	configure.sh again, selecting not to configure the demo.
;
;	Alternatively, the following information can be changed in the
;	`~/.bash_profile' or '~/.bashrc' file::
;
;	 DFLAG=true; source <...>
;	
;	where <...> is the rest of the line. This line should be changed to::
;
;	 DFLAG=false; source <...>
;
;
;	Troubleshooting
;	===============
;
;	This section outlines several common sources of error which are due to
;	OMINAS not being configured correctly.
;
;	One of the most common configuration problems manifests as this error::
;
;	 % CSPICE_STR2ET: SPICE(NOLEAPSECONDS): [str2et_c->STR2ET->TTRANS] The variable that points to the leapseconds (DELTET/DELTA_AT)
;                  could not be located in the kernel pool.  It is likely that the leapseconds kernel has not been loaded via
;                  the routine FURNSH.
;
;	This error comes from the Icy toolkit. It specifically refers to the Leap
;	Second Kernel file, however, as the lsk is usually the first kernel which
;	is loaded, this error generally means that no kernels are being loaded.
;
;	You can check which kernels have been loaded by entering the following
;	IDL commands::
;
;	 cspice_ktotal, 'ALL', count
;	 for i=0,count-1 do begin & cspice_kdata,i,'ALL',file,type,source,handle,found & print,i,file & endfor
;	
;	A list will be populated with the currently loaded SPICE kernels, and
;	their load order. If no kernels are loaded, then it is likely that a bad
;	path was supplied to the kernel pools. Ensure that the kernel pool was
;	successfully entered into the environemnt by using the "env" command at
;	the terminal prompt. The kernel pool variable names follow a convention
;	like so: <MIS>_SPICE_<*K>, where <MIS> is the abbreviated mission name,
;	and <*K> is the type of kernel. Therefore, for Cassini, the bash command::
;
;	 env | grep CAS_SPICE
;
;	will list the path to directories containing each type of Cassini kernel.
;	If the variables are not present, then run the de-configuring utility, in
;	the ominas folder::
;
;	 source uninstall.sh
;
;	Then run the configuration utility again. Any custom path name supplied to
;	the configuration utility must be spelled correctly.
;
;	If the kernel environment variables are present, next check that the kernel
;	list contains the correct kernels. The kernel list file manually specifies
;	which kernels should be loaded in place of the OMINAS auto-detect
;	functionaliy. For Cassini, as an example, this file is located in
;	'ominas/config/cas/cassini.kernels'. At the beginning of this file, after
;	the header comments, check that the following line is present::
;
;	 $CAS_SPICE_LSK/naif00xx.tls
;
;	where xx is the number of the most recent leap second kernel file.
;
;
;	If no SPK kernels are loaded, the following error will be returned by Icy::
;
;	 % CSPICE_SPKGEO: SPICE(NOLOADEDFILES): [spkgeo_c->SPKGEO->SPKSFS] At least one SPK file needs to be loaded by SPKLEF before
;                  beginning a search.
;
;	The SPK kernels must be loaded from a mission kernel list. If they are not
;	being loaded correctly, then the kernel list is not being read as expected,
;	usually this is due to an incorrect kernel list path.
;
;
;	In some cases, a demo script will run and no error will appear to occur,
;	but no pointing will be overlayed on the image. This error generally occurs
;	due to the PCK kernels not being loaded or the CK kernels not being loaded
;	in the correct order.
;
;
;	When the frame kernel (FK) is not being loaded correctly for an image,
;	Icy will return the following error::
;
;	 % CSPICE_PXFORM: SPICE(EMPTYSTRING): [pxform_c] String "from" has length zero.
;
;	This error can be corrected by adding the following line to the kernel
;	list, after the LSK kernel line, in this example for Cassini::
;
;	 $CAS_SPICE_FK/cas_iss_vXX.tf
;
;	where XX is the most recent FK version.
;
;
;	Occasionally, in the course of modifying the OMINAS configuration without
;	performing a fresh uninstall and reconfigure, the "load order" of the
;	packages may be incorrect. When running a demo, the following error may
;	occur::
;
;	 % Illegal variable attribute: POINTS_P.
;
;	This can be corrected either by running the uninstall script, and then
;	the configuration script, or manually by editing the bash_profile or
;	bashrc for the user account::
;
;	 vim ~/.bash_profile
;	After editing the file to ensure that ominas_env_def.sh is the first file
;	which is loaded, refresh the profile::
;	 . ~/.bash_profile
;
;
;	If Icy is not installed, and a script is run, something similar to the
;	following error may occur::
;
;	 % Attempt to call undefined procedure: 'CSPICE_STR2ET'.
;
;	In general, the undefined procudure may have any cspice prefix. Icy is
;	either not configured correctly, or not installed. In IDL, check that
;	the Icy path has been added to the IDL path as follows::
;
;	 path = pref_get('IDL_PATH')
;	 print, path
;	 dlm_path = pref_get('IDL_DLM_PATH')
;	 print, dlm_path
;
;	The path variable should appear as a colon-separated list with
;	<IDL_DEFAULT> as the first entry. Check that both Icy and OMINAS
;	directories are added to the IDL_PATH, and that Icy is added to the
;	IDL_DLM_PATH. If Icy is not present in the list, it can be added with
;	these IDL commands::
;
;	 path = path + ':+path/to/icy'
;	 pref_set, 'IDL_PATH', path, /commit
;	 dlm_path = dlm_path + ':+path/to/icy'
;	 pref_set, 'IDL_DLM_PATH', dlm_path, /commit
;
;	You must exit and restart IDL for these changes to take effect.
;
;
;	When the incorrect kernels are being loaded, an error like this may appear,
;	this particular error comes from mosaic_example.pro::
;
;	 % Variable is undefined: MU0.
;	 % Execution halted at: PG_PHOTOM_GLOBE   159 path/to/ominas/nv/com/pg/pg_photom_globe.pro
;	 %                      PG_PHOTOM          99 path/to/ominas/nv/com/pg/pg_photom.pro
;	 %                      $MAIN$          
;
;	This error occurs when the incorrect kernel list is being used. Generally,
;	when processing a Cassini or other mission image, the demo should be turned
;	off through the configuration utility. If it is on, the demo kernel list
;	will be called, along with the demo translator. This setup will prevent
;	OMINAS from auto-detecting the correct kernels to load for the image.
;
;
;	A simple mistake that might be made can manifest in the following manner::
;
;	 -1
;	 % Variable is undefined: DD.
;
;	Note that OMINAS batch scripts must be opened from the directory from 
;	which they are located.
;
;-
;==============================================================================