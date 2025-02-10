function one {
    two
}

function two {
    $callStack = Get-PSCallStack
    Write-Output "Called from: $($callStack[1].Command)"
}

one
