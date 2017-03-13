;=============================================================================
;+
; NAME:
;	pg_hide
;
;
; PURPOSE:
;	Hides the given points with respect to each given object and observer
;	using pg_hide/rm_disk, pg_hide/rm_globe, or pg_hide_limb.
;
;
; CATEGORY:
;	NV/PG
;
;
; CALLING SEQUENCE:
;	pg_hide, object_ptd, cd=cd, od=od, gbx=gbx, dkx=dkx, /[disk|globe|limb]
;	pg_hide, object_ptd, gd=gd, od=od, /[disk|globe|limb]
;
;
; ARGUMENTS:
;  INPUT: 
;	object_ptd:	Array of POINT containing inertial vectors.
;
;	hide_ptd:	Array (n_disks, n_timesteps) of POINT 
;			containing the hidden points.
;
;  OUTPUT: NONE
;
;
; KEYWORDS:
;  INPUT:
;	globe:	If set, use pg_hide_globe.
;
;	disk:	If set, use pg_hide_disk.
;
;	limb:	If set, use pg_hide_limb .
;
;	rm:	If set use the *rm* programs instead of *hide* programs.
;
;	  All other keywords are passed directly to pg_rm/hide_globe,
;	  pg_hide/rm_disk or pg_hide_limb and are documented with those
;	  programs.
;
;  OUTPUT: NONE
;
;
; RETURN: NONE
;
;
; SIDE EFFECTS:
;	The flags arrays in object_ptd are modified.
;
;
; PROCEDURE:
;	For each object in object_ptd, hidden points are computed and
;	PS_MASK_INVISIBLE in the POINT is set.  No points are
;	removed from the array.
;
;
; EXAMPLE:
;	(1) The following command hides all points on the planet which lie
;	    behind the terminator:
;
;	    pg_hide, object_ptd, /limb, gbx=pd, od=sd
;
;	    In this call, pd is a planet descriptor, and sd is a star descriptor
;	    (i.e., the sun).
;
;
;
;	(2) This command hides all points on the planet which are shadowed by
;	    the rings:
;
;	    pg_hide, object_ptd, /disk, dkx=rd, od=sd
;
;	    In this call, rd is a ring descriptor, and sd is as above.
;
;
;
;	(3) This command hides all points which lie behind the planet or the
;	    rings:
;
;	    pg_hide, object_ptd, /disk, /globe, dkx=rd, gbx=pd, cd=cd
;
;	    In this call, rd is a ring descriptor, pd is a planet descriptor, 
;	    cd is a camera descriptor, and sd is as above.
;
;
; STATUS:
;	Complete
;
;
; SEE ALSO:
;	pg_hide_disk, pg_hide_globe, pg_hide_limb
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale, 2/1998
;	
;-
;=============================================================================
pro pg_hide, object_ptd, hide_ptd, cd=cd, one2one=one2one, $
             od=od, gbx=gbx, dkx=dkx, gd=gd, $
	     globe=globe, limb=limb, disk=disk, rm=rm, reveal=reveal, cat=cat

 if(arg_present(hide_ptd)) then hide_ptd = 1	; need this to allow called routines
						; to detect presence of hide_ptd argument.

 ptd = object_ptd

 if(keyword_set(disk)) then $
   pg_hide_disk, rm=rm, ptd, hide_ptd, cd=cd, od=od, dkx=dkx, gbx=gbx, gd=gd, reveal=reveal, cat=cat

 if(keyword_set(globe)) then $
   pg_hide_globe, rm=rm, ptd, hide_ptd, cd=cd, od=od, gbx=gbx, gd=gd, reveal=reveal, cat=cat

 if(keyword_set(limb)) then $
   pg_hide_limb, ptd, hide_ptd, cd=cd, od=od, gbx=gbx, gd=gd, reveal=reveal

end
;=============================================================================
