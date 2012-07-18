#Aqueduct - Compliance Remediation Content
#Copyright (C) 2011,2012  Vincent C. Passaro (vincent.passaro@gmail.com)
#
#This program is free software; you can redistribute it and/or
#modify it under the terms of the GNU General Public License
#as published by the Free Software Foundation; either version 2
#of the License, or (at your option) any later version.
#
#This program is distributed in the hope that it will be useful,
#but WITHOUT ANY WARRANTY; without even the implied warranty of
#MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#GNU General Public License for more details.
#
#You should have received a copy of the GNU General Public License
#along with this program; if not, write to the Free Software
#Foundation, Inc., 51 Franklin Street, Fifth Floor,
#Boston, MA  02110-1301, USA.

#!/bin/bash
######################################################################
#By Tummy a.k.a Vincent C. Passaro		                     #
#Vincent[.]Passaro[@]gmail[.]com				     #
#www.vincentpassaro.com						     #
######################################################################
#_____________________________________________________________________
#|  Version |   Change Information  |      Author        |    Date    |
#|__________|_______________________|____________________|____________|
#|    1.0   |   Initial Script      | Vincent C. Passaro | 20-oct-2011|
#|	    |   Creation	    |                    |            |
#|__________|_______________________|____________________|____________|
#
#
#  - Updated by Shannon Mitchell(shannon.mitchell@fusiontechnology-llc.com)
# on 02-jan-2011 to add content and move from dev to prod.


#######################DISA INFORMATION###############################
#Group ID (Vulid): V-4364
#Group Title: The at directory permissions
#Rule ID: SV-4364r7_rule
#Severity: CAT II
#Rule Version (STIG-ID): GEN003400
#Rule Title: The "at" directory must have mode 0755 or less permissive.
#
#Vulnerability Discussion: If the "at" directory has a mode more permissive 
#than 0755, unauthorized users could be allowed to view or to edit files 
#containing sensitive information within the "at" directory. Unauthorized 
#modifications could result in denial of service to authorized "at" jobs.
#
#Responsibility: System Administrator
#IAControls: ECLP-1
#
#Check Content: 
#Check the mode of the "at" directory.
#
#Procedure:
# ls -ld /var/spool/cron/atjobs /var/spool/atjobs /var/spool/at
#
#If the directory mode is more permissive than 0755, this is a finding.
#
#Fix Text: Change the mode of the "at" directory to 0755.
#
#Procedure:
# chmod 0755 <at directory> 
#######################DISA INFORMATION###############################

#Global Variables#
PDI=GEN003400
#Start-Lockdown

#Start-Lockdown
for ATFILE in /var/spool/cron/atjobs /var/spool/atjobs /var/spool/at
do

  if [ -a "$ATFILE" ]
  then

    # Pull the actual permissions
    FILEPERMS=`stat -L --format='%04a' $ATFILE`

    # Break the actual file octal permissions up per entity
    FILESPECIAL=${FILEPERMS:0:1}
    FILEOWNER=${FILEPERMS:1:1}
    FILEGROUP=${FILEPERMS:2:1}
    FILEOTHER=${FILEPERMS:3:1}

    # Run check by 'and'ing the unwanted mask(7022)
    if [ $(($FILESPECIAL&7)) != "0" ] || [ $(($FILEOWNER&0)) != "0" ] || [ $(($FILEGROUP&2)) != "0" ] || [ $(($FILEOTHER&2)) != "0" ]
      then
        chmod u-s,g-ws,o-wt $ATFILE
    fi

  fi

done
