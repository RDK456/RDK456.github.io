# Renders each page of a PDF to PNG using the built-in Windows PDF engine (no installs).
# Usage: .\tools\pdf-to-png.ps1 -Pdf D:\downloads\DhanushResume.pdf -Out $env:TEMP\cv
param([Parameter(Mandatory)][string]$Pdf, [string]$Out = "$env:TEMP\cv-pages")

Add-Type -AssemblyName System.Runtime.WindowsRuntime
$null = [Windows.Storage.StorageFile, Windows.Storage, ContentType = WindowsRuntime]
$null = [Windows.Data.Pdf.PdfDocument, Windows.Data.Pdf, ContentType = WindowsRuntime]
$null = [Windows.Storage.Streams.InMemoryRandomAccessStream, Windows.Storage.Streams, ContentType = WindowsRuntime]
$ext = [System.WindowsRuntimeSystemExtensions].GetMethods() | Where-Object { $_.Name -eq 'AsTask' -and $_.GetParameters().Count -eq 1 }
$opT = ($ext | Where-Object { $_.GetParameters()[0].ParameterType.Name -eq 'IAsyncOperation`1' })[0]
$actT = ($ext | Where-Object { $_.GetParameters()[0].ParameterType.Name -eq 'IAsyncAction' })[0]
function Await($op, $type) { $t = $opT.MakeGenericMethod($type).Invoke($null, @($op)); $t.Wait(); $t.Result }

$file = Await ([Windows.Storage.StorageFile]::GetFileFromPathAsync((Resolve-Path $Pdf).Path)) ([Windows.Storage.StorageFile])
$doc = Await ([Windows.Data.Pdf.PdfDocument]::LoadFromFileAsync($file)) ([Windows.Data.Pdf.PdfDocument])
New-Item -ItemType Directory -Force $Out | Out-Null
for ($i = 0; $i -lt $doc.PageCount; $i++) {
  $ms = New-Object Windows.Storage.Streams.InMemoryRandomAccessStream
  $opts = New-Object Windows.Data.Pdf.PdfPageRenderOptions
  $opts.DestinationWidth = 1400
  $actT.Invoke($null, @($doc.GetPage($i).RenderToStreamAsync($ms, $opts))).Wait()
  $src = [System.IO.WindowsRuntimeStreamExtensions]::AsStreamForRead($ms.GetInputStreamAt(0))
  $fs = [IO.File]::Create("$Out\page$i.png"); $src.CopyTo($fs); $fs.Close()
  "$Out\page$i.png"
}
