#! /bin/csh -f
#o " e.g. Usage: combine.csh base05b P1 20050101 2005001 1 01"
#    exit ()
#endif

setenv CDATE 20050101   # $1         # YYYYMMDD e.g. 20011215
setenv JDATE $1         # YYYYJJJ e.g. 2001349
setenv NDAYS 6          # $3         # e.g. 5 for 5 days
setenv CASE DDM_99_ #
setenv PERIOD NULL      # $5
setenv SRUN NULL        # $6
setenv MONTHNAME NULL   # $7
setenv YYMM NULL        # $8

setenv OUTDIR /nas01/depts/ie/cempd/FAA-DDM/cmaq/ddm_v4/data/cctm/ # /$PERIOD
setenv POSTDIR /nas01/depts/ie/cempd/FAA-DDM/cmaq/ddm_v4/data/cctm/ # /$PERIOD
setenv METDATA /netscr/lakshmi/CONUS_WRF
setenv DIR /nas01/depts/ie/cempd/FAA-DDM/cmaq/combine

setenv IOBIN /nas01/depts/ie/cempd/FAA-DDM/cmaq/netcdf3_highlim/ioapi/Linux2_x86_64pg_pgcc_nomp

if ( ! -d $POSTDIR ) mkdir -p $POSTDIR

@ END_RUNDATE = $JDATE + $NDAYS - 1

while ( $JDATE <= $END_RUNDATE )
echo $JDATE
echo $END_RUNDATE
setenv AFILE  CCTM_ddm_3.x_Linux2_x86_64pgi


#################################################################
#       Step a: Create combined files
#################################################################


setenv INFILE1  ${OUTDIR}DDM_99_1/$AFILE.DDM_99_1.ASENS.$JDATE.combine.ncf
setenv INFILE2  ${OUTDIR}DDM_99_2/$AFILE.DDM_99_2.ASENS.$JDATE.combine.ncf
setenv INFILE3  ${OUTDIR}DDM_99_3/$AFILE.DDM_99_3.ASENS.$JDATE.combine.ncf
setenv INFILE4  ${OUTDIR}DDM_99_4/$AFILE.DDM_99_4.ASENS.$JDATE.combine.ncf
setenv INFILE5  ${OUTDIR}DDM_99_5/$AFILE.DDM_99_5.ASENS.$JDATE.combine.ncf
setenv INFILE6  ${OUTDIR}DDM_99_6/$AFILE.DDM_99_6.ASENS.$JDATE.combine.ncf
setenv INFILE7  ${OUTDIR}DDM_99_7/$AFILE.DDM_99_7.ASENS.$JDATE.combine.ncf
setenv INFILE8  ${OUTDIR}DDM_99_8/$AFILE.DDM_99_8.ASENS.$JDATE.combine.ncf
setenv INFILE9  ${OUTDIR}DDM_99_9/$AFILE.DDM_99_9.ASENS.$JDATE.combine.ncf
setenv INFILE10 ${OUTDIR}DDM_99_10/$AFILE.DDM_99_10.ASENS.$JDATE.combine.ncf
setenv INFILE11 ${OUTDIR}DDM_99_11/$AFILE.DDM_99_11.ASENS.$JDATE.combine.ncf
setenv INFILE12 ${OUTDIR}DDM_99_12/$AFILE.DDM_99_12.ASENS.$JDATE.combine.ncf
setenv INFILE13 ${OUTDIR}DDM_99_13/$AFILE.DDM_99_13.ASENS.$JDATE.combine.ncf

setenv OUTFILE $POSTDIR/$AFILE.DDM_ALL.ASENS.$JDATE.combine.ncf
if (-e $OUTFILE) /bin/rm $OUTFILE

setenv SPECIES_DEF $DIR/species_def_allapts.conc
  
$DIR/combine.exe

#################################################################
#       Step b: Create daily  averages of all species
###################################################################
#setenv INFILE $POSTDIR/$AFILE.ACONC.$CDATE.combine
#setenv OUTFILE $POSTDIR/$AFILE.ACONC.$CDATE.combine.dave
#
#echo $INFILE
#echo $OUTFILE
#
#if (-e $OUTFILE) /bin/rm $OUTFILE
#
#setenv M3TPROC_ALLV T
#setenv M3TPROC_TYPE 2
#
#$IOBIN/m3tproc << eof
#
#
#
#230000
#240000
#
#230000
#
#eof

#########################################################################
#### step 3: create combined daily average file of all daily average files
##########################################################################
#setenv INFILE $POSTDIR/$AFILE.ACONC.$CDATE.combine.dave
#setenv OUTFILE $POSTDIR/$AFILE.ACONC.$YYMM.combine.dave
#
#$IOBIN/m3xtract << EOF
#          ! Input file
#0               ! All Layers
#-1               ! All variables 
#                ! Starting date
#                ! Starting time
#240000          ! Duration
#OUTFILE         ! Output file
#EOF
#
#echo $CDATE
#
#@ CDATE = $CDATE + 1
#@ JDATE = $JDATE + 1
#end
#
##################################################################################
####### step 4: create monthly average of all species
##################################################################################
#
#setenv INFILE  $POSTDIR/$AFILE.ACONC.$YYMM.combine.dave
#setenv OUTFILE $POSTDIR/$AFILE.ACONC.$YYMM.combine.mave
#
#if (-e $OUTFILE) /bin/rm $OUTFILE
#
#@ NDAYS = $NDAYS - 1 
#@ NHOURS = ${NDAYS} * 240000
#
#setenv M3TPROC_ALLV T
#setenv M3TPROC_TYPE 2
# 
#$IOBIN/m3tproc  << eof
#
#
#
#$NHOURS
#
#
#
#
#eof
#
