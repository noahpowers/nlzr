### The recon script leverages Sublist3r, SimplyEmail, and a handful of other manual techniques to obtain useful information during an assessment.

### Here's a quick-rundown on information produced and where it's stored during each step.

#### Install
* installs both SimplyEmail and Sublister to the "~" file location.

#### Gathering Domains
* stores 2x CSV files and 1x TXT file in "~/Sublist3r/"
* the text file will be used for Finding Emails and WebApp Hosting
```Server Setup Script - Pick an option: 
1) Install Sublist3r	3) Find Sub-Domains	5) Find WebApp Host
2) Install SimplyEmail	4) Find Emails		6) Quit
recon - Pick an option: 3
Enter a domain: github.com
[-] Enumerating subdomains now for github.com
[-] Searching now in Baidu..
[-] Searching now in Yahoo..
[-] Searching now in Google..
[-] Searching now in Bing..
//SNIP//...

```

#### Finding Emails
* uses TXT file produced in the Gathering Domains step
* saves output files to "~/SimplyEmail/"

#### Discovering WebApp Hosting
* uses TXT file produced in the Gathering Domains step
* outputs TXT file to the same folder where "recon" is run from
