#!/usr/bin/env python2.7

import argparse
import random
import re
import string

parser = argparse.ArgumentParser(description='Email Campaign Formatter')
parser.add_argument('-s',  action="store",  dest='subject',  default="CHANGE SUBJECT",  help="email subject surrounded by double-quotes")
parser.add_argument('-d',  action="store",  dest='domain',  default='127.0.0.1',  help='FQDN emails come from')
parser.add_argument('-u',  action="store",  dest='username',  default='jdoe',  help='sender short email name')
parser.add_argument('-f',  action="store",  dest='firstname',  default='John',  help='first name of sender')
parser.add_argument('-l',  action="store",  dest='lastname',  default='Doe',  help='last name of sender')
parser.add_argument('-e',  action="store",  dest='email',  default=[],  help='plain text email body file')
parser.add_argument('-S',  action="store",  dest='signature',  default=[],  help='plain text signature file')
parser.add_argument('-L',  action="store",  dest='link',  default='',  help='HTA link')
parser.add_argument('-P',  action="store",  dest='pixel',  default='',  help='pixel link')

results = parser.parse_args()

boundaryID = ''.join(random.SystemRandom().choice(string.digits + string.ascii_lowercase + string.digits) for _ in range(28))

header = '\nMIME-Version: 1.0\n'
header += 'Subject: ' + results.subject + '\n'
header += 'From: ' + results.firstname + ' ' + results.lastname + ' <' + results.username + "@" + results.domain + '>' + '\n'
header += 'Content-Type: multipart/alternative; boundary=' + boundaryID + '\n'

altTextContent = '\n--' + boundaryID + '\n'
altTextContent += 'Content-Type: text/plain; charset="UTF-8"\n\n'

httpContent = '\n--' + boundaryID + '\n'
httpContent += 'Content-Type: text/html; charset="UTF-8"\n'
httpContent += 'Content-Transfer-Encoding: quoted-printable\n\n'

footer = '\n\n--' + boundaryID + '--\n'

body = ''
bodyDiv = '<div dir=3D"ltr"><div>'
with open(results.email) as f:
    for line in f:
        body += line
        bodyDiv += '<div>' + "<br>".join(line.split("\n")) + '</div>'

if results.link == '':
    with open(results.signature) as f:
        for line in f:
            body += line
            bodyDiv += '<div>' + "<br>".join(line.split("\n")) + '</div>'
else:
    body += results.link + '\n'
    bodyDiv += '<a href=3D"' + results.link + '">' + results.link + "</a>"
    with open(results.signature) as f:
        for line in f:
            body += line

if results.pixel == '':
    bodyDiv += '<div>' + "<br>".join(line.split("\n")) + '</div>'
else:
    context = '<img src="' + results.pixel + '">'
    bodyDiv += '<div>' + "<br>".join(line.split("\n")) + context + '</div>'

bodyDiv += "</div></div>"
bodyHTTP = "=\n".join(re.findall("(?s).{,68}", bodyDiv))[:-1]
email = header + altTextContent +body + httpContent + bodyHTTP + footer

print(email)
