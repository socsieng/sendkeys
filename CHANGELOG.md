# Changelog

## [4.1.1](https://github.com/socsieng/sendkeys/compare/v4.1.0...v4.1.1) (2024-10-22)


### Bug Fixes

* **build:** fix broken build ([234b441](https://github.com/socsieng/sendkeys/commit/234b441a210bf038b6cfcd60e9ac691d9dcc0d6c))

## [4.1.0](https://github.com/socsieng/sendkeys/compare/v4.0.4...v4.1.0) (2024-10-22)


### Features

* add argument to terminate execution ([1b8c1f1](https://github.com/socsieng/sendkeys/commit/1b8c1f1aa2ceb9ae666aaa74142df150d7a85b67)), closes [#79](https://github.com/socsieng/sendkeys/issues/79)


### Bug Fixes

* **build:** update macos runners ([2af43cd](https://github.com/socsieng/sendkeys/commit/2af43cda3362757dc1fb2404bd456ae34292e955))
* update package versions ([b1e1319](https://github.com/socsieng/sendkeys/commit/b1e1319259cef524e5c83632eabecdbcd353b0bb))

## [4.0.4](https://github.com/socsieng/sendkeys/compare/v4.0.3...v4.0.4) (2023-10-07)


### Bug Fixes

* **build:** add cache busting parameter ([c2a4f59](https://github.com/socsieng/sendkeys/commit/c2a4f598f0677a0dd490339eddbfaf22083e5b30))

## [4.0.3](https://github.com/socsieng/sendkeys/compare/v4.0.2...v4.0.3) (2023-10-07)


### Bug Fixes

* **build:** ignore errors if archive does not exist ([7f2fc4b](https://github.com/socsieng/sendkeys/commit/7f2fc4b5cd5c865228f5455892d7f1cabdad2612))

## [4.0.2](https://github.com/socsieng/sendkeys/compare/v4.0.1...v4.0.2) (2023-10-07)


### Bug Fixes

* **build:** clean up archives before bottling ([408db73](https://github.com/socsieng/sendkeys/commit/408db7323ab29733552fe7140405804bb4207e51))

## [4.0.1](https://github.com/socsieng/sendkeys/compare/v4.0.0...v4.0.1) (2023-10-07)


### Bug Fixes

* **build:** clean up archives after bottling ([1ef78ed](https://github.com/socsieng/sendkeys/commit/1ef78ed4297d0c69ab1327ed6796fdddda1d2543))

## [4.0.0](https://github.com/socsieng/sendkeys/compare/v3.0.2...v4.0.0) (2023-10-07)


### ⚠ BREAKING CHANGES

* fix handling of key strokes to use shift key when appropriate

### Bug Fixes

* fix handling of key strokes to use shift key when appropriate ([beb535b](https://github.com/socsieng/sendkeys/commit/beb535b2693085cf50bc479276a4d806e55d288c)), closes [#62](https://github.com/socsieng/sendkeys/issues/62)
* fix issue with unspecified application name ([440153d](https://github.com/socsieng/sendkeys/commit/440153d073c10888fd33990197434d9565b430d1))

## [3.0.2](https://github.com/socsieng/sendkeys/compare/v3.0.1...v3.0.2) (2023-10-06)


### Bug Fixes

* introduce a small delay to allow commands to be processed before terminating ([9ffc2b2](https://github.com/socsieng/sendkeys/commit/9ffc2b2a012314d983c7e2a94385747abce8ef24)), closes [#60](https://github.com/socsieng/sendkeys/issues/60)

## [3.0.1](https://github.com/socsieng/sendkeys/compare/v3.0.0...v3.0.1) (2023-10-06)


### Bug Fixes

* update key handling to use keyboardEventSource ([c26bbfa](https://github.com/socsieng/sendkeys/commit/c26bbfaaab700a6063b8fbb967622241595eb5a0))

## [3.0.0](https://www.github.com/socsieng/sendkeys/compare/v2.9.1...v3.0.0) (2023-10-06)


### ⚠ BREAKING CHANGES

* drop support for building on macOS catalina

### Features

* add support for sending keys to an application without activation ([b42d4bc](https://www.github.com/socsieng/sendkeys/commit/b42d4bc347d1800068e8753bc6daa13b255319b2)), closes [#67](https://www.github.com/socsieng/sendkeys/issues/67)


### Bug Fixes

* remove dependency on macos-10.15 ([14aa5a8](https://www.github.com/socsieng/sendkeys/commit/14aa5a82ba2fd34e2fa49d5b749b0fb941d1f902))


### Miscellaneous

* drop support for building on macOS catalina ([8c027cb](https://www.github.com/socsieng/sendkeys/commit/8c027cb14e4ca9bfe1515a41191c1ecfa4499112))

### [2.9.1](https://www.github.com/socsieng/sendkeys/compare/v2.9.0...v2.9.1) (2023-04-15)


### Bug Fixes

* fix homebrew update script ([dac393f](https://www.github.com/socsieng/sendkeys/commit/dac393fe982b7b5ce39a9450277a36b0ea46d58e))

## [2.9.0](https://www.github.com/socsieng/sendkeys/compare/v2.8.0...v2.9.0) (2023-04-15)


### Features

* add support for activating application by process id ([0a44470](https://www.github.com/socsieng/sendkeys/commit/0a4447044d2acddba176db74d9698cbef4dfc872)), closes [#63](https://www.github.com/socsieng/sendkeys/issues/63)

## [2.8.0](https://www.github.com/socsieng/sendkeys/compare/v2.7.1...v2.8.0) (2021-09-01)


### Features

* convert mouse coordinates from integers to doubles ([bbd4534](https://www.github.com/socsieng/sendkeys/commit/bbd45342cf0f1974ed2a2365d386b44b3225841d))
* make scaleY option in path command ([f1fe840](https://www.github.com/socsieng/sendkeys/commit/f1fe8406a13c7abee8844123d0d5aeda903b6620))
* output mouse positions as decimals ([d723082](https://www.github.com/socsieng/sendkeys/commit/d723082a068f4806bad9363098727af287c067d7))


### Documentation

* add sample command for mouse path command ([9c9e6cb](https://www.github.com/socsieng/sendkeys/commit/9c9e6cbe0b4c7ca313116eb4b7966824c681ed17))

### [2.7.1](https://www.github.com/socsieng/sendkeys/compare/v2.7.0...v2.7.1) (2021-08-31)


### Bug Fixes

* remove debug print statements ([5109a12](https://www.github.com/socsieng/sendkeys/commit/5109a12045bb65d18fe570db53c9ce88e6fa4d3d))

## [2.7.0](https://www.github.com/socsieng/sendkeys/compare/v2.6.2...v2.7.0) (2021-08-31)


### Features

* add mouse path command ([6c5c0b9](https://www.github.com/socsieng/sendkeys/commit/6c5c0b9ab5e25d795ee470884a25de2b28d5988d))


### Documentation

* add example animation for mouse path command ([2c49b8d](https://www.github.com/socsieng/sendkeys/commit/2c49b8d16735d60186c1b1c842ff31607ec265bb))

### [2.6.2](https://www.github.com/socsieng/sendkeys/compare/v2.6.1...v2.6.2) (2021-08-22)


### Features

* improve application name matching algorithm ([456586a](https://www.github.com/socsieng/sendkeys/commit/456586a746bea2294fd64db238cf595d9f7bf417)), closes [#50](https://www.github.com/socsieng/sendkeys/issues/50)


### Documentation

* update README to include details on  apps sub command ([40f49be](https://www.github.com/socsieng/sendkeys/commit/40f49bec4ce9574ee7e7ecafafd7facba067f64c))

### [2.6.1](https://www.github.com/socsieng/sendkeys/compare/v2.6.0...v2.6.1) (2021-08-21)


### chore

* bump version ([ee86888](https://www.github.com/socsieng/sendkeys/commit/ee86888368363598d51fbd5b1b49ca59a68ef541))

## [2.6.0](https://www.github.com/socsieng/sendkeys/compare/v2.5.2...v2.6.0) (2021-08-21)


### Features

* display a list applications that can be used with sendkeys ([94626fa](https://www.github.com/socsieng/sendkeys/commit/94626fa39a30b9b51f03548aa0b8dbb62bd5cfb6)), closes [#46](https://www.github.com/socsieng/sendkeys/issues/46)

### [2.5.2](https://www.github.com/socsieng/sendkeys/compare/v2.5.1...v2.5.2) (2021-06-19)


### Bug Fixes

* **build:** remove usage of realpath ([c9019d7](https://www.github.com/socsieng/sendkeys/commit/c9019d7d3ac9a3776b15a50708365de86d6f3b72))

### [2.5.1](https://www.github.com/socsieng/sendkeys/compare/v2.5.0...v2.5.1) (2021-06-19)


### Bug Fixes

* **build:** apply changes to address broken homebrew build ([536603a](https://www.github.com/socsieng/sendkeys/commit/536603a0e4f224ffe87487954318f4b617264e87))

## [2.5.0](https://www.github.com/socsieng/sendkeys/compare/v2.4.0...v2.5.0) (2021-06-18)


### Features

* add option to output mouse position commands with predefined duration ([f662869](https://www.github.com/socsieng/sendkeys/commit/f662869cf207bca9978407758eadef244c9d026f))

## [2.4.0](https://www.github.com/socsieng/sendkeys/compare/v2.3.10...v2.4.0) (2021-03-27)


### Features

* add support for apple m1 processors ([6706f85](https://www.github.com/socsieng/sendkeys/commit/6706f85b340168783ecb5e4fe56bde545c2bf86a))

### [2.3.10](https://www.github.com/socsieng/sendkeys/compare/v2.3.0...v2.3.10) (2021-03-27)


### Documentation

* add example file for using transform ([1a2c8e8](https://www.github.com/socsieng/sendkeys/commit/1a2c8e82cd6b04321aadb78979c73a120d340bf4))
* update readme to include installation instructions for alternate versions ([72030ab](https://www.github.com/socsieng/sendkeys/commit/72030abc018a7bd81e31509ac7085e77620d6528))

## [2.3.0](https://www.github.com/socsieng/sendkeys/compare/v2.2.0...v2.3.0) (2021-01-20)


### Features

* add mouse focus command ([1bbab2d](https://www.github.com/socsieng/sendkeys/commit/1bbab2d0a9377260d892a78cfbc41713064ac736))

## [2.2.0](https://www.github.com/socsieng/sendkeys/compare/v2.1.1...v2.2.0) (2021-01-16)


### Features

* add support for triggering mouse up and down events independently ([bee0fbe](https://www.github.com/socsieng/sendkeys/commit/bee0fbe5032a97fe63090fedf9cc7c9d537f60f6))

### [2.1.1](https://www.github.com/socsieng/sendkeys/compare/v2.1.0...v2.1.1) (2021-01-07)


### Bug Fixes

* fix typo in key mappings ([c4a4997](https://www.github.com/socsieng/sendkeys/commit/c4a4997375c55cc4217c1a381df39ff94d9ff751))
* handle `a` key correctly as keycode 0 ([29209a3](https://www.github.com/socsieng/sendkeys/commit/29209a34a495afdc0028e353ccf1b8375b32f005))

## [2.1.0](https://www.github.com/socsieng/sendkeys/compare/v2.0.0...v2.1.0) (2021-01-06)


### Features

* add option to change animation refresh rate ([73a2c29](https://www.github.com/socsieng/sendkeys/commit/73a2c294a878f9e8e64c14a4b6664ddb1586e13b)), closes [#21](https://www.github.com/socsieng/sendkeys/issues/21)
* add transform subcommand ([3893313](https://www.github.com/socsieng/sendkeys/commit/38933135a3746343d501cd720d4b66f7ee1ac552))


### Bug Fixes

* start mouse timing when mouse-position command is executed ([1437aac](https://www.github.com/socsieng/sendkeys/commit/1437aac909e289a782d16677601a81c49d443d85))
* support negative values for mouse click and drag events ([f50209a](https://www.github.com/socsieng/sendkeys/commit/f50209ae1e8924dbd189a11a6ecad388082c1d17)), closes [#23](https://www.github.com/socsieng/sendkeys/issues/23)


### Documentation

* update documentation to state that the application should be running ([3e0d973](https://www.github.com/socsieng/sendkeys/commit/3e0d9736559d48e45c3287c48830bd743926e3ef))

## [2.0.0](https://www.github.com/socsieng/sendkeys/compare/v1.3.0...v2.0.0) (2021-01-04)


### Features

* use click timings when producing mouse commands ([970e1df](https://www.github.com/socsieng/sendkeys/commit/970e1df52a903c93da62a572edc99caea1ffc1b5)), closes [#18](https://www.github.com/socsieng/sendkeys/issues/18)


### Bug Fixes

* check file exists before activating application ([94cda37](https://www.github.com/socsieng/sendkeys/commit/94cda379c54175e1b59a87633512456b327e63fa)), closes [#17](https://www.github.com/socsieng/sendkeys/issues/17)


### Documentation

* include example recording and replaying mouse commands ([5019461](https://www.github.com/socsieng/sendkeys/commit/501946176dab36189e05b49c6e09800ec3bd77ad)), closes [#19](https://www.github.com/socsieng/sendkeys/issues/19)

## [1.3.0](https://www.github.com/socsieng/sendkeys/compare/v1.2.0...v1.3.0) (2021-01-04)


### Features

* add option to listen to mouse clicks ([d1d129f](https://www.github.com/socsieng/sendkeys/commit/d1d129fed23f969b10bf0475aeb77f9752a4a5bd))


### Documentation

* use expanded argument names in examples ([f4839a3](https://www.github.com/socsieng/sendkeys/commit/f4839a3c027bc78fb13e6f717147f206c3c043d8))

## [1.2.0](https://www.github.com/socsieng/sendkeys/compare/v1.1.1...v1.2.0) (2021-01-03)


### Features

* defer accesibility check to execution of the command ([670d091](https://www.github.com/socsieng/sendkeys/commit/670d091d17100fd9b9cdb74ba0eebf69cae6af51))

### [1.1.1](https://www.github.com/socsieng/sendkeys/compare/v1.1.0...v1.1.1) (2021-01-02)


### Bug Fixes

* address modifier key issue on key up ([0bfa58a](https://www.github.com/socsieng/sendkeys/commit/0bfa58ad87ebcff46b905900584877544a533463))
* double key entry issue ([26ad67e](https://www.github.com/socsieng/sendkeys/commit/26ad67e80aaa30fcd9c2a1bb20f5987288760bbc))

## [1.1.0](https://www.github.com/socsieng/sendkeys/compare/v1.0.0...v1.1.0) (2021-01-02)


### Features

* add support for key down and up commands ([2c5cefb](https://www.github.com/socsieng/sendkeys/commit/2c5cefb28c802dea94d55920c4092b232f50e62e))
* add support for mouse clicks with modifier keys ([1654fd7](https://www.github.com/socsieng/sendkeys/commit/1654fd7217c7588c16c22ff779d26564aee634f9))
* add support for mouse drag with modifier keys ([32964a7](https://www.github.com/socsieng/sendkeys/commit/32964a725312bfa04d203c4b56d3cf20cf237b52))
* add support for mouse move with modifier keys ([7f4c891](https://www.github.com/socsieng/sendkeys/commit/7f4c891be9aed26f37c38d6275247830d9f04b5c))
* add support for mouse scroll with modifier keys ([27afc5b](https://www.github.com/socsieng/sendkeys/commit/27afc5bb7c50b762d4d1333f3c6eeef6b92a8d8d))


### Bug Fixes

* add event source attribution to related events ([d443fdf](https://www.github.com/socsieng/sendkeys/commit/d443fdf6c2e64b8258e76c7a2ea23a94de62a695))
* make right click work consistently across applications ([464a401](https://www.github.com/socsieng/sendkeys/commit/464a401d532ef2afc1cfa6a206d84479aa92888a))
* use click count when triggering mouse click ([f824a98](https://www.github.com/socsieng/sendkeys/commit/f824a98823551c451fcb4e8f6c9196d9fe26b8e6))


### Documentation

* add example of mouse move command ([2470c7b](https://www.github.com/socsieng/sendkeys/commit/2470c7bc56feb207fda2b1f2e39b1377ccf4ffd2))
* **modifier keys:** add documentation for mouse modifier keys ([7c5e9d9](https://www.github.com/socsieng/sendkeys/commit/7c5e9d917d5eb18b003095a8a361e9ac99078826))

## [1.0.0](https://www.github.com/socsieng/sendkeys/compare/v0.5.0...v1.0.0) (2020-12-31)


### Features

* stable release 1.0.0 ([27bcfc6](https://www.github.com/socsieng/sendkeys/commit/27bcfc68bc183b7a0d6e466b32ea619d7eee7aed))


### Bug Fixes

* read file relative to current directory ([49e1253](https://www.github.com/socsieng/sendkeys/commit/49e12537b288a34e7eb3bc060bc513ae36a86a82))


### Miscellaneous

* append newline when raising a fatal error ([b33f495](https://www.github.com/socsieng/sendkeys/commit/b33f495d7c60810cc82a540b920467dd61f8b869))

## [0.5.0](https://www.github.com/socsieng/sendkeys/compare/v0.4.0...v0.5.0) (2020-12-31)


### Features

* add support for scrolling ([b438e00](https://www.github.com/socsieng/sendkeys/commit/b438e0089b947339c935a21ba39c66375dea4b5d))

## [0.4.0](https://www.github.com/socsieng/sendkeys/compare/v0.3.0...v0.4.0) (2020-12-31)


### Features

* add check to see if accessibility permissions have been enabled ([409e0fb](https://www.github.com/socsieng/sendkeys/commit/409e0fbe935113329b1d61cdbe3f2cd186781117))
* add sub command to display the current mouse position ([507f8b8](https://www.github.com/socsieng/sendkeys/commit/507f8b8aa1ccedbee2936295c2d192f1a1c33ede))
* add wait option for mouse-position ([2c0aa8f](https://www.github.com/socsieng/sendkeys/commit/2c0aa8fab484de46b835cc0ec52afc22699f9033))


### Bug Fixes

* display help when no commands supplied ([c3175ba](https://www.github.com/socsieng/sendkeys/commit/c3175ba182ab98831dfbb29afcd2241f6e22cdfc))
* only perform accessibility check if stdin is tty ([6043a78](https://www.github.com/socsieng/sendkeys/commit/6043a784a9f2245bd826b30787d494a687899428))


### Documentation

* add documentation on how to use mouse-position command ([42e9955](https://www.github.com/socsieng/sendkeys/commit/42e9955b4f3efbc2d56c062f85134d17deea68b7))

## [0.3.0](https://www.github.com/socsieng/sendkeys/compare/v0.2.4...v0.3.0) (2020-12-31)


### ⚠ BREAKING CHANGES

* update build step to update homebrew formula

### build

* update build step to update homebrew formula ([5fd8722](https://www.github.com/socsieng/sendkeys/commit/5fd8722409c6b536ec2388db7e99e0dfa6a134ea))

### [0.2.4](https://www.github.com/socsieng/sendkeys/compare/v0.2.3...v0.2.4) (2020-12-31)


### Documentation

* add brew install instructions ([95023b1](https://www.github.com/socsieng/sendkeys/commit/95023b1a8533ab7f2fb6e7ec4f650a312e0ab828))

### [0.2.3](https://www.github.com/socsieng/sendkeys/compare/v0.2.2...v0.2.3) (2020-12-31)


### Bug Fixes

* update bottle name to work with brew ([259c140](https://www.github.com/socsieng/sendkeys/commit/259c14051895c5672f290e2f8f2bf299395e31a4))

### [0.2.2](https://www.github.com/socsieng/sendkeys/compare/v0.2.1...v0.2.2) (2020-12-30)


### Bug Fixes

* **build:** fix bad substitution in sed ([254161e](https://www.github.com/socsieng/sendkeys/commit/254161e567bfb8a8063d0dd8c8b976ec0d2c09da))

### [0.2.1](https://www.github.com/socsieng/sendkeys/compare/v0.2.0...v0.2.1) (2020-12-30)


### Bug Fixes

* **build:** update scripts to handle differences in tag_name ([13fbf6b](https://www.github.com/socsieng/sendkeys/commit/13fbf6bb377ada5becd25399b75e9367cbbc4302))

## [0.2.0](https://www.github.com/socsieng/sendkeys/compare/v0.1.0...v0.2.0) (2020-12-30)


### ⚠ BREAKING CHANGES

* update build step names

### Build System

* update build step names ([4d6a0f4](https://www.github.com/socsieng/sendkeys/commit/4d6a0f476d5331a1d99bfd150dcf88281d0f1dd3))

## [0.1.0](https://www.github.com/socsieng/sendkeys/compare/v0.0.3...v0.1.0) (2020-12-30)


### Features

* add support for reading from stdin ([463d777](https://www.github.com/socsieng/sendkeys/commit/463d7775e1bc11a293917c43e7c00335d2e77404))
