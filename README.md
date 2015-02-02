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

run in current folder and push to git repo (if any):

`devlog push`

run in current folder and commit&push git repo (if any):

`devlog save`

