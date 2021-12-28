## Resolve-Clipboard

DNS Resolution from clipboard list.

Resolves multiple DNS requests separated by carriage return, newline (vertical list) from the clipboard. Returns each response grouped by type in `$Resolved['RecordType']`, uses "Resolve-DnsName".

##### Examples
Ways to alternatively filter output

* Select all responses of a specific record type:\
   `$Resolved['A']`
   
* Select a specific domain name within a type:\
    `$Resolved['A'] | where {$_.Name -eq 'google.com'}`

* Select only specific columns:\
    `$Resolved['A'] | select name, ipaddress`

##### Reference
[Resolve-DnsName](https://docs.microsoft.com/en-us/powershell/module/dnsclient/resolve-dnsname?view=windowsserver2022-ps)
