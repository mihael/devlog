[![Build Status](https://travis-ci.org/mihael/devlog.svg?branch=master)](https://travis-ci.org/mihael/devlog)

devlog
======

the headless standup programmer's development log writing tool

structure
=========

a devlog consists of many coding or communication sessions.

the current development session is written at the top of the file.

older sessions are towards the end of the file.

the first session is the one at the bottom, scroll down at the end of the file.

sessions are separated with beginning and end "devlog DSL" entries,

these must be entered at the start of the line.

how to write?
=============

like a book, top down, but always start a new session on top of the file, so that Your customer sees the latest entry there.

devlog DSL
==========


#DD.MM.YYYY HH:MM:SS CodingSession::END

devlog text...

#DD.MM.YYYY HH:MM:SS CodingSession::BEGIN

using the devlog binary
===================

to parse a devlog file explicitly:

`devlog /path/devlog_file.markdown`

to run in current folder (default), expecting file `devlog.markdown` to be present in it:

`devlog`

run in current folder and start coding session:

`devlog b`

run in current folder and stop coding session:

`devlog e`

run in current folder and check session status:

`devlog s`

run in current folder and commit to git repo (if any):

`devlog commit`

run in current folder and push to git repo:

`devlog push`

run in current folder and write out info.markdown then commit&push git repo:

`devlog save`

this one is nice for pushing to a github project, since the CEO can now read the devlog inside a special git branch. the branch should contain only the devlog. one can check out two copies of the git project and have the devlog branch always open in one, while working on code in the other.

run in current folder and write out info.markdown, copy devlog to README.markdown so it is rendered on github project/branch frontpage, then commit&push git repo:

`devlog saver`

settings
========

currently only `devlog_file` can be configured. it represents the location of the devlog text file.

the settings file is called `.devlog.yml`.

it can be placed into a project folder from where one wants to be able to call `devlog`.

example settings `.devlog.yml`:

```
devlog_file: ../info/devlog.markdown
```

the file path should be relative to `.devlog.yml`.