$ENV:Path = $ENV:Path + ";$pwd\bin"
$ENV:PACKER_CACHE_DIR = "$PWD\cache\packer"
$ENV:PCKDIR = "$PWD\templates\packer"

if(-Not ($ENV:Path.Contains(";$pwd\bin"))) {
    [System.Environment]::SetEnvironmentVariable("PATH", $ENV:Path + ";$pwd\bin", "USER")
}
[System.Environment]::SetEnvironmentVariable("PACKER_CACHE_DIR", "$PWD\cache\packer", "USER")
[System.Environment]::SetEnvironmentVariable("PCKDIR", "$PWD\templates\packer", "USER")
