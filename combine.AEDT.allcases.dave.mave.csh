#! /bin/csh -f
#o " e.g. Usage: combine.csh base05b P1 20050101 2005001 1 01"
#    exit ()
#endif

setenv CDATE $1         # YYYYMMDD e.g. 20011215
setenv JDATE $2         # YYYYJJJ e.g. 2001349
setenv NDAYS $3         # e.g. 5 for 5 days
setenv CASE $4
setenv PERIOD $5
setenv SRUN $6
setenv MONTHNAME $7
setenv YYMM $8

setenv OUTDIR /netscr/lakshmi/$CASE/$PERIOD
setenv POSTDIR /nas01/depts/ie/cempd/FAA-AEDT/CMAQ/post/$CASE/$PERIOD
setenv METDATA /netscr/lakshmi/CONUS_WRF
setenv DIR /nas01/depts/ie/cempd/FAA-AEDT/utils/lakshmi/combine_m3tools

setenv IOBIN /nas01/depts/ie/cempd/apps/ioapi_30/071008/Linux2_x86pg_pgcc_nomp/

if ( ! -d $POSTDIR ) mkdir -p $POSTDIR

@ END_RUNDATE = $CDATE + $NDAYS - 1

while ( $CDATE <= $END_RUNDATE )
echo $CDATE
echo $END_RUNDATE
setenv AFILE  CCTM50_cb05tump_ifort_{$SRUN}


#################################################################
#       Step a: Create combined files
#################################################################

setenv INFILE1 $OUTDIR/$AFILE.ACONC.$CDATE
#setenv INFILE2 $OUTDIR/$AFILE.AEROVIS.$MONTHNAME
setenv INFILE2 $METDATA/$JDATE/METCRO3D_${JDATE}
#setenv INFILE4 $OUTDIR/$AFILE.AERODIAM.$MONTHNAME
#setenv INFILE5 $METDATA/$JDATE/METCRO2D_${JDATE}

setenv OUTFILE $POSTDIR/$AFILE.ACONC.$CDATE.combine
if (-e $OUTFILE) /bin/rm $OUTFILE

setenv SPECIES_DEF $DIR/spec_def.conc.AEDT
  
$DIR/combine.exe

#################################################################
#       Step b: Create daily  averages of all species
###################################################################
setenv INFILE $POSTDIR/$AFILE.ACONC.$CDATE.combine
setenv OUTFILE $POSTDIR/$AFILE.ACONC.$CDATE.combine.dave

echo $INFILE
echo $OUTFILE

if (-e $OUTFILE) /bin/rm $OUTFILE

setenv M3TPROC_ALLV T
setenv M3TPROC_TYPE 2

$IOBIN/m3tproc << eof



230000
240000

230000

eof

#########################################################################
#### step 3: create combined daily average file of all daily average files
##########################################################################
setenv INFILE $POSTDIR/$AFILE.ACONC.$CDATE.combine.dave
setenv OUTFILE $POSTDIR/$AFILE.ACONC.$YYMM.combine.dave

$IOBIN/m3xtract << EOF
          ! Input file
0               ! All Layers
-1               ! All variables 
                ! Starting date
                ! Starting time
240000          ! Duration
OUTFILE         ! Output file
EOF

echo $CDATE

@ CDATE = $CDATE + 1
@ JDATE = $JDATE + 1
end

##################################################################################
####### step 4: create monthly average of all species
##################################################################################

setenv INFILE  $POSTDIR/$AFILE.ACONC.$YYMM.combine.dave
setenv OUTFILE $POSTDIR/$AFILE.ACONC.$YYMM.combine.mave

if (-e $OUTFILE) /bin/rm $OUTFILE

@ NDAYS = $NDAYS - 1 
@ NHOURS = ${NDAYS} * 240000

setenv M3TPROC_ALLV T
setenv M3TPROC_TYPE 2
 
$IOBIN/m3tproc  << eof



$NHOURS




eof

