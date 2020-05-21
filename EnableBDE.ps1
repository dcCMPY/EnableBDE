# Get the target volume's encryption properties.
$volume = Get-WmiObject win32_EncryptableVolume `
-Namespace root\CIMv2\Security\MicrosoftVolumeEncryption `
-Filter "DriveLetter = 'C:'"

# Get the target system's manufacturer.
$manufacturer = (get-wmiobject win32_computersystem).Manufacturer

#set BIOS password and create output
set-location \\s-server.dccmpy.com\Share$\EnableBDE\DellApp; .\cctk.exe --setuppwd=biospassword | Out-File -Append \\s-server.dccmpy.com\Share$\EnableBDE\$env:computername.txt 
#remove BIOS password
#set-location \\s-server.dccmpy.com\Share$\EnableBDE\DellApp; .\cctk.exe --setuppwd= --valsetuppwd=Rfb10s

# If the manufacturer is Dell, and the volume is not encrypted, prepare it.
if ( $manufacturer -eq "Dell Inc." -and ( $volume.encryptionmethod -eq 0 -or !$volume) ) {

  $tpm = get-TPM
}	
# Is the TPM not enabled? Enable it.
  if ( $tpm.TpmReady -eq $false ) {
    set-location \\s-server.dccmpy.com\Share$\EnableBDE\DellApp; .\cctk.exe --tpm=on --valsetuppwd=biospassword | Out-File -Append \\s-server.dccmpy.com\Share$\EnableBDE\TPMOn\$env:computername.txt
    set-location \\s-server.dccmpy.com\Share$\EnableBDE\DellApp; .\cctk.exe --tpmactivation=activate --valsetuppwd=biospassword | Out-File -Append \\s-server.dccmpy.com\Share$\EnableBDE\TPMActive\$env:computername.txt
  }

# Get the target Computer Name.
$name = (get-wmiobject win32_computersystem).Name

# Is there not an encryptable volume? Make C: encryptable with bdehdcfg.
if ( -not $volume ) {
    bdehdcfg -target default -quiet 
}

# If this is a Dell machine that is not encrypted, encrypt it.
if ( $manufacturer -eq "Dell Inc." -and $volume.encryptionmethod -eq 0 ) {
manage-bde -on c: -s -rp -used | Out-File -Append set-location \\s-server.dccmpy.com\Share$\EnableBDE\$env:computername.txt
}
