# Changelog

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
