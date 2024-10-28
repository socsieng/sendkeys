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

_Activates the Notes application and sends keystrokes piped from `stdout` of the preceding command._

### Arguments

- `--application-name <application-name>`: The application name to activate or target when sending commands. Note that a
  list of applications that can be used in `--application-name` can be found using the
  [`apps` sub command](#list-of-applications-names).
- `--pid <process-id>`: The process id of the application to target when sending commands. Note that this if this
  argument is supplied with `--application-name`, `--pid` takes precedence.
- `--targeted`: If supplied, the application keystrokes will only be sent to the targeted application.
- `--no-activate`: If supplied, the specified application will not be activated before sending commands.
- `--input-file <file-name>`: The path to a file containing the commands to send to the application.
- `--characters <characters>`: The characters to send to the application. Note that this argument is ignored if
  `--input-file` is supplied.
- `--delay <delay>`: The delay between keystrokes and instructions. Defaults to `0.1` seconds.
- `--initial-delay <initial-delay>`: The initial delay before sending the first keystroke or instruction. Defaults to
  `1` second.
- `--animation-interval <interval-in-seconds>`: The time between mouse movements when animating mouse commands. Lower
  values results in smoother animations. Defaults to `0.01` seconds.
- `--terminate-command <command>`: The command that should be used to terminate the application. Not set by default.
  Follows a similar convention to `--characters`. (e.g. `f12:command,shift`).
- `--keyboard-layout <layout>`: Use alternate keyboard layout. Defaults to `qwerty`. `colemak` and `dvorak` are also
  supported, pull requests for other common keyboard layouts may be considered. If a specific keyboard layout is not
  supported, a custom layout can be defined in the [`~/.sendkeysrc.yml`](./examples/.sendkeysrc.yml) configuration file
  (`send.remap`).

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
- `modifiers` is an optional list of comma separated values that can include `command`, `shift`, `control`, `option`,
  and `function`.

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

![mouse move example](https://github.com/socsieng/sendkeys/raw/main/docs/images/mouse.gif) <br>_Sample command:
`sendkeys -c "<m:100,300,300,300:0.5><p:0.5><m:100,300:0.5>"`_

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

The argument structure is similar to moving the mouse cursor.

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

#### Mouse focus

The mouse focus command can be used to draw attention to an area of the screen by moving the cursor in a circular
pattern. The mouse focus command uses the following markup:
`<mf:centerX,centerY:radiusX[,radiusY]:angleFrom,angleTo:duration>`

- `centerX` is required and represents the center x coordinate of the circular path.
- `centerY` is required and represents the center y coordinate of the circular path.
- `radiusX` is required and represents the size of the radius along the x axis of the circular path.
- `radiusY` is optional and represents the size of the radius along the y axis of the circular path. If omitted,
  `radiusX` will be used indicating that the circular path will be a regular circle. An elipse can be achieved by having
  different values for `radiusX` and `radiusY`.
- `angleFrom` is required and represents the start angle/position of the circular path. Angle is defined using degrees
  where `0` represents 12 o'clock on an analog clock, and positive are applied in a clockwize direction. (e.g. 90
  degrees is 3 o'clock).
- `angleTo` is required and represents the end angle/position of the circular path.
- `duration` is required and determines the number of seconds (supports partial seconds) used to complete the animation
  between `angleFrom` to `angleTo`.

Example usage:

- `<mf:1000,200:50,20:180,900:2>`: Draws attention to position 1000, 200 by moving the mouse along an eliptical 50
  pixels wide by 20 pixels high starting at the bottom (180 degrees) to 900 degrees (delta of 720 degrees) over a period
  of 2 seconds.

![mouse focus example](https://github.com/socsieng/sendkeys/raw/main/docs/images/mouse-focus.gif)

#### Mouse path

The mouse path command can be used move the mouse cursor along a path. The mouse path command uses the following markup:
`<mpath:path[:ofssetX,offsetY[,scaleX[,scaleY]]]:duration>`

- `path` is required and defines path for the mouse cursor to follow. The path is described using
  [SVG Path data](https://www.w3.org/TR/SVG/paths.html#PathData)
- `ofssetX` and `offsetY` are optional and can be used to offset path coordinates by their respective `x` and `y`
  values. Defaults to `0,0`.
- `scaleX` and `scaleY` are also optional and can be used to scale path coordinates by their respective `x` and `y`
  values. Defaults to `1,1`. If `scaleY` is omitted while `scaleX` is provided, a uniform scale will be assumed. i.e.
  `x` = `y`.
- `duration` is required and determines the number of seconds (supports partial seconds) used to complete the animation
  along the `path`.

Example usage:

- `<mpath:c0,40 200,40 200,0:2>`: Moves the mouse from its current position along a cubic bezier path with control
  points `0,40` and `200,40` to the final position of `200,1`.

![mouse path example](https://github.com/socsieng/sendkeys/raw/main/docs/images/mouse-path.gif) <br>_Sample command:
`sendkeys -c "<mpath:M100,100 h 100 l5,30 10,-60 5,30 h 100:2><mpath:c0,40 -220,40 -220,0:1.5>"`_

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
sendkeys transform --input-file examples/node.js
```

You can also pipe the output of the `transform` command directly to your editor of choice. Example:

```sh
sendkeys transform --input-file examples/node.js | sendkeys --application-name "Code"
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

## List of applications names

A list of the current applications that can be activated by SendKeys (`--application-name`) can be displayed using the
`apps` command.

```sh
# list apps that can be activated with --application-name
sendkeys apps
```

Sample output:

```text
Code             id:com.microsoft.VSCode
Finder           id:com.apple.finder
Google Chrome    id:com.google.Chrome
Safari           id:com.apple.Safari
```

The first column includes the application name and the second column includes the application's bundle ID.

SendKeys will use `--application-name` to activate the first application instance that matches either the application
name or bundle id (case insensitive). If there are no exact matches, it will attempt to match on whole words for the
application name, followed by the bundle id.

## Configuration

Common arguments can be stored in the [`~/.sendkeysrc.yml`](./examples/.senkeysrc.yml) configuration file. Configuration
values are applied in the following priority order:

1. Command line arguments
2. Configuration file
3. CLI default values

## Prerequisites

This application will only run on macOS 10.11 or later.

When running from the terminal, ensure that the terminal has permission to use accessibility features. This can be done
by navigating to System Preferences > Security & Privacy > Privacy > Accessibility and adding your terminal application
there.

![accessibility settings](https://github.com/socsieng/sendkeys/raw/main/docs/images/accessibility.gif)

## Installing previous versions

A specific version of the package can be installed by targeting the appropriate release artifact. Here's an example of
the command:

```sh
brew install --force-bottle https://github.com/socsieng/sendkeys/releases/download/v2.3.0/sendkeys-2.3.0.catalina.bottle.tar.gz
```
