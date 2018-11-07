function Get-CountdownToBeer
{
    param (
        [Parameter(Mandatory = $True)]
        $BeerOClock,

        [Parameter(Mandatory = $False)]
        [Switch]$Speak
    )
    do
    {
        $Timeleft = New-TimeSpan -Start (Get-date) -End $BeerOClock
        Start-Sleep -Seconds 1
        Clear-Host
        Write-Output "Countdown til øl! - $(($Timeleft).Minutes):$(($Timeleft).Seconds)"
    } until ($Timeleft.Seconds -eq "0" -and $Timeleft.Minutes -eq "0")
    Write-Output "Nutid, Datid, ØlTid, Altid!"
    if ($Speak) {Add-Type -AssemblyName System.speech; $Speech = New-Object System.Speech.Synthesis.SpeechSynthesizer; $Speech.Speak("Beer time!!!"); Sleep -Seconds 1; $Speech.Speak("Beer time!!!"); Sleep -Seconds 1; $Speech.Speak("Beer time!!!")}
    Invoke-Beer -Path ".\beer.png"
}
Function Invoke-Beer
{
    param(
        [String] [parameter(mandatory = $true, Valuefrompipeline = $true)] $Path
    )
    Begin
    {
        [void] [System.Reflection.Assembly]::LoadWithPartialName('System.drawing')

        $Colors = @{
            'FF000000' = 'Black'
            'FFFFFFFF' = 'White'
        }

        Function Get-ClosestConsoleColor($PixelColor)
        {
            ($(foreach ($item in $Colors.Keys)
                    {
                        [pscustomobject]@{
                            'Color' = $Item
                            'Diff'  = [math]::abs([convert]::ToInt32($Item, 16) - [convert]::ToInt32($PixelColor, 16))
                        }
                    }) | Sort-Object Diff)[0].color
        }
    }
    Process
    {

        Foreach ($item in $Path)
        {

            $BitMap = [System.Drawing.Bitmap]::FromFile((Get-Item $Item).fullname)
        }
        Foreach ($y in (1..($BitMap.Height - 1)))
        {
            Foreach ($x in (1..($BitMap.Width - 1)))
            {
                $Pixel = $BitMap.GetPixel($X, $Y)
                $BackGround = $Colors.Item((Get-ClosestConsoleColor $Pixel.name))


                If ($ToASCII)
                {
                    Write-Host "$([Char](Get-Random -Maximum 126 -Minimum 33))" -NoNewline -ForegroundColor $BackGround
                }
                else
                {
                    Write-Host " " -NoNewline -BackgroundColor $BackGround
                }
            }
            Write-Host ''
        }
    }
}