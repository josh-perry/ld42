. "$PSScriptRoot\includes.ps1"

clear

cd src
BuildLua
BuildMaps
BuildAseprite
RunGame
cd ..