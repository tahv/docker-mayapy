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
docker run -it --rm tahv/mayapy:2025
```

Start `mayapy` inside the container.

```python
$ mayapy

# Initialize maya in standalone mode
import maya.standalone
maya.standalone.initialize()

# From here you can import maya packages
from maya import cmds
from maya.api import OpenMaya

# Uninitialize maya before leaving
maya.standalone.uninitialize()
exit()
```

### As Github workflow

The following example uses the latest version of `tahv/mayapy`.

```yaml
name: Mayapy

on: [push]

jobs:
   build:
    name: Mayapy
    runs-on: ubuntu-latest
    container:
      image: tahv/mayapy
    steps:
      - uses: actions/checkout@v4
      - name: Display Maya version
        run: mayapy -c "import maya.standalone; maya.standalone.initialize(); from maya import cmds; print(cmds.about(v=True))"
```

The following example uses a matrix for the job to set multiple Maya versions.

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
          - "2025"
    container:
      image: tahv/mayapy:${{ matrix.maya-version }}
    steps:
      - uses: actions/checkout@v4
      - name: Display Maya version
        run: mayapy -c "import maya.standalone; maya.standalone.initialize(); from maya import cmds; print(cmds.about(v=True))"
```

## Notes

### Installed softwares

Pre-installed:

- `git`
- `wget`

`/usr/autodesk/maya/bin` is added to `PATH` and include the following:

- `pip` (invoke it with `python -m pip`)
- `mayapy`
- `python` (symlink of `mayapy`)

### libxp6

libxp6 is installed from [ppa:zeehio/libxp](https://launchpad.net/~zeehio/+archive/ubuntu/libxp)
as recommanded by Autodesk official [install instruction](https://www.autodesk.com/support/technical/article/caas/tsarticles/ts/5ZZjP3R0R7hzPyhDYkd8IS.html).

The archive has removed libxp6 because it is obsolete and the last built is on Ubuntu 22.04.

### Removed directories

- `/usr/autodesk/maya/Examples` was removed to save ~1G space.

## Development

Clone the repo, cd into it and build the image from one of the directories.

```bash
git clone https://github.com/tahv/docker-mayapy
cd docker-mayapy
docker build --platform linux/amd64 -t tahv/mayapy:2025 2025
```

List missing dependencies.

```bash
ldd /usr/autodesk/maya/lib/* 2> /dev/null | sed -nE 's/\s*(.+) => not found/\1/p' | sort --unique
```

Initialize Maya and load plugins to catch missing dependencies.

```bash
mayapy -c "import maya.standalone; maya.standalone.initialize(); from maya import cmds; cmds.loadPlugin(a=True)"
```
