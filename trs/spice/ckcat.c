/******************************************************************************
* ckcat.c
*
* ckcat [output_file] [file1.bc file2.bc ...]
*
*******************************************************************************/
#include <stdlib.h>
#include <stdio.h>

#include <SpiceUsr.h>
#include "SpiceZfc.h"
#include "SpiceZmc.h"



/******************************************************************************
* usage
*
*
*******************************************************************************/
usage()
 {
  printf("Usage: ckcat [-append]\n");
  printf("             [output_file]\n");
  printf("             [file1.bc file2.bc ...]|[list_file.list]\n");
  exit(1);
 }
/******************************************************************************/



/******************************************************************************
* read_list
*
*
*******************************************************************************/
char **read_list(filename, np)
 char *filename;
 int *np;
 {
  FILE *fp;
  char **in_fnames, line[128];
  int i, n=0;

 /*-----------------------------------------------------------------*
  * open file
  *-----------------------------------------------------------------*/
  if((fp=fopen(filename, "r"))==NULL)
   {
    fprintf(stderr, "Unable to open list file %s.\n", filename);
    exit(1);
   }


 /*-----------------------------------------------------------------*
  * count lines
  *-----------------------------------------------------------------*/
  while(fscanf(fp, "%s", line) != EOF) n++;


 /*-----------------------------------------------------------------*
  * read filenames
  *-----------------------------------------------------------------*/
  in_fnames = (char **)malloc(n*sizeof(char *));

  rewind(fp);
  for(i=0; i<n; i++)
   {
    fscanf(fp, "%s", line);
    in_fnames[i] = (char *)malloc(strlen(line));
    strcpy(in_fnames[i], line);
   }


  *np = n;
  return(in_fnames);
 }
/******************************************************************************/



/******************************************************************************
* main
*
*
*******************************************************************************/
main(argc, argv)
 int argc;
 char *argv[];
 {
  register int i;
  int nfiles;
  char *out_fname, **in_fnames, *ref, *segid, *p, append=0;
  FILE *out_fp, *in_fp;
  SpiceInt out_handle, in_handle, recno=0, ic[6], inst, _ref;
  SpiceBoolean found, found_pav, av_flag;
  SpiceDouble sum[64], sclk[2], sclk0, cmat[3][3], quat[1][4], avel[1][3], 
              clkout, tol;


 /*========================*
  * get arguments
  *========================*/
  if(argc < 3) usage(); 

 /*--------------------------------*
  * -append
  *--------------------------------*/
  for(i=1; i<argc; i++) if(!strcmp(argv[i], "-append"))
   {
    for(; i<argc-1; i++) strcpy(argv[i], argv[i+1]);
    argc--;
    append = 1;
    break;
   } 

 /*--------------------------------*
  * filenames
  *--------------------------------*/
  out_fname = argv[1];
  in_fnames = argv + 2;
  nfiles = argc - 2;

  if(nfiles == 1)
   {
    if(strstr(in_fnames[0], ".list")) in_fnames = read_list(in_fnames[0], &nfiles);
    else if(!strstr(in_fnames[0], ".bc")) usage();
   }


 /*==============================================*
  * concatenate files
  *==============================================*/
  
 /*--------------------------------*
  * open output file
  *--------------------------------*/
  if(!append) ckopn_c(out_fname, "CK_file", 0, &out_handle);
  else cklpf_c(out_fname, &out_handle);

  
 /*--------------------------------*
  * process input files
  *--------------------------------*/
  for(i=0; i<nfiles; i++)
   {

   /*- - - - - - - - - - - - - - - - - - - - - -*
    * open the kernel
    *- - - - - - - - - - - - - - - - - - - - - -*/
    printf("Opening C-kernel %s...\n", in_fnames[i]);
    cklpf_c(in_fnames[i], &in_handle);
/*    furnsh_c(in_fnames[i]);*/

   /*- - - - - - - - - - - - - - - - - - - - - -*
    * copy each segment into output file
    *- - - - - - - - - - - - - - - - - - - - - -*/
    dafbfs_c(in_handle);
    daffna_c(&found);

    if(found)
     {
     /*- - - - - - - - - - - - - - - - - - - - - -*
      * get the segment descriptor
      *- - - - - - - - - - - - - - - - - - - - - -*/
      printf("Reading segment descriptor...\n");
      dafgs_c(sum);
      dafus_c(sum, (SpiceInt)2, (SpiceInt)6, sclk, ic);

     /*- - - - - - - - - - - - - - - - - - - - - -*
      * derive segment data
      *- - - - - - - - - - - - - - - - - - - - - -*/
      sclk0 = 0.5*(sclk[0] + sclk[1]);
      tol = 0.5*(sclk[1] - sclk[0]);

      inst = ic[0];
ref = "J2000";  /* I don't know how to convert the ref code into a */
                        /* ref string. */
      _ref = ic[1];
/*      ref = */
    
      av_flag = SPICETRUE;
      ckgpav_c(inst, sclk0, tol, ref, cmat, avel[0], &clkout, &found_pav);
      if(!found_pav)  
       {
        av_flag = SPICEFALSE;
        ckgp_c(inst, sclk0, tol, ref, cmat, &clkout, &found_pav);
       }


     /*- - - - - - - - - - - - - - - - - - - - - -*
      * write segment to output kernel
      *- - - - - - - - - - - - - - - - - - - - - -*/
      if(found_pav)
       {
        m2q_c(cmat, quat[0]);

         if((p=strrchr(in_fnames[i], '/')) == NULL) segid = in_fnames[i];
         else segid = p+1;

         printf("Writing segment descriptor to file %s...\n", out_fname);
         ckw01_c (out_handle,
/*              sclk[0],
              sclk[1],*/
              sclk0,
              sclk0,
              inst,
              ref,
              av_flag,
              segid,
              (SpiceInt)1,
              &sclk0,
              quat,
              avel);
       }

      daffna_c(&found);
     } 

    ckcls_c(in_handle);
/*    unload_c(in_fnames[i]);*/
   }



  
 /*--------------------------------*
  * close output file
  *--------------------------------*/
  ckcls_c(out_handle);


 }
/******************************************************************************/
