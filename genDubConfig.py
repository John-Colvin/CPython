from __future__ import print_function
from distutils import sysconfig
import sys

if len(sys.argv) < 2:
    print("Error: Must provide a name as first argument, "
            "e.g. \"python3 ./genDubConfig.py myModule\"",
            file=sys.stderr)
    exit(1)

name = sys.argv[1]
vinfo = sys.version_info
libdir = sysconfig.get_config_var("LIBDIR")

print(
'''{
    "name": "''' + name + '''",
    "sourcePaths": ["."],
    "targetType": "dynamicLibrary",
    "targetName": "''' + name + '''",

    "dependencies": { "cpython": { "path": "../../" } },
    "subConfigurations": { "cpython": "python''' + str(vinfo[0]) + str(vinfo[1]) + '''" },
    "lflags-posix": ["-L''' + libdir + '''"],
    "postBuildCommands-posix": [
        "mv lib$$DUB_TARGET_NAME.so $$DUB_TARGET_NAME.so"
    ]
}''')
