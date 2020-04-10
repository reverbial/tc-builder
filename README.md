[![Build Status](https://drone.lzi.io/api/badges/gavin/tc-builder/status.svg)](https://drone.lzi.io/gavin/tc-builder)

##### Overview
-----
This docker image builds a user supplied version of the TrinityCore or compatible 3.3.5 branch source code.
Files are all statically linked which should make the resulting output work on most Linuxes with no dependancy issues.

##### Running the image
-----
Assuming you have a copy of your TrinityCore git repo at /usr/local/src/TrinityCore the following run command will compile all 
relevant files and output them to /opt/trinitycore.

```shell
docker run --rm -v /usr/local/src/Trinitycore:/usr/local/src/Trinitycore -v /opt/trinitycore:/opt/trinitycore
```
