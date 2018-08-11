clear

. "$PSScriptRoot\includes.ps1"

cd src
BuildLua
BuildMaps
BuildAseprite
RunGame
cd ..