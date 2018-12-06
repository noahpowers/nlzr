import datetime
import json
import random
import re
import requests
import sys
import time
from requests.packages.urllib3.exceptions import InsecureRequestWarning
from requests_toolbelt.utils import dump

class AuthToken:
    def __init__(self):
        self = self

    def setAttr(self, attr):
        api = attr
        url = 'https://haveibeenpwned.com/api/v2/' + api + "/"
        return(url)

class Methods(AuthToken):
    def __init__(self):
        self = self

    def GET(self, resource):
        requests.packages.urllib3.disable_warnings(InsecureRequestWarning)
        uaList = ["Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/52.0.2743.116 Safari/537.36 Edge/15.15063","Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/64.0.3282.140 Safari/537.36 Edge/17.17134","Mozilla/5.0 (Windows NT 10.0; WOW64; Trident/7.0; rv:11.0) like Gecko","Mozilla/5.0 (Macintosh; Intel Mac OS X 10.13; rv:60.0) Gecko/20100101 Firefox/60.0","Mozilla/5.0 (Macintosh; Intel Mac OS X 10_14_1) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/12.0.1 Safari/605.1.15","Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/62.0.3202.9 Safari/537.36","Mozilla/5.0 (iPhone; CPU iPhone OS 11_0_1 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A402 Safari/604.1"]
        useragent = random.choice(uaList)
        url = resource
        headers = { 'User-Agent': useragent }
        r = requests.get(url,headers=headers,verify=False)
        if r.status_code == 404:
            status = "false"
            return(status)

        else:
            return json.loads(r.text)
            

class ID(AuthToken, Methods):
    def __init__(self):
        self = self

    def getBreachAccountDetails(self, results, email):
        count = 0
        list = []
        blah = len(results)-1
        while count <= blah:
            breachDomain = results[count]['Title']
            breachDate = results[count]['BreachDate']
            count += 1
            list.append([email, breachDomain,breachDate])
        return list

    def obtainCSV(self, results, filepath, total):
        print("Emails with compromised passwords (as identified from past data breaches):  %s" % (total))
        count1 = 0
        while count1 < len(results):
            count2 = 0
            while count2 < len(results[count1]):
                print "Breached Email Address: %s" % (results[count1][count2][0])
                email = results[count1][count2][0]
                print "Domain Breached: %s" % (results[count1][count2][1])
                domain = results[count1][count2][1]
                print "Date Breach Reported: %s" % (results[count1][count2][2])
                breachDate = results[count1][count2][2]
                count2 += 1
                with open(filepath, 'a') as file:
                    writestr = email + "," + domain + "," + breachDate + '\n'
                    file.write(writestr)
            count1 += 1
        print "[ + ] Results saved in a CSV file at the following location:  %s" % (filepath)
