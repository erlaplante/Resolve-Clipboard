<#
.SYNOPSIS

DNS Resolution from clipboard list.

.DESCRIPTION

Resolves multiple DNS requests separated by carriage return, newline (vertical list) from the clipboard. Returns each response grouped by type in "$Resolved['RecordType']", uses "Resolve-DnsName".

.EXAMPLE

$Resolved['A']

After script execution: Output all A records

.EXAMPLE

$Resolved['A'] | where {$_.Name -eq 'google.com'}

After script execution: Output all A records from google.com

.EXAMPLE

$Resolved['A'] | select name, ipaddress

After script execution: Output A record responses for just the 'Name' and 'IPAddress' columns
#>

$clipbrd = Get-Clipboard -Raw
$list = $clipbrd -split "`r`n"
$all_responses = @{}

foreach ($item in $list) {

    # Trim whitespace
    $item = $item.Trim()

    try {
        # Skip blank lines
        if ($item -Match '$^') {
            continue
        } else {
            $response = Resolve-DnsName -ErrorAction Stop $($item)
            foreach ($answer in $response) {
                $ans_type = $answer.Type.ToString()

                # Query answer type is not in dictionary of "all_responses", add that type with new List as Values
                if (!($all_responses.ContainsKey($ans_type))) {
                    $all_responses[$ans_type] = New-Object System.Collections.Generic.List[PSCustomObject]
                }
                $all_responses[$ans_type].Add($answer)
            }
        }
    }
    
    catch [System.ComponentModel.Win32Exception] {
        Write-Host $_
    }
}

foreach ($type in $all_responses.Keys) {
    $all_responses[$type] | Format-Table -GroupBy $type -AutoSize
}
$Global:Resolved = $all_responses
