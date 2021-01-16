# SendKeys

![Build status](https://github.com/socsieng/sendkeys/workflows/build/badge.svg)
![Homebrew installs](https://img.shields.io/github/downloads/socsieng/sendkeys/total.svg?label=%F0%9F%8D%BA+installs&labelColor=32393F&color=brightgreen)

SendKeys is a macOS command line application used to automate the keystrokes and mouse events.

It is a great tool for automating input and mouse events for screen recordings.

This is a Swift rewrite of [`sendkeys-macos`](https://github.com/socsieng/sendkeys-macos).

## Usage

Basic usage:

```sh
sendkeys --application-name "Notes" --characters "Hello<p:1> world<c:left:option,shift><c:i:command>"
```

![hello world example](https://github.com/socsieng/sendkeys/raw/main/docs/images/example1.gif)

_Activates the Notes application (assuming Notes is already running) and types `Hello` (followed by a 1 second pause)
and `world`, and then selects the word `world` and changes the font to italics with `command` + `i`._

Input can be read from a file:

```sh
sendkeys --application-name "Code" --input-file example.txt
```

_Activates Visual Studio Code and sends keystrokes loaded from `example.txt`._

Input can also be piped to `stdin`:

```sh
cat example.txt | sendkeys --application-name "Notes"
```

_Activates the Notes application and sends keystrokes piped from `stdout` of the preceeding command._

## Installation

### Homebrew (recommended)

Install using [homebrew](https://brew.sh/):

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

Most printable characters will be sent as keystrokes to the active application. Support for additional instructions is
provided by some basic markup which is unlikely to be used in other markup languages to avoid conflicts.

### Key codes and modifier keys

Support for special key codes and modifier keys is provided with the following markup structure: `<c:key[:modifiers]>`

- `key` can include any printable character or, one of the following key names: `f1`, `f2`, `f3`, `f4`, `f5`, `f6`,
  `f7`, `f8`, `f9`, `f10`, `f11`, `f12`, `esc`, `return`, `enter`, `delete`, `space`, `tab`, `up`, `down`, `left`,
  `right`, `home`, `end`, `pgup`, and `pgdown`. See list of
  [mapped keys](https://github.com/socsieng/sendkeys/blob/main/Sources/SendKeysLib/KeyCodes.swift#L127) for a full list.
- `modifiers` is an optional list of comma separated values that can include `command`, `shift`, `control`, and
  `option`.

Example key combinations:

- `tab`: `<c:tab>`
- `command` + `a`: `<c:a:command>`
- `option` + `shift` + `left arrow`: `<c:left:option,shift>`

#### Key down and up

Some applications expect modifier keys to be pressed explicitly before invoking actions like mouse click. An example of
this is Pixelmator which expect the `option` key to be pressed before executing the alternate click action. This can be
achieved with key down `<kd:key[:modifiers]>` and key up `<ku:key[:modifiers]>`.

Note that these command shoulds only be used in these special cases when the mouse action and modifier keys are not
supported natively.

An example of how to trigger alternate click behavior in Pixelmator as described above:
`<kd:option><m:left:option><ku:option>`.

### Mouse commands

#### Move mouse cursor

The mouse cursor can be moved using the following markup: `<m:[x1,y1,]x2,y2[:duration][:modifiers]>`

- `x1` and `y1` are optional x and y coordinates to move the mouse from. Defaults to the current mouse position.
- `x2` and `y2` are x and y coordinates to move the mouse to. These values are required.
- `duration` is optional and determines the number of seconds (supports partial seconds) that should be used to move the
  mouse cursor (larger number means slower movement). Defaults to `0`.
- `modifiers` is an optional list of comma separated values that can include `command`, `shift`, `control`, and
  `option`.

Example usage:

- `<m:400,400:0.5>`: Move mouse cursor from current position to 400, 400 over 0.5 seconds.
- `<m:400,400,0,0:2>`: Move mouse cursor from 400, 400 position to 0, 0 over 2 seconds.
- `<m:400,400>`: Move mouse cursor to 400, 400 instantly.

```sh
sendkeys -c "<m:100,300,300,300:0.5><p:0.5><m:100,300:0.5>"
```

![mouse move example](https://github.com/socsieng/sendkeys/raw/main/docs/images/mouse.gif)

#### Mouse click

A mouse click can be activated using the following markup: `<m:button[:modifiers][:clicks]>`

- `button` is required and refers to the mouse button to click. Supported values include `left`, `center`, and `right`.
- `modifiers` is an optional list of comma separated values that can include `command`, `shift`, `control`, and
  `option`.
- `clicks` is optional and specifies the number of times the button should be clicked. Defaults to `1`.

Example usage:

- `<m:right>`: Right mouse click at the current mouse location.
- `<m:left:2>`: Double click the left button at the current mouse location.

#### Mouse drag

A mouse drag be initiated with: `<d:[x1,y1,]x2,y2[:duration][:button[:modifiers]]>`

The structure argument structure is similar to moving the mouse cursor.

- `x1` and `y1` are optional x and y coordinates to start the drage. Defaults to the current mouse position.
- `x2` and `y2` are x and y coordinates to end the drag. These values are required.
- `duration` is optional and determines the number of seconds (supports partial seconds) that should be used to drag the
  mouse (larger number means slower movement). Defaults to `0`.
- `button` is optional and refers to the mouse button to use when initiating the mouse drag. Supported values include
  `left`, `center`, and `right`. Defaults to `left`.
- `modifiers` is an optional list of comma separated values that can include `command`, `shift`, `control`, and
  `option`. Note that modifiers can only be used if `button` is explicitly set.

Example usage:

- `<d:400,400:0.5>`: Drag the mouse using the left mouse button from current position to 400, 400 over 0.5 seconds.
- `<d:400,400,0,0:2:right>`: Drag the mouse using the right mouse button from 400, 400 position to 0, 0 over 2 seconds.
- `<d:400,400:2:left:shift>`: Drag the mouse using the left mouse button to 400, 400 over 2 seconds with the `shift` key
  down.

![mouse drag example](https://github.com/socsieng/sendkeys/raw/main/docs/images/mouse-drag.gif)

#### Mouse scrolling

A mouse scroll can be initiated with: `<s:x,y[:duration][:modifiers]>`

- `x` is required and controls horizontal scrolling. Positive values scroll to the right, while negative values scroll
  to the left.
- `y` is required and controls vertical scrolling. Positive values scroll down, while negative values scroll up.
- `duration` is optional and determines the number of seconds (supports partial seconds) that should be used to drag the
  mouse (larger number means slower movement). Defaults to `0`.
- `modifiers` is an optional list of comma separated values that can include `command`, `shift`, `control`, and
  `option`.

Example usage:

- `<s:0,400:0.5>`: Scrolls down 400 pixels over 0.5 seconds.
- `<s:0,-100:0.2>`: Scrolls up 400 pixels over 0.2 seconds.
- `<s:100,0>`: Scrolls 100 pixel to the right instantly.

#### Mouse down and up

Mouse down and up events can be used to manually initiate a drag event or multiple mouse move commands while the mouse
button is down. This can be achieved with mouse down `<md:button[:modifiers]>` and mouse up `<mu:button[:modifiers]>`.

Note that the drag command is recommended for basic drag functionality..

An example of how include multiple mouse movements while the mouse button is down:
`<md:left><m:0,0,100,0:1><m:100,100:1><mu:left>`.

### Pauses

The default time between keystrokes and instructions is determined by the `--delay`/`-d` argument (default value is
`0.1`). Pauses can be customized with: `<p:duration>`

- `duration` is required and controls the amount of time to pause before the next keystroke/instruction is executed.

`<P:seconds>` (note upper case `P`) can be used to modify the default delay between subsequent keystrokes.

### Continuation

A continuation can be used to ignore the next keystroke or instruction. This is useful to help with formatting a long
sequence of character and inserting a new line for readability.

Insert a continuation using the character sequence `<\>`. The following instruction the sequence will be skipped over
(including another continuation).

## Transforming text for text editors

Some text editors like Visual Studio Code will automatically indent or insert closing brackets which can cause
duplication of whitespace and characters. The `transform` subcommand can help transform text files for better
compatibility with similar text editors.

Example:

```sh
sendkeys transform --input-file example.js
```

You can also pipe the output of the `transform` command directly to your editor of choice. Example:

```sh
sendkeys transform --input-file example.js | sendkeys --application-name "Code"
```

## Retrieving mouse position

The `mouse-position` sub command can be used to help determine which mouse coordinates to use in your scripts.

For a one off read, move your mouse to the desired position, switch to your terminal app using `command` + `tab` and
execute the following command:

```sh
sendkeys mouse-position
```

Use the `--watch` option to capture the location of mouse clicks, and combine it with `--output commands` to output
approximate mouse commands that can be used to _replay_ mouse actions.

```sh
# capture mouse commands
sendkeys mouse-position --watch --output commands > mouse_commands.txt

# replay mouse commands
sendkeys --input-file mouse_commands.txt
```

## Prerequisites

This application will only run on macOS 10.11 or later.

When running from the terminal, ensure that the terminal has permission to use accessibility features. This can be done
by navigating to System Preferences > Security & Privacy > Privacy > Accessibility and adding your terminal application
there.

![accessibility settings](https://github.com/socsieng/sendkeys/raw/main/docs/images/accessibility.gif)
