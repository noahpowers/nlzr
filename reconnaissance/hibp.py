from hibpAPI import *

begin = time.time()

## hard-coded email address for testing purposes
#email = "person@somedomain.com"

auth = AuthToken()
prop = ID()

### [resource = ] Sets API URI
emailCount = 0
breachList = []
methods = Methods()
with open(sys.argv[1]) as f:
    for line in f:
        line = line.strip()
        ### Need to slow it down a little so it doesn't trip Cloudflare
        time.sleep(1)
        resource = methods.setAttr('breachedaccount/' + line)
        emailresults = methods.GET(resource)
        if emailresults is not "false":
            emailCount += 1
# ### obtaining breach information for 
            breachData = prop.getBreachAccountDetails(emailresults, line)
            breachList.append(breachData)

timestr = str(time.strftime("%Y%m%d-%H%M%S"))
filepath = "/root/breachedaccounts-" + timestr + ".csv"
prop.obtainCSV(breachList,filepath,emailCount)

end = time.time()
### time it took in seconds
print(round(end - begin))
