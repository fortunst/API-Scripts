#!/bin/bash

########################################################################################################
#
# Copyright (c) 2013, JAMF Software, LLC.  All rights reserved.
#
#       Redistribution and use in source and binary forms, with or without
#       modification, are permitted provided that the following conditions are met:
#               * Redistributions of source code must retain the above copyright
#                 notice, this list of conditions and the following disclaimer.
#               * Redistributions in binary form must reproduce the above copyright
#                 notice, this list of conditions and the following disclaimer in the
#                 documentation and/or other materials provided with the distribution.
#               * Neither the name of the JAMF Software, LLC nor the
#                 names of its contributors may be used to endorse or promote products
#                 derived from this software without specific prior written permission.
#
#       THIS SOFTWARE IS PROVIDED BY JAMF SOFTWARE, LLC "AS IS" AND ANY
#       EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
#       WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
#       DISCLAIMED. IN NO EVENT SHALL JAMF SOFTWARE, LLC BE LIABLE FOR ANY
#       DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
#       (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
#       LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
#       ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
#       (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
#       SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
#
####################################################################################################

# This script reads a CSV which includes computer names and adds the machines to a new
# static group.  The name of the group must not exist in the JSS already.

#Variables to be set before executing
name=""						#Name of the new static group
server=""					#Server name e.g. "JAMFSoftware.com"
username=""					#JSS username with API privileges
password=""					#Password for the JSS account
file=""						#Path to the CSV

##Do not touch below this line!

#Setup indexes to determine how many machines will be added to the group.
count=`fgrep -o , ${file} | wc -l | awk '{print $NF}'`
counter="0"

#Variables used to create the XML
a="<computer_group><name>${name}</name><computers>"
b="<computer><name>"
c="</name></computer>"
d="	</computers></computer_group>"

#Creation of the XML
echo "${a}" > /tmp/test.xml

while [ ${counter} -le ${count} ]
do
	counter=$[$counter+1]
	var=`cat ${file} | awk -F, '{print $'"${counter}"'}'`
	echo "${b}${var}${c}" >> /tmp/test.xml
done

echo "${d}" >> /tmp/test.xml

#Submit the XML to the API
curl -v -u ${username}:${password} https://${server}:8443/JSSResource/computergroups/name/Name -T "/tmp/test.xml" -X POST

#Cleanup the XML file
rm /tmp/test.xml

exit 0