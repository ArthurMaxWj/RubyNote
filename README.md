# RubyNote

A hobbyist project, designed not for production-use, but for presentation of certain interesting tricks/techniques.
Main work happens in 'rubynote/rubynote'. Sandboxing is used to apply Ruby code to html, resulting in imitation of ERB.
That technique is dangerous to be used in Ruby, as easy sandboxing can be bypassed,
when using such a dynamic language as Ruby. I suggest using gem Keisan (github.com/project-eutopia/keisan).

RubyNote is meant to be an editor of documents/notes, like a  student's notebook:
it is supposed to handle certain predefined structure.
It will be accomplished with extending this project to include document configuration, system and system of imports.
Better preprocessing would be useful too. 