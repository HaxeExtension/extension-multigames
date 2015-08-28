#!/bin/bash
dir=`dirname "$0"`
cd "$dir"
rm -f extension-multigames.zip
zip -r extension-multigames.zip extension haxelib.json include.xml
