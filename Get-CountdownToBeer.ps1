function Get-CountdownToBeer {
    param (
        [Parameter(Mandatory = $True)]
        $BeerOClock,

        [Parameter(Mandatory = $False)]
        [Bool]$Speak
    )
do
{
    $Timeleft = New-TimeSpan -Start (Get-date) -End $BeerOClock
    Start-Sleep -Seconds 1
    Clear-Host
    Write-Output "Countdown til øl! - $(($Timeleft).Minutes):$(($Timeleft).Seconds)"
    } until ($Timeleft.Seconds -eq "0" -and $Timeleft.Minutes -eq "0")
    Write-Output "Nutid, Datid, ØlTid, Altid!"
    if ($Speak -eq $true){Add-Type -AssemblyName System.speech;$Speech = New-Object System.Speech.Synthesis.SpeechSynthesizer;$Speech.Speak("Beer time!!!");Sleep -Seconds 2;$Speech.Speak("Beer time!!!");Sleep -Seconds 2;$Speech.Speak("Beer time!!!")}
}
