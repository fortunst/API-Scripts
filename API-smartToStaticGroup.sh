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

#This script is an example of how the API can be used to create a static group based on the membership of a smart group.
#This example was setup for use with a mobile device smart group.

#Variables to be set before executing
ID=""						#ID of the smart group
name=""						#Name of the new static group
server=""					#Server name e.g. "JAMFSoftware.com"
username=""					#JSS username with API privileges
password=""					#Password for the JSS account

##Do not touch below this line!

#Get a list of computers currently in the smart group
var=`curl -v -u ${username}:${password} https://${server}:8443/JSSResource/mobiledevicegroups/id/${ID} -X GET | awk -F 'mobile_devices' '{print $2}'`

#Reformatting to create the XML
a="<mobile_device_group><name>${name}</name><mobile_devices"
b="mobile_devices></mobile_device_group>"
var=${a}${var}${b}

#Output the data to an XML file
echo "${var}" > /tmp/test.xml

#Submit the XML to the API
curl -v -u ${username}:${password} https://${server}:8443/JSSResource/mobiledevicegroups/name/Name -T "/tmp/test.xml" -X POST

#Cleanup the XML file


exit 0