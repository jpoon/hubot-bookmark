[![Build Status](http://img.shields.io/travis/jpoon/hubot-bookmark.svg)](https://travis-ci.org/jpoon/hubot-bookmark)

# hubot-bookmark

Manage bookmarks with Hubot. Bookmarks get stored in the robot brain.

## Installation

In the hubot project repo, run:

```bash
$ npm install hubot-bookmark --save
```

Then add **hubot-bookmark** to your `external-scripts.json`:

```json
["hubot-bookmark"]
```

## Usage

```bash
$ hubot bookmark add <url> as <description>
$ hubot bookmark find <description>
$ hubot bookmark list
```
