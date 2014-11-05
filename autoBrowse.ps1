#autoBrowse.ps1
#
#Opens IE in fullscreen on the monitor on the right
#Uses websites listed in websites.conf
#

while($true){
    stop-process -name iexplore
    $ie = new-object -ComObject internetexplorer.application
    Get-Member -InputObject $ie
    $ie.Top = 53
    $ie.Left = 2730
    $ie.FullScreen = $true
    $ie.Visible = $true
    $list = get-content C:\scripts\websites.conf
    #$list = "http://www.newser.com/", "http://www.slashdot.org/", "http://www.devour.com/", "http://www.knstrct.com/", "http://lifehacker.com/", "http://www.joquz.com/", "http://abduzeedo.com/", "http://www.notcot.org/", "http://plastolux.com/", "http://www.furniturefashion.com/", "http://www.coolhunting.com/", "http://www.beautifullife.info/", "http://www.designboom.com/", "http://www.yankodesign.com/", "http://blog.2modern.com/", "http://www.core77.com/blog/", "http://www.designsponge.com/", "http://www.thecoolhunter.net/", "http://www.uncrate.com/", "http://www.design-milk.com/"
    while($ie.Width -ne $null){
        foreach($site in $list){
            if($ie.Width -eq $null){break}
            write-host $site
            $ie.Navigate($site)
            $ie.Visible = $true
            Start-Sleep -s 300
        }
    }
    write-host "Window was closed"
}
