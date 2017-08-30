;=============================================================================
;+
; NAME:
;       const_get
;
;
; PURPOSE:
;       Returns the values of physical constants relative to whatever system
;	of units is selected.
;
;
; CATEGORY:
;       UTIL/CONST
;
;
; CALLING SEQUENCE:
;       result = const_get(name, units=units)
;
;
; ARGUMENTS:
;  INPUT:
;       name:	String giving the name of the desired constant.
;
;  OUTPUT:
;       NONE
;
;
; KEYWORDS:
;  INPUT:
;       units:	String giving the name of the unit system.  If not given,
;		first the comomn block is checked for any unit system
;		set using const_set_units.  If no unit system exists, then
;		the environment variable CONST_UNITS is checked.  If still no
;		unit system ecists, then it defaults to 'mks'.
;
;  OUTPUT:
;       NONE
;
;
; ENVIRONMENT VARIABLES:
;       CONST_UNITS:    Selects the unit system to use if one has not been set 
;			using const_set_units.
;
;
; RETURN:
;       The value of the named constant is returned relative to the selected
;	unit system.
;
;
; PROCEDURE:
;	The name of the selected units system is taken as a prefix for 
;	the function <prefix>_const, which takes the name of a unit as input
;	and returns the value of the selected constant.  See mks_const.pro
;	for an example.
;
;
; COMMON BLOCKS:
;       const_block:     Stores the name of the software-selected unit system.
;
;
; STATUS:
;       Complete
;
;
; SEE ALSO:
;       const_set_units, const_mks
;
;
; MODIFICATION HISTORY:
;       Written by:     Spitale, 3/2006
;
;-
;=============================================================================
function const_get, name, units=units

 if(NOT keyword_set(units)) then units = const_get_units()

 result = call_function('const' + '_' + strlowcase(units), name)
 if(NOT keyword_set(result)) then message, name + ' undefined.'

 return, result
end
;============================================================================
