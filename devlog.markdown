
#02.02.2015 17:53:20 CodingSession::END

cleaning up a little... enhancing the devlog executable features...

if You now put Your devlog.markdown under git, You can simply go to Your devlog dir and say: devlog save, and it will commit and push the git repository with default message: "devlog".

getting this: /Users/mihael/.rvm/gems/ruby-2.2.0@devlog/gems/activesupport-3.2.16/lib/active_support/values/time_zone.rb:270: warning: circular argument reference - now ... [which is obviously related to this](https://github.com/rails/rails/issues/18201)

next time ii work on this code want to also get rid of activesupport dependency... for now changed the gem required version in the Gemfile...

releasing a minor new version...

#02.02.2015 11:04:30 CodingSession::BEGIN

#15.08.2014 19:14:21 CodingSession::END

adding some nice stuff... can now see negative and zero sessions, which are basically error entries with zero or negative time.

line numbers are recorded, and printed next to the zero and negative sessions...

running 'devlog' in a folder where there is a devlog.markdown file present, it will attempt to parse and present info...

improved the output...

0.0.3 it is

#15.08.2014 16:35:49 CodingSession::BEGIN

#03.02.2014 21:02:30 CodingSession::END

added some tests, and some new calculations, the devlog binary prints out better stats... 0.0.1 it is.

#03.02.2014 09:37:36 CodingSession::BEGIN

#02.02.2014 17:06:00 CodingSession::END

experiencing some bad weather, which took down an optical cable and cut our village off the internet grid...
which is always a good time to do an open source coding session. 

ii added new folder "sublime_text". it will hold everything Sublime Text snippets and commands, which make working with the devlog DSL a breeze. that said, ii feel like a marketeer, haha.

ii added this command "tu.py". which ii use the most, to insert a date time entry into the devlog, like this one #02.02.2014 14:03:35.
You can attach it to Your favourite key binding, ii usually use "ctrl+alt+t".

to install a command, drop it into 

	/Users/You/Library/Application Suport/Sublime Text 3/Packages/User/

ii added a TextMate bundle, which can be installed for Sublime Text as well. it contains these snippets:

	begin+Tab : CodingSession::BEGIN
	combegin+Tab:  ComSession::BEGIN
	end+Tab:  CodingSession::END
	comend+Tab:  ComSession::END
	selfbegin+Tab:  SelfSession::BEGIN
	selfend+Tab:  SelfSession::END

and the last one should work in TextMate to insert time:

	tu+Tab: #`date '+%d.%m.%Y %H:%M:%S'` 

the tmbundle can be dropped in the same folder as the "tu.py" snippet.

just realized, the date format could be something that one would want to configure to its liking... so how would ii code that? 
the snippets would have to be adjusted as well, and the parsing method would have to read some setting from somewhere. which ii dislike very much at this moment, so let me postpone this idea for someone else or some other time...

currently the parser is amazingly simple, written in a very very very short time. and it can stay like that, the devlog only needs to parse its own DSL entries from the devlog file. what ii want to to now is to extend the current code to load each coding session as a separate object, then ii want to see how much time per day, per week... and so on...

ii am in the process of learning to test ruby code, ii started doing this some time ago on my professional projects and it definitely feels very nice, have to practice more, so let me test-code the devlog and have some fun, while the internet is down and my professional life does not exist at all in this moment :).

coding... kids building lego rifles, little fast cars and minifigs...

man, ii really have to think hard to not do it old school, to not simply stare at the code and stare and stare, until ii see it and simply write it down. this time, ii have to just ask questions about the functionality, then we will stare. so the first question is, what do ii want to know:

+ how much ii coded per day in hours (this is a sum/n(sum) value) 
+ how much ii coded per week in hours
+ how much ii coded per month in hours

alright! that's nice, so let me add three test methods and write the expectations...

done at #02.02.2014 14:55:46:

	4 tests, 12 assertions, 0 failures, 3 errors, 0 skips

now all ii need to do is make these three methods pass, easy, and no staring at the code yet :).
kids are still playing... haha...

ii added an empty devlog, to test that too... it should not give any results other than Zero...

this works out of the box, 

	4 tests, 15 assertions, 0 failures, 3 errors, 0 skips

now let me see, how to implement per_day...

ii already know, ii need to keep the whole dataset of datetimes of coding session beginnings and endings somewhere in the Mind, so that ii can ... wait let me first take a look at the code... let me imeplement those methods, before ii begin any mystical thinkings, starings and so forth, let the mystery reveal itself, without me having to think a single thought... staring is thinking, isn't it... deep thinkins are not for prograamming goods... haha...

obviously the parse_devlog method returns the Tajm object, so that is where the methods belong to... for now, ... how long is now? usually not much...

ii have the methods implemented at #02.02.2014 15:10:01 and am about to run the test again... the darn thing still fails!  :) and the methods are simply empty now, so let's make the tests pass by returning what, more than zero... ii would need to know exactly the hours and the some testing... so let me do something funky... 

ii adedd parse_devlog_now, which will be developed as the new thing, while parse_devlog will be used as reference, to get the reference time and compare for validity.

also, this morning, ii discovered ii am unable to install gems under ruby 1.8.7 after installing that with rvm on 10.9 OSX, soo ii will add some more code to the binary script, to enable me to push this devlog to a github or any git repo actually and have the summary of the devlog parse inserted before pushing. it just requires some more commands to be implemented and some more parsing... 

anyway... ii don't see any other way but to code another class...

ii called it Zezzion.

since ii would need to store each sessions begin and end, to be able to fetch only the hours between those dates that are in a day or in a week or month...

ii added class Parsing, to better express the needed calucaltions...

each Parsing represents one parsing, and holds an array of sessions read from the devlog file, these are called @zezzions.

and the kids are playing zombies, while the internets are still hovering somewhere, winter times came late...

let me add 
-9000h 

of communication hours to this devlog, so that tests can be written...

and start a new session higher up, after ii take some breaths...

as text gets written down, at the end of the session ii scroll to the top again and insert the ending command.

#02.02.2014 13:53:37 CodingSession::BEGIN

#19.01.2014 13:54:16 CodingSession::END

adding some simple testing :)

the devlog is always written in real time, 

it starts and stops the coding session, 

ii begin coding by entering begin+Tab inside Sublime Text,
this gives me CodingSession::BEGIN,
then ii type ctrl+alt+T and ii get the current date time inserted like this: #19.01.2014 13:48:44
when ii am done with work ii simly enter end+Tab and CodingSessin::END is inserted...

it is a very simple proces, quick to do, the file is always in the editor, You can use it to record any thing project related,

currently it is up to You to present the devlog to a customer, ii usually use a markdown parser and show the html version of the log, 
You can even insert links and have the devlog inside a git repository, pushing it to Your customer or Your website...

there are endless options for devlogs... any project can have a nice devlog... :D

#19.01.2014 13:40:15 CodingSession::BEGIN

#19.01.2014 13:40:06 ComSession::END

an exemplary communication session... what should we communicate about, ah, why this development log is written?

this one is for testing and for documenting the development of the development log writing tool, or shortly the devlog parser gem.

but usually ii use such a development log to give my customer the ability to follow along and to also have everything documented for the my self. it is an open perspective, time is tracked exactly as it happens, ii am using simple key bindings in my editor to insert begin and end DSL commands for the parser to read and so forth...

the parser then writes out a summary of the devlog information, giving exact coding time, communication time and even time payed...

let me pay for all the development hours of this work in advance like this:
-3000h
+3000000000000$

a +300$ is an optional entry, the parser does not yet parse money, it only parses + hours and - hours, integers, ii can add two more hours like this:
+2h

or subtract three:
-3h

the parser will know and give accurate result in the Tajm object which is reuturned from the parse_devlog method...

#19.01.2014 13:33:53 ComSession::BEGIN

#19.01.2014 13:33:42 CodingSession::END

preparing repo at github to publish first version: 0.0.0...

#19.01.2014 13:18:20 CodingSession::BEGIN

#19.01.2014 13:18:14 CodingSession::END

ii have been using this little devlog script for many years now, ii could upgrade it with many features, but ii always ended up not doing that to stay simple.

the time has come to add these features, slowly, naturally.

so here is the initial devlog entry for the development of the devlog tool writing software.

"2014-01-19T10:16:08+00:00"

#19.01.2014 10:16:08 CodingSession::BEGIN