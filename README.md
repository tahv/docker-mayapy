# docker-mayapy

Autodesk Maya images on `ubuntu:22.04`.

## Supported tags

- [`2025`, `latest`](https://github.com/tahv/docker-mayapy/blob/main/2025/Dockerfile) (Python `3.11.4`)
- [`2024`](https://github.com/tahv/docker-mayapy/blob/main/2024/Dockerfile) (Python `3.10.8`)
- [`2023`](https://github.com/tahv/docker-mayapy/blob/main/2023/Dockerfile) (Python `3.9.7`)
- [`2022`](https://github.com/tahv/docker-mayapy/blob/main/2022/Dockerfile) (Python `3.7.7`)

## Reference

- Github: [https://github.com/tahv/docker-mayapy](https://github.com/tahv/docker-mayapy)
- Docker Hub: [https://hub.docker.com/r/tahv/mayapy](https://hub.docker.com/r/tahv/mayapy)

## Usage

### Interactive

Run in interactive mode.

```bash
docker run -it --rm tahv/mayapy:latest
```

Start `mayapy` inside the container.

```python
$ mayapy
>>> import maya.standalone
>>> maya.standalone.initialize()
>>> from maya import cmds
>>> from maya.api import OpenMaya
```

### As Github workflow

Use `tahv/mayapy` as your job `image`.

```yaml
name: Mayapy

on: [push]

jobs:
   build:
    name: Mayapy
    runs-on: ubuntu-latest
    container:
      image: tahv/mayapy:latest
    steps:
      - name: Print Maya version
        run: mayapy -c "import maya.standalone; maya.standalone.initialize(); from maya import cmds; print(cmds.about(v=True))"
```

Or use a matrix to run on multiple versions.

```yaml
name: Mayapy

on: [push]

jobs:
  build:
    name: Mayapy ${{ matrix.maya-version }}
    runs-on: ubuntu-latest
    strategy:
      matrix:
        maya-version:
          - "2022"
          - "2023"
          - "2024"
          - "2025"
    container:
      image: tahv/mayapy:${{ matrix.maya-version }}
    steps:
      - name: Print Maya version
        run: mayapy -c "import maya.standalone; maya.standalone.initialize(); from maya import cmds; print(cmds.about(v=True))"
```

## Notes

### Installed softwares

Pre-installed:

- `git`
- `wget`

`/usr/autodesk/maya/bin` is added to `PATH`, exposing:

- `pip` (invoke it with `python -m pip`)
- `mayapy`
- `python` (symlink of `mayapy`)

### Installed libraries

Additional libraries are installed following Autodesk documentation.

- 2025:
  [Required libraries](https://help.autodesk.com/view/MAYAUL/2025/ENU/?guid=GUID-D2B5433C-E0D2-421B-9BD8-24FED217FD7F);
  [Installing on Ubuntu](https://www.autodesk.com/support/technical/article/caas/tsarticles/ts/5ZZjP3R0R7hzPyhDYkd8IS.html).
- 2024: 
  [Required libraries](https://help.autodesk.com/view/MAYAUL/2024/ENU/?guid=GUID-D2B5433C-E0D2-421B-9BD8-24FED217FD7F);
  [Installing on Ubuntu](https://www.autodesk.com/support/technical/article/caas/tsarticles/ts/4EQDDcHqJbfBkQr3i0FrbQ.html).
- 2023:
  [Required libraries](https://help.autodesk.com/view/MAYAUL/2023/ENU/?guid=GUID-D2B5433C-E0D2-421B-9BD8-24FED217FD7F);
  [Installing on Ubuntu](https://www.autodesk.com/support/technical/article/caas/tsarticles/ts/77DVRQ8wFRltRxWlSY4HVt.html).
- 2022:
  [Required libraries](https://help.autodesk.com/view/MAYAUL/2022/ENU/?guid=GUID-D2B5433C-E0D2-421B-9BD8-24FED217FD7F);
  [Installing on Ubuntu](https://www.autodesk.com/support/technical/article/caas/tsarticles/ts/653FjR7SuamMJ5Y4v9XkXg.html).


### libxp6

`libxp6` is installed from [ppa:zeehio/libxp](https://launchpad.net/~zeehio/+archive/ubuntu/libxp)
as recommanded by [Autodesk](https://www.autodesk.com/support/technical/article/caas/tsarticles/ts/5ZZjP3R0R7hzPyhDYkd8IS.html).

The archive has removed `libxp6` because it is obsolete and the last build is on Ubuntu 22.04.

### Removed directories

- `/usr/autodesk/maya/Examples` is removed from the images to save ~1G of space.

### Exit code

Maya will [set the exit code to 0](https://forums.autodesk.com/t5/maya-programming/wrong-exit-code-with-mayapy/td-p/8460077)
when standalone crashes. 
All images set `MAYA_NO_STANDALONE_ATEXIT=1` to make maya return a non 0 exit code.

### Disabling analytics

All images set `MAYA_DISABLE_ADP=1` to opt-out of analytics 
when starting Maya in batch mode, which can cause a hang on close.

## Development

Clone the repo, cd into it and build an image from one of the directories.

```bash
git clone https://github.com/tahv/docker-mayapy
cd docker-mayapy
docker build --platform linux/amd64 -t tahv/mayapy:2025 2025
docker run -it --rm mayapy:2025
```

### Debugging

> Debugging tips for creating new images, in no particular order.

List missing dependencies.

```bash
ldd /usr/autodesk/maya/lib/* 2> /dev/null | sed -nE 's/\s*(.+) => not found/\1/p' | sort --unique
```

Set this variable to make Qt print out diagnostic information 
about each plugin it tries to load.

```bash
export QT_DEBUG_PLUGINS=1
```

Read Maya `ubuntu_README.txt` for information on how to fix potential versioning issues
with `libssl` and `libcrypto`.

```bash
cat /usr/autodesk/maya/support/python/*/ubuntu_README.txt
```

Initialize Maya and load plugins to catch missing dependencies.

```bash
mayapy -c "import maya.standalone; maya.standalone.initialize(); from maya import cmds; cmds.loadPlugin('fbxmaya'); cmds.loadPlugin(a=True)"
```

<!--
Qt5 dependencies: [](https://wiki.qt.io/Qt5_dependencies)
-->
