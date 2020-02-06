# Spliterminal

## The terminal of the 21st century.

A super lightweight, beautiful, and simple terminal thats can be splited like DeepinTerminal.

![Terminal Screenshot](data/screenshot.png?raw=true)

## Building, Testing, and Installation

You'll need the following dependencies:
* libgranite-dev >= 5.3.0
* libvte-2.91-dev
* meson
* valac

Run `meson` to configure the build environment and then `ninja test` to build and run tests

    meson build --prefix=/usr
    cd build
    ninja test

To install, use `ninja install`, then execute with `io.elementary.terminal`

    sudo ninja install
    com.github.msmaldi.spliterminal

## Usage

* alt + (number): for stack switch
* Ctrl + Alt + h: Split HORIZONTAL continue focus in current terminal
* Ctrl + Alt + j: Split VERTICAL focus in new terminal
* Ctrl + Alt + k: Split VERTICAL continue focus in current terminal
* Ctrl + Alt + l: Split HORIZONTAL focus in new terminal

Navigate like vi:

* Alt + h: Focus in left terminal
* Alt + j: Focus in down terminal
* Alt + k: Focus in up terminal
* Alt + l: Focus in right terminal