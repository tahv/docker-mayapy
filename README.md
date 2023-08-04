# docker-mayapy

Ubuntu + Maya Development Environment

Based on `ubuntu:20.04`. Only support **Maya 2023** (Python 3) at the moment.

## Usage

Clone this repo, cd into it, build the image and run it in interactive mode.

```bash
git clone https://github.com/tahv/docker-mayapy
cd docker-mayapy
docker build --platform linux/amd64 -t tahv/mayapy:2023 .
docker run -it --rm tahv/mayapy:2023
```

You can start `mayapy` inside the container.

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
```
