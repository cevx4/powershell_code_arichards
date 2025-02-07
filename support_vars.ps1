# Variables and function that support system.

New-Variable -Name rootDirectoryPath -Value "G:\SampleDesktop" -Option Constant

$workingEnvPathInfo = [PSCustomObject]@{
    currentDrive = 'G:\'
    currentDir = 'SampleDesktop'    
}


#C:\Users\MCXIV\Documents\GitHub\richards_code\archive\richards_code
# workingEnvPathInfo.currentDrive




function setExecPolicyForCurrentUser{
    Set-ExecutionPolicy -ExecutionPolicy Unrestricted -Scope CurrentUser
}

function test1{
    return $workingEnvPathInfo.currentDrive + $workingEnvPathInfo.currentDir
}

