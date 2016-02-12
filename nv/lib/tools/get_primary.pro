;=============================================================================
;+
; NAME:
;       get_primary
;
;
; PURPOSE:
;	Attempts to determine the primary planet from a list of descriptors
;	based on their names and proximity to the observer.
;
;
; CATEGORY:
;       NV/LIB/TOOLS
;
;
; CALLING SEQUENCE:
;       gbx0 = get_primary(bx, gbx)
;
;
; ARGUMENTS:
;  INPUT:
;	bx:	Array (nt) of any subclass of BODY, describing the observer.
;
;	gbx:	Array (nd,nt) of any subclass of GLOBE, specifying a 
;		system of globe objects.
;
;  OUTPUT:
;       NONE
;
;
; KEYOWRDS:
;  INPUT: 
;	rx:	Any subclass of RING.
;	
;	planets:	Array of names of objects to consider as planets.
;			Default is the planets of the Solar System, or the
;			primary planet of rx, if provided.
;
;  OUTPUT: NONE
;
;
; RETURN: 
;	GLOBE descriptor for the selected primary. 
;
;
; MODIFICATION HISTORY:
;       Written by:     Spitale
;
;-
;=============================================================================
function get_primary, od, gbx, planets=planets, rx=rx

 nt = n_elements(od)

 if(keyword__set(rx)) then $
  begin
   rd = class_extract(rx, 'RING')
;   if(NOT keyword_set(rd)) then return, 0 
  end

 if(NOT keyword_set(gbx)) then return, 0

 if(keyword_set(rd)) then planets = rng_primary(rd)

 if(NOT keyword_set(planets)) then $
   planets = ['mercury', 'venus', 'earth', 'mars', $
              'jupiter', 'saturn', 'uranus', 'neptune']

 ss = sort(planets)
 planets = planets[ss]
 uu = uniq(planets)
 planets = planets[uu]

 nplanets = n_elements(planets)

 gbx0 = ptrarr(nt)
 for j=0, nt-1 do $
  begin
   ;------------------------------------------------
   ; determine which given gbx are planets
   ;------------------------------------------------
   planets = strlowcase(planets)
   names = strlowcase(cor_name(gbx[*,j]))
   for i=0, nplanets-1 do $
    begin
     w = where(strpos(names, planets[i]) NE -1)
     if(w[0] NE -1) then ii = append_array(ii, w)
    end

   if(keyword__set(ii)) then $	; keyword__set intended
    begin
     ;------------------------------------------------
     ; take closest planet
     ;------------------------------------------------
     nii = n_elements(ii)
     if(nii EQ 1) then gbx0[j] = gbx[ii,j] $
     else $
      begin
       r0 = bod_pos(od) ## make_array(nii, val=1d)

       d2 = v_sqmag(r0 - transpose(bod_pos(gbx[ii,j])))

       w = where(d2 EQ min(d2))
       gbx0[j] = gbx[ii[w[0]]]
      end
    end
  end

 return, gbx0
end
;=============================================================================
