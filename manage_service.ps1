####################################################################
## Description: Script for managing services on a Windows system
##
## Author: Matteo Z.
####################################################################

function print_usage {
	Write-Host -ForegroundColor "red" "`nDescription:"
	Write-Host "   Script for managing services on a Windows system (such as getting the list of services, restarting them or stopping them)"
        Write-Host "   To avoid errors when performing stop or restart services, it is recommended to run the script as administrator"
	Write-Host "`n   File created witih the list of the running services: $file_svc_ok"
	Write-Host "`n   File created with the list of other services excluding running services: $file_svc_ko`n"
}

function verify_svc_files {
        foreach ($item in $files) {
                if (Test-Path $item -PathType Leaf) {
                        Clear-Content $item
                }
        }
}

function create_svc_files {
        $header = "Name`tDisplayName`tStatus`tStartType"
        $header > $file_svc_ok
        $header > $file_svc_ko

        foreach ($item in $get_svc) {
                $svc_name = $item.'Name'
                $svc_display_name = $item.'DisplayName'
                $svc_status = $item.'Status'
                $svc_type = $item.'StartType'

                if ($svc_status -eq "Running") {
                        "$svc_name`t$svc_display_name`t$svc_status`t$svc_type" >> $file_svc_ok
                } else {
                        "$svc_name`t$svc_display_name`t$svc_status`t$svc_type" >> $file_svc_ko
                }
        }

        Write-Host "Running services can be found in: $file_svc_ok"
        Write-Host "Other services can be found in: $file_svc_ko"
}

function svc_existence {
        $flag = 0

        foreach ($item in $get_svc) {
                if ($item.'Name' -eq $user_input -or $item.'DisplayName' -eq $user_input) {
                        $flag = 1
                }
        }

        return $flag
}


########## MAIN ##########

$file_svc_ok = "C:\temp\services_running.csv"
$file_svc_ko = "C:\temp\services_not_running.csv"
$files = @($file_svc_ok, $file_svc_ko)

print_usage
Start-Sleep -Seconds 2.0        # it suspends the activity in a script or session for the specified period of time

$user_input = Read-Host "Do you want to continue with the program? (y/n)"

if ($user_input -eq "y") {
        $get_svc = Get-Service | Select-Object Name, DisplayName, Status, StartType
        verify_svc_files
        create_svc_files

        while ($true) {
                $user_input = Read-Host "`nDo you want restart a service or stop its? (restart/stop) - type 0 to quit"

                if ($user_input -eq "restart") {
                        $user_input = Read-Host "Type the service you want to restart"
                        $flag = svc_existence

                        if ($flag) {
                                Get-Service $user_input | Restart-Service
                        } else {
                                Write-Host "Service not found!"
                        }
                } elseif ($user_input -eq "stop") {
                        $user_input = Read-Host "Type the service you want to stop"
                        $flag = svc_existence

                        if ($flag) {
                                Get-Service $user_input | Stop-Service
                        } else {
                                Write-Host "Service not found!"
                        }
                } elseif ($user_input -eq 0) {
                        break
                }
        }
} else {
        Write-Host "Exit from the program!"
}

Write-Host ""