# Changelog

### [2.3.7](https://www.github.com/socsieng/sendkeys/compare/v2.3.6...v2.3.7) (2021-03-27)


### Bug Fixes

* **build:** add checkout step to homebrew job ([14af081](https://www.github.com/socsieng/sendkeys/commit/14af081a03473bf50a2042a7aef3798d5b710b33))

### [2.3.6](https://www.github.com/socsieng/sendkeys/compare/v2.3.5...v2.3.6) (2021-03-27)


### Bug Fixes

* **build:** move uninstall to bottle script ([5bee913](https://www.github.com/socsieng/sendkeys/commit/5bee9138cd1f95fc816fd7e586a659e8b0131e91))

### [2.3.5](https://www.github.com/socsieng/sendkeys/compare/v2.3.4...v2.3.5) (2021-03-27)


### Bug Fixes

* **build:** uninstall brew package after bottling ([3cf4d7d](https://www.github.com/socsieng/sendkeys/commit/3cf4d7d4eb2aa2236065fa0d374d4e18bc501938))

### [2.3.4](https://www.github.com/socsieng/sendkeys/compare/v2.3.3...v2.3.4) (2021-03-26)


### Bug Fixes

* **build:** run bottle.sh with explicit arch flag ([6362ef1](https://www.github.com/socsieng/sendkeys/commit/6362ef154d7e9b6bb69fd04515dcaa6e87cedc7f))

### [2.3.3](https://www.github.com/socsieng/sendkeys/compare/v2.3.2...v2.3.3) (2021-03-26)


### Bug Fixes

* **build:** version bump ([8e64348](https://www.github.com/socsieng/sendkeys/commit/8e64348fa06887583bfeaabdb51a5617624e3dac))

### [2.3.2](https://www.github.com/socsieng/sendkeys/compare/v2.3.1...v2.3.2) (2021-03-26)


### Bug Fixes

* update builds for arm64 macs ([4b37ac7](https://www.github.com/socsieng/sendkeys/commit/4b37ac7ba21e2be64f90632c8a08def052cc6158))

### [2.3.1](https://www.github.com/socsieng/sendkeys/compare/v2.3.0...v2.3.1) (2021-03-26)


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
