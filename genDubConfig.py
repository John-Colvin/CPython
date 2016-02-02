from __future__ import print_function
from distutils import sysconfig
import sys

help = '''Creates a dub.json for a project depending
on cpython.

Usage:
Run with the python interpreter you want to build for.
Pass the desired name of the package as the first arg.

E.g.

"python ./genDubConfig.py myModuleName"

The output is printed to stdout, so you may want to
pipe it straight to a file e.g.

"python ./genDubConfig.py myModuleName > dub.json"
'''

if len(sys.argv) < 2:
    print(help, file=sys.stderr)
    exit(1)

name = sys.argv[1]
vinfo = sys.version_info
py2 = vinfo[0] == 2
py3 = vinfo[0] == 3
libdir = sysconfig.get_config_var("LIBDIR")
libname = "python" + sysconfig.get_config_var('VERSION') + (sys.abiflags if py3 else '')

print(
'''{
    "name": "''' + name + '''",
    "sourcePaths": ["."],
    "targetType": "dynamicLibrary",
    "targetName": "''' + name + '''",

    "dependencies": { "cpython": { "path": "../../" } },
    "subConfigurations": { "cpython": "python''' + str(vinfo[0]) + str(vinfo[1]) + '''" },
    "lflags-posix": ["-L''' + libdir + '''"],
    "libs": ["''' + libname + '''"],
    "postBuildCommands-posix": [
        "mv lib$$DUB_TARGET_NAME.so $$DUB_TARGET_NAME.so"
    ]
}''')
