; docformat = 'rst'
;===============================================================================
;+
;                            PREDICT EXAMPLE
;
;  Created by Joe Spitale
;
;  This example script demonstrates the usage of OMINAS with no data.  Instead
;  of reading a data file using DAT_READ, the geometry is tied to a set of
;  observation times.
;
;  This example file can be executed from the UNIX command line using::
;
;  	ominas predict_example-batch
;
;  or from within IDL using::
;
;  	@predict_example-batch
;-
;==============================================================================
!quiet = 1


;-------------------------------------------------------------------------
;+
; OBSERVATION PARAMETERS
;
;  Here we set basic parameters of the observation; start and stop times,
;  number of time steps, name of instrument.  Note that the times could also
;  be given numerically.  The interpretation of the times is performed by
;  the translators (see next step):: 
;
;     instrument = 'CAS_ISS_NA'
;     times = ['2016-028T03:42:00','2016-028T15:37:00']
;     nt = 5
;
;-
;-------------------------------------------------------------------------
instrument = 'CAS_ISS_NA'
times = ['2016-028T03:42:00','2016-028T15:37:00']
nt = 5


;-------------------------------------------------------------------------
;+
; GET CAMERA POSITIONS
;
;  Camera descriptors are obtained for the start and stop times in order
;  to convert the time strings in to numeric times.  The full set of camera
;  descriptors is then obtained by interpolating the numeric start and 
;  stop times.  We could also just give all the times, either as strings, or 
;  numerically.  Note that, because there is no data descriptor, the second 
;  call to PG_GET_CAMERAS creates one and returns it in the first argument:: 
;
;     cds = pg_get_cameras(instrument=instrument, time=times)
;     t_start = bod_time(cds[0])
;     t_stop = bod_time(cds[1])
;     
;     t = (dindgen(nt)/(nt-1) * (t_stop - t_start)) + t_start
;     cd = pg_get_cameras(dd, instrument=instrument, time=t)
;
;-
;-------------------------------------------------------------------------
cds = pg_get_cameras(instrument=instrument, time=times)
t_start = bod_time(cds[0])
t_stop = bod_time(cds[1])

t = (dindgen(nt)/(nt-1) * (t_stop - t_start)) + t_start
cd = pg_get_cameras(dd, instrument=instrument, time=t)


;-------------------------------------------------------------------------
;+
; SET CAMERA POINTING
;
;  If left alone, the camera pointing will be whatever was returned by the
;  translators.  Here we force the cameras to point at the center of Saturn
;  by inputting the S/C -- Saturn vectors to PG_REPOINT.  Note the use of 
;  the data descriptor created by PG_GET_CAMERAS:: 
;
;     pd0 = pg_get_planets(dd, od=cd, name='SATURN')
;     pg_repoint, cd=cd, bod_pos(pd0)-bod_pos(cd)
;
;-
;-------------------------------------------------------------------------
pd0 = pg_get_planets(dd, od=cd, name='SATURN')
pg_repoint, cd=cd, bod_pos(pd0)-bod_pos(cd)


;-------------------------------------------------------------------------
;+
; VIEW PREDICT SCENES WITH GRIM
;
;  We input the camera descriptors to GRIM, but let it compute all other
;  descriptors.  Planets are computed within 1 AU of the camera.  The 
;  initial view is set to encompass the rings:: 
;
;     grim, dd, cd=cd, order=1, /activate, plt_distmax=const_get('AU'), $
;            over=['center', $
;                  'limb:SATURN', $
;                  'terminator:SATURN', $
;                  'planet_grid:SATURN', $
;                  'ring'], frame='ring'
;
;-
;-------------------------------------------------------------------------
grim, dd, cd=cd, order=1, xsize=768, ysize=768, /activate, plt_distmax=const_get('AU'), $
       over=['center', $
             'limb:SATURN', $
             'terminator:SATURN', $
             'planet_grid:SATURN', $
             'ring'], frame='ring', /render_auto


stop, '=== Auto-example complete.  Use cut & paste to continue.'







;-------------------------------------------------------------------------
;+
; COMPUTE FOOTPRINTS
;
;  Here is some code to compute a footprint for the current camera
;  pointing and graft it into GRIM.  To compute additional footprints, use 
;  GRIM's navigate mode to change the pointing and then paste the lines
;  again:: 
;
;     grift, cd=cd, pd=pd, rd=rd
;     footprint_ptd = pg_footprint(cd=cd, bx=[pd,rd])
;     graft, footprint_ptd, tag='FP-'+strtrim(counter(),2)
;
;-
;-------------------------------------------------------------------------
grift, cd=cd, pd=pd, rd=rd
footprint_ptd = pg_footprint(cd=cd, bx=[pd,rd])
graft, footprint_ptd, tag='FP-'+strtrim(counter(),2), col=ctbrown()

