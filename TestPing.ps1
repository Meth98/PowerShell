#########################################################
## Description: Script that it tries to ping a system
##
## Author: Matteo Z.
#########################################################

$system_list = "C:\temp\system.txt"
$system_ko = "C:\temp\system_KO.txt"

if (Test-Path $system_list -PathType leaf) {
        $file_content = Get-Content $system_list

        foreach ($system in $file_content) {
                if ($system.Length -eq 0) {
                        continue
                } else {
                        if (Test-Connection -ComputerName $system -Count 2 -Quiet) {
                                Write-Host -ForegroundColor "green" "Ping OK: $system"
                        } else {
                                Write-Host -ForegroundColor "red" "Ping KO: $system"
                                $system >> $system_ko
                        }
                }
        }
} else {
        Write-Host -ForegroundColor "red" "Attention!! Missing the file $system_list with a list of the system, you must created it!"
}