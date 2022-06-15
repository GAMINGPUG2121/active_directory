# 01 Installing the Domain Controller

1. Use `sconfig` to:
    - Change the hostname
    - Change the IP address to Static
    - Change the DNS Server to our own IP address

2. Install the Active Directory Windows Feature


```shell
install-windowsfeature AD-Domain-Services -IncludemanagementTools
```

```
Get-NetIPAddress
```
