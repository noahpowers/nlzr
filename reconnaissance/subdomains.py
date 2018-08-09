import sys 
import sublist3r
domain = sys.argv[1]
fileout = str(domain) + "_subdomains.txt"
subdomains = sublist3r.main(domain, 40, fileout, ports=None, silent=False, verbose=False, enable_bruteforce=False, engines=None)