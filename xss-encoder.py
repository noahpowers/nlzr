import cgi
import sys
import urllib2

### The data going into the script should be surrounded by double-quotes
### this also means you will have to escape all double-quotes inside the
### data with a slash (eg. \")

q = sys.argv[1]
urlenc = urllib2.quote(q)
tempHTMLENC = cgi.escape(q).encode('ascii', 'xmlcharrefreplace')
htmlenc = tempHTMLENC.replace(" ","+")

print '''
--------------------------------------------------------
    [+]  Here's the URL ENCODED format:
--------------------------------------------------------
'''
print(urlenc)
print '''
--------------------------------------------------------
    [+]  Here's the HTML ENCODED format:
--------------------------------------------------------
'''
print(htmlenc)
print("")
