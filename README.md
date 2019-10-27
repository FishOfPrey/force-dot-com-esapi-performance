# force-dot-com-esapi-performance
For testing the performance of DML operations in the Salesforce ESAPI

# SFDX CLI setup steps

`sfdx force:org:create edition=Developer orgName=esapiBaseline -a esapiBaseline -s -v devhub`

-- Currently deploying from older Metadata format. Could use newer SFDX Source format now for both master and stripping branch  
`sfdx force:mdapi:deploy -d src -u esapiBaseline -w 2`

-- Install the unmanaged package from https://github.com/apexlarson/LimitsProfiler  
`sfdx force:package:install --package 04t41000002RXGo -u esapiBaseline -w 2 --publishwait 10`

`sfdx force:org:open -u esapiBaseline -p /apex/limitsprofiler`
