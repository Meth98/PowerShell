####################################################################
## Description: Script to print a IP address of a Windows system
##
## Author: Matteo Z.
####################################################################

# get the IP address info (preferred = IP configuration info for addresses that are valid and available for use)
$ip_address = Get-NetIPAddress -AddressState Preferred -AddressFamily IPv4,IPv6 | Format-Table IPAddress,AddressFamily,PrefixOrigin,SuffixOrigin

# check the number of IP addresses
if ($ip_address.Count -gt 1) {
    Write-Host -ForegroundColor red "`nMultiple IP addresses found!"
    $ip_address
} elseif ($ip_address.Count -eq 0) {
    Write-Host -ForegroundColor red "No IP addresses found!"
} else {
    $ip_address
}