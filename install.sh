#!/bin/bash
dir=`dirname "$0"`
cd "$dir"
haxelib remove extension-multigames
haxelib local extension-multigames.zip
