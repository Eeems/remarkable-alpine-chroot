[![rm1](https://img.shields.io/badge/rM1-supported-green)](https://remarkable.com/store/remarkable)[![rm2](https://img.shields.io/badge/rM2-supported-green)](https://remarkable.com/store/remarkable-2)[![rmpp](https://img.shields.io/badge/rMPP-supported-green)](https://remarkable.com/store/overview/remarkable-paper-pro)[![rmppm](https://img.shields.io/badge/rMPPM-supported-green)](https://remarkable.com/products/remarkable-paper/pro-move)

reMarkable Alpine Chroot
========================

Scripts to automate creating and maintaining a minimal alpine chroot on a reMarkable tablet.

### Install Automagic
```
sh -c "$(wget https://raw.githubusercontent.com/Eeems/remarkable-alpine-chroot/master/install.sh -O-)"
```

### Uninstall Automagic
```
sh -c "$(wget https://raw.githubusercontent.com/Eeems/remarkable-alpine-chroot/master/install.sh -O-)" _ uninstall
```

### Usage
Make sure `/home/root/.local/bin` is on your path.

#### Run command in chroot

```bash
alpine-chroot cat /etc/os-release
```

#### Enter interactive console inside chroot

```bash
alpine-chroot
```
