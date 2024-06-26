#######################################################################################################
## Description: Script that it verifies the existence of an object (file or directory) under a path
##              It goes in alarm when the object exists and it is more old than N day
##
## Author: Matteo Z.
#######################################################################################################

# parameter on a command-line
Param (
        [Parameter(Mandatory = $true) ] [Alias('D')] [int]$day,
        [Parameter(Mandatory = $true) ] [Alias('P')] $path
)

function print_usage {
        Write-Host "`nScript that it verifies the existence of an object (file or directory) under a path. It goes in alarm when the object exists and it is more old than N day"
        Write-Host "`nUsage:"
        Write-Host "  $script_name -P [<object_path>] -D [<N_day]>"
        Write-Host "`nOptions:"
        Write-Host "  -P"
        Write-Host "     Path to verify"
        Write-Host "  -D"
        Write-Host "     N day (it must be a number!)`n"
        Exit 3
}


########## MAIN ##########

$script_name = $MyInvocation.MyCommand.Name
$i = 1

if ($day.Length -eq 0 -Or $path.Length -eq 0) {    # to verify if the variable is null or empty
        Write-Host "`nCritical!! You have done something wrong!"
        print_usage
} else {
        if (Test-Path $path -PathType Container) {
                # $file = $(Get-ChildItem $path -File | Measure-Object).count                         # count the file
                # $directory = $(Get-ChildItem $path -Directory | Measure-Object).count               # count the directory
                # Write-Host "File found = $file - Directory found = $directory"
                $old_object = Get-ChildItem $path | Where-Object {$_.LastWriteTime -lt (Get-Date).AddDays(-$day)}      # save all file that are more old than N day
                # Write-Host "Old objects = $old_object"

                if ($old_object.Length -eq 0) {
                        Write-Host "OK!! In this path, there are not any object that are more old than $day day!"
                        Exit 0
                } else {
                        $msg = "Critical!! Object older than $day day ->"

                        foreach ($x in $old_object) {
                                if ($x.PsIsContainer) {         # to verify if the object is a directory
                                        $msg += " $i) $x (dir) "
                                } else {
                                        $msg += " $i) $x (file) "
                                }

                                $i += 1
                        }

                        Write-Host $msg
                        Exit 2
                }
        } else {
                Write-Host "Critical!! This path doesn't exist!"
                Exit 2
        }
}