# *SkiFree* in Docker

## What is it?

The classic 90s game [**SkiFree**](https://en.wikipedia.org/wiki/SkiFree) running in [WINE](https://www.winehq.org) via X from your host Linux system.

![The Yeti that eats you.](https://github.com/darkvertex/docker-skifree/raw/master/images/skifree_yeti_gobble.gif)

## How to Run

To run the [Dockerhub image](https://hub.docker.com/r/alanf/skifree-wine), you will need to pass your `$DISPLAY` env var, match your user ID and mount your X socket, like so:

```bash
docker run -it --rm -e DISPLAY=$DISPLAY --user `id -u` -v="/tmp/.X11-unix:/tmp/.X11-unix" alanf/skifree-wine
```

## Which version of the game is this?

It runs [the _most officialest_ 32bit build](http://ski.ihoc.net/) from the original website.

## But... why?!

_I was so preoccupied with whether I could, that I didn't stop to think if I should..._

Kidding aside, unlike the original from Windows 3.1 (that you can still run [in DOSBOX online](https://classicreload.com/win3x-skifree.html)), this one scales to the biggest your screen can fit.

Here it is running in my laptop's high-DPI display at glorious 1792x1696 resolution:

![start screen](https://github.com/darkvertex/docker-skifree/raw/master/images/skifree_hd_screenshot1.png)

and in action:

![skiing](https://github.com/darkvertex/docker-skifree/raw/master/images/skifree_hd_screenshot2.png)

## Can I escape the Yeti?!

[Yes](https://youtube.com/watch?v=qf3p0WGS5mc), it's possible.

![xkcd](https://imgs.xkcd.com/comics/skifree.png)

**Escape** the Yeti by **traveling another 2000 m from the point at which the monster gives chase**, creating a loop and starting over from the beginning.

One way to evade it is to go directly left or right in _fast mode_ with the "F" key. He is right behind you, but cannot catch you unless you hit an obstacle.

## I'm on Windows, how do I run this?

You're on Windows?? Dude, you don't need WINE.. You don't even need Docker!

Just run the actual [executable](http://ski.ihoc.net/ski32.exe).

## But I love WSL (Windows Subsystem for Linux), can I run this there anyway? You know, for science!

Okay, sure. Just remember **WSL1 and WSL2 don't have GPU acceleration** so don't expect great framerates.

1. You can install an X server, such as "[GWSL](https://www.microsoft.com/en-us/p/gwsl/9nl6kd1h33v3)" (free from the Windows Store.)

2. Once it's running, add this to your `~/.bashrc` to expose your `DISPLAY`:
```shell
# WSL [Windows Subsystem for Linux] customizations:
if [[ $(grep microsoft /proc/version) ]]; then
    # If we are here, we are under WSL:
    if [ $(grep -oE 'gcc version ([0-9]+)' /proc/version | awk '{print $3}') -gt 5 ]; then
        # WSL2
        [ -z $DISPLAY ] && export DISPLAY=$(cat /etc/resolv.conf | grep nameserver | awk '{print $2}'):0.0
    else
        # WSL1
        [ -z $DISPLAY ] && export DISPLAY=127.0.0.1:0.0
    fi
fi
```
3. Log out and back in from a fresh terminal.
4. X forwarding should work now. Go on and try `xeyes` or the full skifree command from the top of this README.

If you succeeded, good job! You now made a 32bit Windows exe run in a Linux container from inside a Linux Windows subsystem. (You crazy maniac, you!)

## But really, why did you make this?

I was reading about X forwarding in Docker containers and wanted to put it to practice.

This exercise taught me that `--user` in `docker run` with your own user ID lets you tap into your active X session easily without file ownership issues or X security errors.

---

Enjoy! (and don't let the Yeti get ya!!)
