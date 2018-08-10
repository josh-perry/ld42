clear

function BuildLua {
    moonc .
}

function BuildMaps {
    if (!(Test-Path maps)) {
        New-Item -ItemType Directory -Force -Path maps
    }

    cd maps

    $tiledMaps = Get-ChildItem -Path . -Filter *.tmx

    $tiledMaps | ForEach-Object {
        $noExt = [System.IO.Path]::GetFileNameWithoutExtension($_)

        Write-Host $("Exporting $_ to $noExt.lua")
        tiled --export-map $_ $("$noExt.lua")
    }

    cd ..
}

function BuildAseprite {
    if (!(Test-Path img)) {
        New-Item -ItemType Directory -Force -Path img
    }

    cd img

    $asepriteFiles = Get-ChildItem -Path . -Filter *.aseprite

    $asepriteFiles | ForEach-Object {
        $noExt = [System.IO.Path]::GetFileNameWithoutExtension($_)

        Write-Host $("Exporting $_ to '$noExt.png' & '$noExt.json'")
        aseprite -b $_ --data $("$noExt.json") --format json-array --sheet $("$noExt.png")
    }

    cd ..
}

function RunGame {
    love . --console
}

cd src
BuildLua
BuildMaps
BuildAseprite
RunGame
cd ..