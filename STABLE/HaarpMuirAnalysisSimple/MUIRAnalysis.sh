#!/bin/bash

# MUIRAnalysis.sh
# 
#
# Created by jetmac on 8/15/08.
# Copyright 2008 __MyCompanyName__. All rights reserved.
# Copied from batch_movie.sh from ARSC Spring Training 2008
# Courtsy of Chris Fallen 


#PBS -q standard
#PBS -l select=1:ncpus=2:node_type=4way
#PBS -l walltime=01:00:00
#PBS -N MAG_MOVIE
#PBS -joe

# See http://www.arsc.edu/support/howtos/usingsun.html for more
# information on using the PBS queue on Midnight

# Another resource is the ARSC HPC User's Newsletter at
# http://www.arsc.edu/support/news/HPCnews.shtml

# Much of code and comments below has been copied directly
# from "Matlab functions on the command line" by Don Bahls in issue
# 381 found at
# http://www.arsc.edu/support/news/HPCnews/HPCnews381.shtml


# The Matlab avi functions leave large files in /tmp, which is
# on the small / partition.  Before running Matlab
# to create avi files on ARSC systems, set TMP to the scratch
# directory to override this default Matlab behavior

#export TMP=/scratch


# on midnight, uncomment the next three lines of code to load the
# matlab module change to the directory where this script was
# submitted.

# . /usr/share/modules/init/bash
# module load matlab-7.4.0
# cd $PBS_O_WORKDIR


# start matlab in the background passing it a here-document
# with the parameters for this processor. 

matlab -nodisplay << EOF >> matlab_MUIRAnalysis.log 2>&1 & 
	% This text to the "E0F" marker below will be executed by Matlab
	GeneralParameterDirectoryChar = '/Users/jet/Work/PARS2008/Data/SRIRx/Fallen-Watkins_expt1/20080728.006'
	SelFileNums1 = [26:28];
	MUIRAnalysis(GeneralParameterDirectoryChar, SelFileNums1)

	EOF

# start matlab in the background passing it a here-document
# with the parameters for this processor.
 
matlab -nodisplay << EOF >> matlab_MUIRAnalysis.log 2>&1 & 
	% This text to the "E0F" marker below will be executed by Matlab
	GeneralParameterDirectoryChar = '/Users/jet/Work/PARS2008/Data/SRIRx/Fallen-Watkins_expt1/20080728.006'
	SelNums2 = [29:30];
	MUIRAnalysis(GeneralParameterDirectoryChar, SelFileNums2)

	EOF

# issue the "wait" command so that the shell will pause until
# all the background processes have completed.
wait



