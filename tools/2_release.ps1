$ProjectRoot = (Get-Item $PSScriptRoot).Parent.FullName

New-Item -Path "$ProjectRoot\build\r6\scripts" -ItemType "directory" -Force
Copy-Item -Path "$ProjectRoot\src\redscript\*" -Destination "$ProjectRoot\build\r6\scripts" -Force -Recurse

Copy-Item -Path "$ProjectRoot\resources\packed\*" -Destination "$ProjectRoot\build" -Force -Recurse

New-Item -Path "$ProjectRoot\build\red4ext\plugins\in_world_navigation" -ItemType "directory" -Force
Copy-Item -Path "$ProjectRoot\src\red4ext\build\release\bin\*" -Destination "$ProjectRoot\build\red4ext\plugins\in_world_navigation" -Force

# Dist
New-Item -Path "$ProjectRoot\dist" -Type "Directory" -Force
Compress-Archive -Path "$ProjectRoot\build\*" -DestinationPath "$ProjectRoot\dist\in_world_navigation.zip" -Force