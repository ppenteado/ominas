;========================================================================
;+
; NAME:
;       ctlookup
;
; PURPOSE:
;       Returns a string giving the name of a color corresponding to a 
;	given color index.
;
;
; CATEGORY:
;       UTIL/CT
;
;
; CALLING SEQUENCE:
;       result = ctlookup(color)
;
; ARGUMENTS:
;  INPUT:
;       color:	Color index to lookup.
;
;  OUTPUT:
;    NONE
;
;
; RETURN:
;	String giving the color name or '' if not found.
;
;-
;========================================================================
function ctlookup, color

 type = size(color, /type)
 if(type EQ 7) then return, color

 n = n_elements(color)
 s = strarr(n)


 w = where(color EQ ctblue())
 if(w[0] NE -1) then s[w] = 'blue'
 w = where(color EQ ctcyan())
 if(w[0] NE -1) then s[w] = 'cyan'
 w = where(color EQ ctgreen())
 if(w[0] NE -1) then s[w] = 'green'
 w = where(color EQ ctpurple())
 if(w[0] NE -1) then s[w] = 'purple'
 w = where(color EQ ctred())
 if(w[0] NE -1) then s[w] = 'red'
 w = where(color EQ ctwhite())
 if(w[0] NE -1) then s[w] = 'white'
 w = where(color EQ ctyellow())
 if(w[0] NE -1) then s[w] = 'yellow'
 w = where(color EQ ctorange())
 if(w[0] NE -1) then s[w] = 'orange'
 w = where(color EQ ctbrown())
 if(w[0] NE -1) then s[w] = 'brown'
 w = where(color EQ ctpink())
 if(w[0] NE -1) then s[w] = 'pink'

 return, s



 case color of
  ctblue()	: return, 'blue'
  ctcyan()	: return, 'cyan'
  ctgreen()	: return, 'green'
  ctpurple()	: return, 'purple'
  ctred()	: return, 'red'
  ctwhite()	: return, 'white'
  ctyellow()	: return, 'yellow'
  ctorange()	: return, 'orange'
  ctbrown()	: return, 'brown'
  ctpink()	: return, 'pink'
  else 		: return, ''
 endcase

end
;========================================================================
