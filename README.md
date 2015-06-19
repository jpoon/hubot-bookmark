# hubot-bookmark

[![npm version](http://img.shields.io/npm/v/hubot-bookmark.svg)](https://www.npmjs.org/package/hubot-bookmark)
[![Build Status](http://img.shields.io/travis/jpoon/hubot-bookmark.svg)](https://travis-ci.org/jpoon/hubot-bookmark)

## Wat
Manage bookmarks with Hubot. Bookmarks get stored in the robot brain.

## Installation

In hubot project repo, run:

```bash
$ npm install hubot-bookmark--save
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
