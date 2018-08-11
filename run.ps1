. "$PSScriptRoot\includes.ps1"

clear

cd src
BuildLua
BuildAseprite
RunGame
cd ..