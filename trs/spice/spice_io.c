/******************************************************************************
* spice_io.c
*
*
*******************************************************************************/
#include <stdlib.h>
#include <stdio.h>
#include <float.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>

#include <SpiceUsr.h>
#include "SpiceZfc.h"
#include "SpiceZmc.h"

#include "mspice.h"



#define minas_fail(errno) \
 { \
   char msg[LENOUT];      \
   get_message(errno, msg);     \
   fprintf(stderr, "MINAS SPICE error: %s\n", msg);  \
   return(errno);      \
 }



#define MAXREC 1024



/******************************************************************************
* get_message
*
*
*******************************************************************************/
int get_message(errno, msg)
 int errno;
 char *msg;
 {

  switch(errno)
   {
    case E_TMPNAM : sprintf(msg, "Unable to generate temporary filename.");
      break;
    case E_OPNKFILE : sprintf(msg, "Unable to open temporary file %s.", err_st);
        break;
    case E_OPNKLIST : sprintf(msg, "Unable to open kernel list file %s.",
                                                                      err_st);
        break;
    case E_GETENV : sprintf(msg, "Undefined variable %s.", err_st);
      break;
    case E_UNLOAD : sprintf(msg, "Can't unload kernel list file %s.", err_st);
      break;
    case E_LOAD : sprintf(msg, "Can't load kernel list file %s.", err_st);
    break;

   }

  return(0);
 }
/******************************************************************************/



/******************************************************************************
* package_output_string
*
*
*******************************************************************************/
static void package_output_string(names, name_s, n)
 SpiceChar names[NKVAR][NAMELEN], name_s[NAMELEN];
 SpiceInt n;
 {
  register int i; 
  static SpiceChar s[NAMELEN];

  sprintf(name_s, "%s", names[0]);
  for(i=1; i<n; i++) 
   {
    if(strlen(names[i]) == 0) strcpy(s, "X");
    else strcpy(s, names[i]);
    sprintf(name_s, "%s;%s", name_s, s);
   }

 }
/******************************************************************************/



/******************************************************************************
* spice_unload
*
*
*******************************************************************************/
int spice_unload(kernels, n_kernels)
 IDL_STRING *kernels;
 SpiceInt n_kernels;
 {
  register int i;

  for(i=0; i<n_kernels; i++) unload_c(kernels[i].s);

  return(0);
 }
/******************************************************************************/



/******************************************************************************
* spice_load
*
*
*******************************************************************************/
int spice_load(kernels, n_kernels)
 IDL_STRING *kernels;
 SpiceInt n_kernels;
 {
  register int i;

  for(i=0; i<n_kernels; i++) furnsh_c(kernels[i].s);

  return(0);
 }
/******************************************************************************/



/******************************************************************************
* get_all_target_names
*
*
*******************************************************************************/
int get_all_target_names(names, n_p)
 SpiceChar names[NKVAR][NAMELEN];
 SpiceInt *n_p;
 {
  int status=0, i, j, l, errno;
  SpiceBoolean found;
  SpiceInt n, id;
  static SpiceChar id_s[NAMELEN], kvars[NKVAR][NAMELEN];
  const SpiceChar *template = "BODY*_RADII";
/*  const SpiceChar *template = "BODY*_*";*/


 /*-------------------------------------*
  * find all bodies
  *-------------------------------------*/
  gnpool_c(template, (SpiceInt)0, (SpiceInt)NKVAR, (SpiceInt)NAMELEN,
            &n, kvars, &found);
/*for(i=0; i<n; i++) printf("kvars[i]=%s\n", kvars[i]);*/


 /*------------------------------------------*
  * extract ids and convert to name strings
  *------------------------------------------*/
  for(i=0; i<n; i++)
   {
    strcpy(id_s, kvars[i]+4);

    for(j=0; (id_s[j]!='\0') && id_s[j]!='_'; j++);
    id_s[j] = '\0';
    id = atoi(id_s);
/*printf("%s %s %d\n", kvars[i], id_s, id);*/

    bodc2n_c(id, (SpiceInt)NAMELEN, names[i], &found);
   }
/*for(i=0; i<n; i++) printf("names[i]=%s\n", names[i]);*/


  *n_p = n;
  return(status);
 }
/******************************************************************************/



/******************************************************************************
* get_loaded
*
*  Returns only kernels loaded using furnsh_c. 
*
*******************************************************************************/
int get_loaded(argc, argv)
 int argc;
 char *argv[];
 {
  int nn=0;
  char *file_s = (char *)argv[nn++];

  static SpiceInt nk, handle;
  static SpiceBoolean found;
  register int i;
  static SpiceChar file[NAMELEN], type[NAMELEN], source[NAMELEN],
                   files[NKVAR][NAMELEN], *kind = "SPK CK PCK EK TEXT";


 /*---------------------------------------------*
  * get list of files loaded using furnsh_c
  *---------------------------------------------*/
  ktotal_c(kind, &nk);
  for(i=0; i<nk; i++) 
   {
    kdata_c(i, kind, (SpiceInt)NAMELEN, (SpiceInt)NAMELEN, (SpiceInt)NAMELEN, 
                                    file, type, source, &handle, &found);
    strcpy(files[i], file);
   }


 /*-------------------------------------*
  * fill output string
  *-------------------------------------*/
  package_output_string(files, file_s, nk);


  return(0);
 }
/******************************************************************************/



/******************************************************************************
* clear
*
*
*******************************************************************************/
int clear(argc, argv)
 int argc;
 char *argv[];
 {


 /*-------------------------------------*
  * clear kernel pool
  *-------------------------------------*/
  clpool_c();


  return(0);
 }
/******************************************************************************/



/******************************************************************************
* unload_kernels
*
*
*******************************************************************************/
int unload_kernels(argc, argv)
 int argc;
 char *argv[];
 {
  int nn=0;
  IDL_STRING *kernels = (IDL_STRING *)argv[nn++];
  SpiceInt n_kernels = *(long *)argv[nn++];

  int errno;


 /*-------------------------------------*
  * unload kernels
  *-------------------------------------*/
  if(errno = spice_unload(kernels, n_kernels)) minas_fail(errno);


  return(0);
 }
/******************************************************************************/



/******************************************************************************
* load_kernels
*
*
*******************************************************************************/
int load_kernels(argc, argv)
 int argc;
 char *argv[];
 {
  int nn=0;
  IDL_STRING *kernels = (IDL_STRING *)argv[nn++];
  SpiceInt n_kernels = *(long *)argv[nn++];

  int errno;


 /*-------------------------------------*
  * load kernels
  *-------------------------------------*/
  if(errno = spice_load(kernels, n_kernels)) minas_fail(errno);


  return(0);
 }
/******************************************************************************/



/******************************************************************************
* __unitim
*
*
*******************************************************************************/
int __unitim(argc, argv)
 int argc;
 char *argv[];
 {
  int nn=0;
  SpiceDouble t = *(SpiceDouble *)argv[nn++];
  SpiceChar *insys = (char *)argv[nn++];
  SpiceChar *outsys = (char *)argv[nn++];
  SpiceDouble *time_p = (SpiceDouble *)argv[nn++];

static   SpiceDouble time;

  time = unitim_c(t, insys, outsys);

  *time_p = time;
  return(0);
 }
/******************************************************************************/



/******************************************************************************
* __str2et
*
*
*******************************************************************************/
int __str2et(argc, argv)
 int argc;
 char *argv[];
 {
  int nn=0;
  SpiceChar *time = (char *)argv[nn++];
  SpiceDouble *et_p = (SpiceDouble *)argv[nn++];

  static SpiceDouble et;

 /*-------------------------------------*
  * get ephemeris time
  *-------------------------------------*/
  reset_c();
  str2et_c(time, &et);

  *et_p = et;
  return(0);
 }
/******************************************************************************/



/******************************************************************************
* __sct2et
*
*
*******************************************************************************/
int __sct2et(argc, argv)
 int argc;
 char *argv[];
 {
  int nn=0;
  SpiceChar *time = (char *)argv[nn++];
  SpiceDouble *et_p = (SpiceDouble *)argv[nn++];
  SpiceInt sc = *(long *)argv[nn++];

  static SpiceDouble et;
  static SpiceDouble sclkdp;


  scencd_c(sc, time, &sclkdp); 
  sct2e_c(sc, sclkdp, &et);

  *et_p = et;
  return(0);
 }
/******************************************************************************/



/******************************************************************************
* __et2utc
*
*
*******************************************************************************/
int __et2utc(argc, argv)
 int argc;
 char *argv[];
 {
  int nn=0;
  SpiceDouble et = *(SpiceDouble *)argv[nn++];
  SpiceChar *format = (char *)argv[nn++];
  SpiceChar *s = (char *)argv[nn++];

  SpiceInt prec = 2;


  et2utc_c(et, format, prec, (SpiceInt)128, s);


  return(0);
 }
/******************************************************************************/



/******************************************************************************
* get_naif_id
*
*
*******************************************************************************/
int get_naif_id(argc, argv)
 int argc;
 char *argv[];
 {
  int nn=0;
  SpiceChar *name = (char *)argv[nn++];
  SpiceInt *id = (SpiceInt *)argv[nn++];

  static SpiceBoolean found;

  bodn2c_c(name, id, &found);
  if(!found) return(-1);


  return(0);
 }
/******************************************************************************/



/******************************************************************************
* daf_get_comment
*
*
*******************************************************************************/
int daf_get_comment(argc, argv)
 int argc;
 char *argv[];
 {
  int nn=0;
  SpiceChar *fname = (char *)argv[nn++]; 
  SpiceChar *comment = (char *)argv[nn++]; 
  SpiceInt ncom = *(long *)argv[nn++];

  SpiceInt handle;
  char *tmp_fname, c;
  FILE *fp;
  integer unit;
  register int i;


 /*- - - - - - - - - - - - - - - - - - - - - - -*
  * read comment into a temp file.
  *- - - - - - - - - - - - - - - - - - - - - - -*/
  tmp_fname = tmpnam((char *)NULL);
  dafopr_c(fname, &handle);

  txtopn_(tmp_fname, &unit, (ftnlen)strlen(tmp_fname));
  spcec_((integer *)&handle, (integer *)&unit);

  ftncls_c(unit);
  dafcls_c(handle);


 /*- - - - - - - - - - - - - - - - - - - - - - -*
  * read temp file into output array.
  *- - - - - - - - - - - - - - - - - - - - - - -*/
  if(fp=fopen(tmp_fname, "r") == NULL) return(0);

  for(i=0; i<ncom; i++) 
   {
    c = fgetc(fp);
    if(c == EOF) break;
    comment[i] = c;
   }
  comment[i] = '\0';

  fclose(fp);


  return(0);
 }
/******************************************************************************/



/******************************************************************************
* spice_match
*
*
*******************************************************************************/
int spice_match(list, item, n)
 SpiceChar list[NKVAR][NAMELEN], item[NAMELEN];
 int n;
 {
  register int i;

  for(i=0; i<n; i++) if(!strcmp(list[i], item)) return(1);

  return(0);
 }
/******************************************************************************/



/******************************************************************************
* get_cameras
*
*
*******************************************************************************/
int get_cameras(argc, argv)
 int argc;
 char *argv[];
 {
  int nn=0;
  SpiceInt sc = *(long *)argv[nn++];
  SpiceInt inst = *(long *)argv[nn++];
  SpiceInt plat = *(long *)argv[nn++];
  SpiceChar *ref = (char *)argv[nn++]; 
  SpiceDouble et = *(SpiceDouble *)argv[nn++];
  SpiceDouble tol = *(SpiceDouble *)argv[nn++];

  SpiceDouble *pos = (SpiceDouble *)argv[nn++];
  SpiceDouble *vel = (SpiceDouble *)argv[nn++];
  SpiceDouble *cmat_out = (SpiceDouble *)argv[nn++];
  SpiceDouble *avel = (SpiceDouble *)argv[nn++];
  IDL_STRING *kernels = (IDL_STRING *)argv[nn++];
  SpiceInt n_kernels = *(long *)argv[nn++];
  IDL_STRING *unload_kernels = (IDL_STRING *)argv[nn++];
  SpiceInt n_unload_kernels = *(long *)argv[nn++];
  SpiceInt pos_only = *(long *)argv[nn++];

  static SpiceDouble sc_state[6], sclk, clkout;
  SpiceBoolean found;

  int status=0, i,j, errno;
  static SpiceDouble cmat[3][3], pmat[3][3], M1[3][3], M2[3][3], M3[3][3],
                    _avel[3];


 /*----------------------------------------*
  * set to return on error instead of halt
  *----------------------------------------*/
  errprt_c("SET", 0, "NONE");
  erract_c("SET", 0, "RETURN");

 /*------------------------------------------------------*
  * spacecraft position and velocity w.r.t. SS barycenter
  *------------------------------------------------------*/
  reset_c();
  spkssb_c(sc, et, ref, sc_state);
  if(failed_c()) spice_fail(-1);
/*printf("0\n");*/

  memcpy((char *)pos, (char *)sc_state, 3*sizeof(SpiceDouble));
  memcpy((char *)vel, (char *)(sc_state+3), 3*sizeof(SpiceDouble));

 /*--------------------------------------------------------*
  * Get C-matrix
  *
  *  If a platform id is given, get its orientation matrix
  *  and then rotate to find C-matrix
  *
  *--------------------------------------------------------*/
  if(pos_only) return(status);

  sce2c_c(sc, et, &sclk);
  if(!plat) 
   {
    reset_c();
    ckgpav_c(inst, sclk, tol, ref, cmat, avel, &clkout, &found);
    if(!found)  
     {
      ckgp_c(inst, sclk, tol, ref, cmat, &clkout, &found);
      if(!found) return(-1);
      fprintf(stderr, 
   "WARNING -- no angular velocity data avaliable; returning pointing only.\n");
     }
    if(failed_c()) spice_fail(-1);
   }
  else
   {
    reset_c();
    ckgpav_c(plat, sclk, tol, ref, pmat, _avel, &clkout, &found);
    memcpy((char *)(avel), (char *)_avel, 3*sizeof(SpiceDouble));
    if(!found)  
     {
      ckgp_c(plat, sclk, tol, ref, pmat, &clkout, &found);
      if(!found) return(-1);
      fprintf(stderr, 
   "WARNING -- no angular velocity data avaliable; returning pointing only.\n");
     }
    if(failed_c()) spice_fail(-1);

    tkfram_((integer *)&inst, 
                     (doublereal *)M1, (integer *)&plat, (logical *)&found);

    rotate_c(M_PI, 3, M2);
    mxm_c(M2,M1, M3);
    mxm_c(M3, pmat, cmat);

    /*
    printf("%f10 %f10 %f10\n", M1[0][0], M1[0][1], M1[0][2]);
    printf("%f10 %f10 %f10\n", M1[1][0], M1[1][1], M1[1][2]);
    printf("%f10 %f10 %f10\n", M1[2][0], M1[2][1], M1[2][2]);
    */

    /*
    printf("%f10 %f10 %f10\n", M3[0][0], M3[0][1], M3[0][2]);
    printf("%f10 %f10 %f10\n", M3[1][0], M3[1][1], M3[1][2]);
    printf("%f10 %f10 %f10\n", M3[2][0], M3[2][1], M3[2][2]);
    */

    /*
    printf("%f10 %f10 %f10\n", pmat[0][0], pmat[0][1], pmat[0][2]);
    printf("%f10 %f10 %f10\n", pmat[1][0], pmat[1][1], pmat[1][2]);
    printf("%f10 %f10 %f10\n", pmat[2][0], pmat[2][1], pmat[2][2]);
    */

    /*
    printf("%f10 %f10 %f10\n", cmat[0][0], cmat[0][1], cmat[0][2]);
    printf("%f10 %f10 %f10\n", cmat[1][0], cmat[1][1], cmat[1][2]);
    printf("%f10 %f10 %f10\n", cmat[2][0], cmat[2][1], cmat[2][2]);
    */
   }

  memcpy((char *)cmat_out, (char *)cmat, 9*sizeof(SpiceDouble));


  return(status);
 }
/******************************************************************************/




/******************************************************************************
* get_planets
*
*
*******************************************************************************/
int get_planets(argc, argv)
 int argc;
 char *argv[];
 {
  int nn = 0;
  SpiceInt n = *(long *)argv[nn++];
  IDL_STRING *idl_names = (IDL_STRING *)argv[nn++];
  SpiceChar *ref = (char *)argv[nn++]; 
  SpiceDouble et = *(SpiceDouble *)argv[nn++];
  IDL_STRING *targets = (IDL_STRING *)argv[nn++]; 
  SpiceInt n_targets = *(long *)argv[nn++];

  SpiceDouble *pos = (SpiceDouble *)argv[nn++];
  SpiceDouble *vel = (SpiceDouble *)argv[nn++];
  SpiceDouble *avel = (SpiceDouble *)argv[nn++];
  SpiceDouble *orient = (SpiceDouble *)argv[nn++];
  SpiceDouble *radii = (SpiceDouble *)argv[nn++];
  SpiceDouble *lora = (SpiceDouble *)argv[nn++];
  SpiceDouble *gm = (SpiceDouble *)argv[nn++];
  SpiceDouble *jcoef = (SpiceDouble *)argv[nn++];
  SpiceInt *found = (SpiceInt *)argv[nn++];
  SpiceInt *ids = (SpiceInt *)argv[nn++];
  char *name_s = (char *)argv[nn++];
  IDL_STRING *kernels = (IDL_STRING *)argv[nn++];
  SpiceInt n_kernels = *(long *)argv[nn++];
  IDL_STRING *unload_kernels = (IDL_STRING *)argv[nn++];
  SpiceInt n_unload_kernels = *(long *)argv[nn++];


  int i, ii, j, jj, errno; 
  static SpiceChar *name, names[NKVAR][NAMELEN], 
                   all_names[NKVAR][NAMELEN], s[NAMELEN];
  static SpiceDouble targ_state[6], sclk, clkout, lt, memat[3][3];
    
  SpiceInt id, dim;
  SpiceBoolean name_found;
  static SpiceDouble pole_ra[16], pole_dec[16], pm[16], 
                    _avel[3], _radii[3], w, _lora[1], _gm[1], _jcoef[10];
  char numeric_name, pos_only;
  SpiceInt nall;
  static SpiceChar corr[8], *target;


 /*--------------------------------------------------------------------*
  * set to return on error and turn off reporting because we're going
  * to attempt to find more planets than may be in the pool.
  *--------------------------------------------------------------------*/
  errprt_c("SET", 0, "NONE");
  erract_c("SET", 0, "RETURN");


 /*----------------------------------------------------------------------*
  * get object names
  *  If no names are requested, then only bodies with known radii are
  *  returned.
  *----------------------------------------------------------------------*/
  reset_c();
  if(n == 0) {get_all_target_names(names, &n);}
  else 
   {
    get_all_target_names(all_names, &nall);
    for(i=0; i<n; i++) strcpy(names[i], idl_names[i].s);
   }


 /*-------------------------------------------------------*
  * get ephem for each specified object
  *-------------------------------------------------------*/
  memset(found, (char)0, n*sizeof(SpiceInt));
  memset(ids, (char)0, n*sizeof(SpiceInt));
  for(i=0; i<n; i++) if(strlen(names[i]) != 0)
   {
   /*- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -*
    * convert names into ids
    *  If names starts with '!', then only position is requested.
    *  If name is entirely numeric, then treat as naif id.
    *- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -*/
    name = names[i];

    pos_only = 0;
    if(name[0] == '!')
     {
      name++;
      pos_only = 1;
     }

    numeric_name = 1;
    for(j=0; j<strlen(name); j++) 
                     if(!isdigit(name[j])) numeric_name = 0;
    if(numeric_name) 
     {
      id = (SpiceInt)atoi(name);
      name_found = (SpiceBoolean)SPICETRUE;
     }
    else
     {
      reset_c();
      bodn2c_c(name, &id, &name_found);
     }

/*if(id > 1000) name_found = (SpiceBoolean)SPICEFALSE;*/
    if(name_found == SPICETRUE)
     {
     /*- - - - - - - - - - - - - - - - - - - - - -*
      * get body state w.r.t. SS barycenter
      *- - - - - - - - - - - - - - - - - - - - - -*/
      reset_c();

/*      strcpy(corr, "NONE");*/
      spkezr_c(name, et, ref, "NONE", "SSB", targ_state, &lt);
/*      spkezr_c(name, et, ref, "LT+S", "SSB", targ_state, &lt);*/

      if(!failed_c()) 
       {
        reset_c();
        if(!failed_c())
         {
          found[i] = 1;
          ids[i] = id;

          memcpy((char *)(pos+i*3), (char *)targ_state, 3*sizeof(SpiceDouble));
          memcpy((char *)(vel+i*3), (char *)(targ_state+3), 
                                                       3*sizeof(SpiceDouble));

         if(!pos_only)
          {
           /*- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -*
            * get body orientation matrix --
            *  Note that this routine does not have a cspice wrapper so 
            *  we call the f2c'd routine directly.  
            *- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -*/
            bodmat_((integer *)&id, (doublereal *)&et, (doublereal *)memat);

            memcpy((char *)(orient+i*9), (char *)memat, 9*sizeof(SpiceDouble));

           /*- - - - - - - - - - - - - - - - - - - -*
            * get body constants
            *- - - - - - - - - - - - - - - - - - - -*/
            memset((char *)_radii, 0, 3*sizeof(SpiceDouble));
            memset((char *)_lora, 0, 3*sizeof(SpiceDouble));
            bodvar_c(id, "RADII", &dim, _radii);
            bodvar_c(id, "LONG_AXIS", &dim, _lora);
            bodvar_c(id, "GM", &dim, _gm);
            bodvar_c(id, "JCOEF", &dim, _jcoef);

            memcpy((char *)(radii+i*3), (char *)_radii, 3*sizeof(SpiceDouble));
            memcpy((char *)(lora+i), (char *)_lora, sizeof(SpiceDouble));
            memcpy((char *)(gm+i), (char *)_gm, sizeof(SpiceDouble));
            memcpy((char *)(jcoef+i*10), (char *)_jcoef, 10*sizeof(SpiceDouble));

           /*- - - - - - - - - - - - - - - - - - - - - - - - - - - -*
            * angular velocity
            * NOTE: precession angular velocities not included
            *  See pck.req to interpret ra/dec rates in pck.
            *  36525 days in julian century
            * However, the returned orientation matrix comes from the 
            *  ME matrix, which does account for precession.
            *- - - - - - - - - - - - - - - - - - - - - - - - - - - -*/
            bodvar_c(id, "POLE_RA", &dim, pole_ra);
            pole_ra[0] *= M_PI/180.;	
            bodvar_c(id, "POLE_DEC", &dim, pole_dec);
            pole_dec[0] *= M_PI/180.;
            bodvar_c(id, "PM", &dim, pm);
/* pole_ra/dec[0] not used; need to convert pole_ra/dec[1] to precession 
   vector */

            w = 0;
            if(dim > 1) w = pm[1] / 86400. * M_PI/180.; 

            _avel[0] = w * orient[2+i*9];
            _avel[1] = w * orient[5+i*9];
            _avel[2] = w * orient[8+i*9];

 /*           _avel[0] = w * memat[0][2];
            _avel[1] = w * memat[1][2];
            _avel[2] = w * memat[2][2];*/

            memcpy((char *)(avel+i*3), (char *)_avel, 3*sizeof(SpiceDouble));
          }
         }
       }

     }

   }


 /*-------------------------------------------------------*
  * copy names into output array
  *-------------------------------------------------------*/
  package_output_string(names, name_s, n);



  return(0);
 }
/******************************************************************************/



/******************************************************************************
* put_cameras
*
* writes a type 1 C-kernel segment
*
*******************************************************************************/
int put_cameras(argc, argv)
 int argc;
 char *argv[];
 {
  int nn = 0;
  SpiceInt sc = *(long *)argv[nn++];
  SpiceInt inst = *(long *)argv[nn++];
  SpiceInt plat = *(long *)argv[nn++];
  SpiceChar *ref = (char *)argv[nn++]; 
  SpiceChar *fname = (char *)argv[nn++]; 
  SpiceChar *comment = (char *)argv[nn++]; 

  SpiceDouble et = *(SpiceDouble *)argv[nn++];
  SpiceDouble exp = *(SpiceDouble *)argv[nn++];
  SpiceDouble *pos = (SpiceDouble *)argv[nn++];
  SpiceDouble *vel = (SpiceDouble *)argv[nn++];
  SpiceDouble *_cmat = (SpiceDouble *)argv[nn++];
  SpiceDouble *_avel = (SpiceDouble *)argv[nn++];

  register int i;
  int status=0, errno;
  SpiceInt handle;
  SpiceDouble sclk[2], sclk0, sclk1, quat[2][4],
              pmat[3][3], cmat[3][3], avel[2][3],
              M1[3][3], M2[3][3], M3[3][3], 
              t0, t1, tmin, tmax;
  SpiceBoolean found;
  SpiceChar segid[128];
  char *tmp_fname;
  FILE *fp;
  integer unit;


 /*-------------------------------------*
  * open new kernel file
  *-------------------------------------*/
  reset_c(); 
  ckopn_c(fname, fname, 0, &handle);
  if(failed_c()) spice_fail(-1);

 /*-------------------------------------*
  * get continuous spacecraft times
  *-------------------------------------*/
  tmin = et - exp/2.;
  tmax = et + exp/2.;
  sce2c_c(sc, tmin, &sclk0);
  sce2c_c(sc, tmax, &sclk1);
  sclk0 = sclk0 - 1;
  sclk1 = sclk1 + 1;
  sclk[0] = sclk0;
  sclk[1] = sclk1;

 /*-------------------------------------*
  * store C-matrices
  *-------------------------------------*/
  memcpy((char *)cmat, (char *)_cmat, 9*sizeof(SpiceDouble));
/*avel[0][0] = _avel[0];
avel[0][1] = _avel[1];
avel[0][2] = _avel[2];*/
  memcpy((char *)avel[0], (char *)_avel, 3*sizeof(SpiceDouble));
  memcpy((char *)avel[1], (char *)_avel, 3*sizeof(SpiceDouble));
/*printf("%f %f %f\n", _avel[0], _avel[1], _avel[2]);
printf("%f %f %f\n", avel[0][0], avel[0][1], avel[0][2]);*/

 /*--------------------------------------------*
  * segid is filename without path
  *--------------------------------------------*/
  for(i=strlen(fname)-1; i>=0; i--) if(fname[i] == '/') break;
  strcpy(segid, fname+i+1);

 /*-------------------------------------*
  * write type-3 c kernel
  *-------------------------------------*/
  if(!plat)
   {
    m2q_c(cmat, quat[0]);   /* C-matrix -> quaternion */
    memcpy((SpiceDouble *)quat[1], (SpiceDouble *)quat[0], 4*sizeof(SpiceDouble));
    ckw03_c(handle,
           sclk0,
           sclk1,
           inst,
           ref,
           SPICETRUE,  
           segid, 
           (SpiceInt)2,
           sclk,
           quat,
           avel, 
           (SpiceInt)1,
           &sclk0  
	);
   }
  else
   {
    tkfram_((integer *)&inst, 
                     (doublereal *)M1, (integer *)&plat, (logical *)&found);
    rotate_c(M_PI, 3, M2);
    mxm_c(M2,M1, M3);
    xpose_c(M3, M3);

    mxm_c(M3, cmat, pmat);
    m2q_c(pmat, quat[0]);  /* convert P-matrix to quaternion */
    memcpy((SpiceDouble *)quat[1], (SpiceDouble *)quat[0], 4*sizeof(SpiceDouble));

    ckw03_c(handle,
           sclk0,
           sclk1,
           plat,
           ref,
           SPICETRUE, 
           segid, 
           (SpiceInt)2,
           sclk,
           quat,
           avel, 
           (SpiceInt)1,
           &sclk0 
	);
   }


 /*-------------------------------------*
  * add comment if given
  *-------------------------------------*/
  if(strlen(comment) > 1)
   {
    /*- - - - - - - - - - - - - - - - - - - - - - -*
     * first write the comment to a temp file
     *- - - - - - - - - - - - - - - - - - - - - - -*/
     tmp_fname = tmpnam((char *)NULL);
     fp = fopen(tmp_fname, "w");
     fprintf(fp, "%s\n", comment);
     fclose(fp);

    /*- - - - - - - - - - - - - - - - - - - - - - -*
     * open temp file and insert in ck file
     *- - - - - - - - - - - - - - - - - - - - - - -*/
     txtopr_(tmp_fname, &unit, (ftnlen)strlen(tmp_fname));
     spcac_((integer *)&handle, (integer *)&unit, 
                                       " ", " ", (ftnlen)1, (ftnlen)1);
     ftncls_c(unit);
   }


 /*-------------------------------------*
  * close ck file
  *-------------------------------------*/
  ckcls_c(handle);


  return(status);
 }
/******************************************************************************/


