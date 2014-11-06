<#Hydrator.ps1
$priS - PRIMARY SEPARATOR   - delineator between INDEX's
$secS - SECONDARY SEPARATOR - delineator between TYPE and VALUE within indexes
$x      INDEX               - line position/section which contains a TYPE and VALUE
$typE - TYPE                - the type of data at the INDEX
$valU - VALUE               - the value of the data TYPE at the INDEX
#>

$priS = '|'
$secS = '|'
$typE = $null
$valU = $null

###TRANSLATION###
#each {} contains one (1x) INDEX
$FunctionTable =                   #Index#
{epochDate $d},                    #0
{convertType $d $event},           #1
{case $d $event $value},           #2
{convertType_split $d $event},     #3
{convertType_split $d $event},     #4
{convertType_split $d $event},     #5
{convertType_split $d $event},     #6
{convertType_split $d $event},     #7
{convertType_split $d $event},     #8
{noChange $d},                     #9
{noChange $d},                     #10
{noChange $d}                      #11

#List of INDEX's which only contain primary TYPE data
$priNOsec = $(0,1) #Starting from 0.. INDEX's which contain only a TYPE and no VALUE or associated SECONDARY SEPARATOR
###translation###

###FUNCTIONS###
#$d = index (this is a static reference to the current INDEX 
#$t = type table
#$v = value table
function noChange ($d) {$d}                                                                                #display the INDEX's current data
function epochDate ($d) { [timezone]::CurrentTimeZone.ToLocalTime(([datetime]'1/1/1970').AddSeconds($d)) } #convert a $priNOsec INDEX from epoch time to local datetime
function convertType ($d, $t){write-host $t[$d]}                                                           #only applicable on INDEX's listed in $priNOsec #see CONVERTTYPE sample below
function convertType_split ($d, $t) {                                                                      #translate the TYPE but leave the current VALUE
    $d=$d.split($secS);
    if($t[$d[0]] -eq $null){
    write-host $d[0]"|"$d[1];
    }else{write-host $t[$d[0]]"|"$d[1];}
}
function case ($d, $t, $v){                                                                                #translate TYPE $t table and VALUE $v table #see CASE sample below
    $d=$d.split($secS);
    if($t[$d[0]] -eq $null){
    write-host $d[0];
    }else{write-host $t[$d[0]];}
    if($v[$d[0]][$d[1]] -eq $null){
        write-host $d[1];
    }else{write-host $v[$d[0]][$d[1]];}
}

###CONVERTTYPE FUNCTION SAMPLE###
#$tableName[INDEX] = "TRANSLATION"
$event = New-Object 'object[]' 6 #Six is the highest event value in this sample
$event[0] = "I am Zero"
$event[1] = "I am One"
$event[2] = "I am Two"
$event[3] = "I am Three"
$event[4] = "I am Four"
$event[5] = "I am Five"
#Or you can use the easy way to input information by:
#$event = @(("I am Zero"),("I am One"),("I am Two"),("I am Three"),("I am Four"),("I am Five"))
###convertType function sample###

###CASE FUNCTION SAMPLE###
#! don't forget to account for the 0. ZERO factor means -1 !#
#First, create a table object with a size of +1 greater than the highest known TYPE
#our highest possible TYPE is 10 so:  $value  = New-Object 'object[]' 11
#Next, populate the data: $value[TYPE]=(TRANSLATION) #VALUE
$value  = New-Object 'object[]' 11
$value[2] = @(
('red'),      #0
('black'),    #1
('blue'),     #2
('green'),    #3
('yellow'),   #4
('cyan'),     #5
('magenta'))  #6
$value[5] = @( 
('orange'),
('white'),
('grey'),
('noir'),
('sise'),
('cream'))
$value[7] = @(
('pie'),
('lemon'))
$value[10] = @(
('pumpkin'),
('car'))
###case function sample###

###SELECT LOG FILE###
$in = "C:\test.log"
write-host $in
$log = get-content $in
###select log file###

###READ DATA###
foreach($line in $log){
    write-host $line;
    $out=$null
    $lineX  = New-Object 'object[]' 12 #this should be the same number as the INDEX's in the above FunctionTable
    $indexes=$line.split($priS)
    if($priS=$secS){ #handle when PRIMARY and SECONDARY SEPARATORS are the same
        $a=0;$b=0;
        foreach($item in $indexes){
            if($priNOsec -notcontains $a){ #handle single-value INDEX's
                if($lineX[$b] -ne $null){
                    $lineX[$b]+=$secS+$item
                    $b++
                }else{
                    $lineX[$b]=$item
                }
            }else{
                $lineX[$b]=$item
                $b++
            }
            $a++
        }
    }else{$lineX=$indexes}
    
    ###TRANSLATION/HYDRATION###
    $x=0; #index
    foreach($item in $lineX){
        $d = $item #this is a lame hack that I found Powershell needs in order to sortof pass a variable to a function in an array of functions.
        & $functionTable[$x]
        $x++
    }
}
