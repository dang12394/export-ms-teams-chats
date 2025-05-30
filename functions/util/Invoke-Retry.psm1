[cmdletbinding()]
Param([bool]$verbose)
$VerbosePreference = if ($verbose) { 'Continue' } else { 'SilentlyContinue' }
$ProgressPreference = "SilentlyContinue"

function Invoke-Retry {
    param(
        [ScriptBlock]$code,
        [int]$maxRetries = 2,
        [int]$delaySeconds = 1
    )

    $retryCount = 0

    while ($retryCount -lt $maxRetries) {
        try {
            & $code
            break
        }
        catch {
            $retryCount++
            if ($retryCount -eq $maxRetries) {
                Write-Verbose "Failed to run code after the maximum of $maxRetries retries."
                Write-Verbose "Exception Message: $($_.Exception.Message)"
                Write-Verbose "Script Stack Trace: $($_.ScriptStackTrace)"
                Write-Verbose $_

                throw $_
            }
            else {
                Write-Verbose "Failed to run code, retrying."
                Start-Sleep -Seconds $delaySeconds
            }
        }
    }
}