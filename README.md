Build a docker image with all the tools required to compile usbemani firmware for the mini-5.

```
docker build . -t usbemani-mini-5
```

OR 

```
docker pull saitnoodle/usbemani-mini-5:latest
```

Then clone usbemani

```
git clone https://github.com/ribbondev/usbemani
```

Example usage:

```
# pwsh
docker run --rm -it -v "${PWD}:/usbemani" -w /usbemani usbemani-toolchain make default/lain/mini-5
```

```
# bash
docker run --rm -it -u $(id -u):$(id -g) -v "$(pwd)":/usbemani -w /usbemani usbemani-toolchain make default/lain/mini-5
```