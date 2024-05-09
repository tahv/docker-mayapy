# docker-mayapy

Autodesk Maya images from `ubuntu:22.04`

## Supported tags

- [2025](https://github.com/tahv/docker-mayapy/blob/main/2025/Dockerfile)

## Reference

-   **Github**:
    [https://github.com/tahv/docker-mayapy](https://github.com/tahv/docker-mayapy)
-   **Docker Hub**:
    [https://hub.docker.com/r/tahv/mayapy](https://hub.docker.com/r/tahv/mayapy)

## Usage

### Interactive

Run the image in interactive mode.

```bash
docker run -it --rm tahv/mayapy:2025
```

Start `mayapy` inside the container.

```python
# Launch mayapy from bash
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

## Notes

### Installed softwares

Pre-installed:

- `git`
- `wget`

`/usr/autodesk/maya/bin` is added to `PATH` and include the following:

- `pip`
- `mayapy`
- `python` (is a symlink of `mayapy`)

### libxp6

In its official [install instruction](https://www.autodesk.com/support/technical/article/caas/tsarticles/ts/5ZZjP3R0R7hzPyhDYkd8IS.html),
Autodesk instruct to install libxp6 from [ppa:zeehio/libxp](https://launchpad.net/~zeehio/+archive/ubuntu/libxp).

The archive has removed libxp6 because it is obsolete. The last built is on Ubuntu 22.04.

## Development

Clone the repo, cd into it and build the image from one of the directories.

```bash
git clone https://github.com/tahv/docker-mayapy
cd docker-mayapy
docker build --platform linux/amd64 -t mayapy 2025
```

