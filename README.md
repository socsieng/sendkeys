# SendKeys

SendKeys is a macOS command line application used to automate the keystrokes and mouse events.

It is a great tool for automating input and mouse events for screen recordings.

This is a Swift rewrite of [`sendkeys-macos`](https://github.com/socsieng/sendkeys-macos).

## Usage

Basic usage:

```sh
sendkeys -a "Notes" -c "Hello<p:1> world<c:left:option,shift><c:i:command>"
```

![hello world example](https://github.com/socsieng/sendkeys-macos/raw/master/docs/example1.gif)

_Activates the Notes application and types `Hello` (followed by a 1 second pause) and `world`, and then selects the word `world` and changes the font to italics with `command` + `i`._

Input can be read from a file:

```sh
sendkeys -a "Code" -f example.txt
```

_Activates Visual Studio Code and sends keystrokes loaded from `example.txt`._

Input can also be piped to `stdin`:

```sh
cat example.txt | sendkeys -a "Notes"
```

_Activates the Notes application and sends keystrokes piped from `stdout` of the preceeding command._

## Installation

### Homebrew

Recommended: Install using [homebrew](https://brew.sh/):

```sh
brew install socsieng/tap/sendkeys
```

### Manual installation

Alternatively, install from source:

```sh
git clone https://github.com/socsieng/sendkeys.git
cd sendkeys
make install
```

## Markup

Most printable characters will be sent as keystrokes to the active application. Support for additional instructions is provided by some basic markup which is unlikely to be used in other markup languages to avoid conflicts.

### Key codes and modifier keys

Support for special key codes and modifier keys is provided with the following markup structure: `<c:key[:modifiers]>`

- `key` can include any printable character or, one of the following key names: `f1`, `f2`, `f3`, `f4`, `f5`, `f6`, `f7`,
  `f8`, `f9`, `f10`, `f11`, `f12`, `esc`, `return`, `enter`, `delete`, `space`, `tab`, `up`, `down`, `left`, `right`,
  `home`, `end`, `pgup`, and `pgdown`. See list of [mapped keys](https://github.com/socsieng/sendkeys/blob/main/Sources/SendKeysLib/KeyCodes.swift#L127) for a full list.
- `modifiers` is an optional list of comma separated values that can include `command`, `shift`, `control`, and `option`.

Example key combinations:

- `tab`: `<c:tab>`
- `command` + `a`: `<c:a:command>`
- `option` + `shift` + `left arrow`: `<c:left:option,shift>`

### Mouse commands

#### Move mouse cursor

The mouse cursor can be moved using the following markup: `<m:[x1,y1,]x2,y2[:duration]>`

- `x1` and `y1` are optional x and y coordinates to move the mouse from. Defaults to the current mouse position.
- `x2` and `y2` are x and y coordinates to move the mouse to. These values are required.
- `duration` is optional and determines the number of seconds (supports partial seconds) that should be used to move the mouse cursor (larger number means slower movement). Defaults to `0`.

Example usage:

- `<m:400,400:0.5>`: Move mouse cursor from current position to 400, 400 over 0.5 seconds
- `<m:400,400,0,0:2>`: Move mouse cursor from 400, 400 position to 0, 0 over 2 seconds
- `<m:400,400>`: Move mouse cursor to 400, 400 instantly

#### Mouse click

A mouse click can be activated using the following markup: `<m:button[:clicks]>`

- `button` is required and refers to the mouse button to click. Supported values include `left`, `center`, and `right`.
- `clicks` is optional and specifies the number of times the button should be clicked. Defaults to `1`.

Example usage:

- `<m:right>`: Right mouse click at the current mouse location
- `<m:left:2>`: Double click the left button at the current mouse location

#### Mouse drag

A mouse drag be initiated with: `<d:[x1,y1,]x2,y2[:duration][:button]>`

The structure argument structure is similar to moving the mouse cursor.

- `x1` and `y1` are optional x and y coordinates to start the drage. Defaults to the current mouse position.
- `x2` and `y2` are x and y coordinates to end the drag. These values are required.
- `duration` is optional and determines the number of seconds (supports partial seconds) that should be used to drag the mouse (larger number means slower movement). Defaults to `0`.
- `button` is optional and refers to the mouse button to use when initiating the mouse drag. Supported values include `left`, `center`, and `right`. Defaults to `left`.

Example usage:

- `<d:400,400:0.5>`: Drag the mouse using the left mouse button from current position to 400, 400 over 0.5 seconds
- `<d:400,400,0,0:2:right>`: Drag the mouse using the right mouse button from 400, 400 position to 0, 0 over 2 seconds

### Pauses

The default time between keystrokes and instructions is determined by the `--delay`/`-d` argument (default value is `0.1`). Pauses can be customized with: `<p:duration>`

- `duration` is required and controls the amount of time to pause before the next keystroke/instruction is executed.

`<P:seconds>` (note upper case `P`) can be used to modify the default delay between subsequent keystrokes.

### Continuation

A continuation can be used to ignore the next keystroke or instruction. This is useful to help with formatting a long sequence of character and inserting a new line for readability.

Insert a continuation using the character sequence `<\>`. The following instruction the sequence will be skipped over (including another continuation).

## Prerequisites

This application will only run on macOS 10.11 or later.

When running from the terminal, ensure that the terminal has permission to use accessibility features. This can be done by
navigating to System Preferences > Security & Privacy > Privacy > Accessibility and adding your terminal application
there.
