function Get-CountdownToBeer
{
    param (
        [Parameter(Mandatory = $False)] $BeerOClock,
        [Parameter(Mandatory = $False)] [Switch]$Speech,
        [Parameter(Mandatory = $False)] [Switch]$Ascii,
        [Parameter(Mandatory = $False)] [Switch]$Now
    )
        function Invoke-Speech
        {
            Add-Type -AssemblyName System.speech; $Speech = New-Object System.Speech.Synthesis.SpeechSynthesizer; $Speech.Speak("Beer time!!!"); Sleep -Seconds 1; $Speech.Speak("Beer time!!!"); Sleep -Seconds 1; $Speech.Speak("Beer time!!!")
        }

        function Invoke-Ascii
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
            $BitMap = [System.Drawing.Bitmap]::FromFile((Get-Item ".\Beer.png"))
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

    if($Now){
        Write-Output "Nutid, Datid, ØlTid, Altid!"
        if ($Speech) {Invoke-Speech}
        if ($Ascii) {Invoke-Ascii}
    }
    else
    {
        do
        {
            $Timeleft = New-TimeSpan -Start (Get-date) -End $BeerOClock
            Start-Sleep -Seconds 1
            Clear-Host
            Write-Output "Countdown til øl! - $(($Timeleft).Minutes):$(($Timeleft).Seconds)"
        } until ($Timeleft.Seconds -eq "0" -and $Timeleft.Minutes -eq "0")

        Write-Output "Nutid, Datid, ØlTid, Altid!"

        if ($Sound) {Invoke-Speech}
        if ($Ascii) {Invoke-Ascii}
    }
}
