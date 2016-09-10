---
layout: page-fullwidth
title: "Site Formatting Guide"
subheadline: ""
show_meta: false
teaser: ""
permalink: "/formatting/"
header: no
---

### _Table of Contents_
{:.no_toc}
*  Auto generated table of contents
{:toc}  

### _Purpose_
_____________________________________________________________
Should you wish to add to or edit the tutorials and documentation on this website, this guide will cover the site-wide formatting in use to maintain consitency. Syntax specific to the site will also be outlined in the relevant sections.

### _Preliminaries_
_____________________________________________________________
The site uses [Jekyll](https://jekyllrb.com/)  to parse Kramdown files in to HTML which can then be hosted. To edit the site, you will need access to the GitHub repository used to host the site (currently the site is hosted on GitHub Pages). For access to this repository please contact -. Once you have access simply clone the directory, make your changes and push to the repo. All the Jekyll site compliation is done server side by GitHub Pages.

It would be of benefit to read through the Kramdown documentation [here](http://kramdown.gettalong.org/syntax.html) and the theme specific formatting [here](http://phlow.github.io/feeling-responsive/) to get an idea of what is used on the site and, further, what is possible. Some syntax in this guide is specific to the site and will be detailed however some more general syntax will not be explained as the aim here is to outline the formatting rules. Should you wish to know what specific syntax elements are doing, refer to the Kramdown documentation linked previously.

### _Site Formatting_
_____________________________________________________________

##### _General Document Style_
The document should start with a "Purpose" section and a "Preliminary" section, where "Purpose" contains the purpose/aims of the tutorial and "Preliminary" contains the prerequesites, recommended reading or guidelines that should be read before progressing with the tutorial.
Next should be the content of the document, split up in to short and easily followed sections (large tutorials and documents should be split in to multiple smaller tutorials and documents where possible).
An 'Other Resources' section can be supplied if there are tutorials/papers/other useful documents that are relevant to the current document.
An 'Issues or Comments' section can be included with contact details should the reader have an issue or suggestion about the document.

Tutorials, unless they are very involved (e.g. the DMFT tutorial) should have a "Command Summary" section that assembles all the commands in the tutorial together in one place, for quick reference.   Thus Tutorials generally should have the following sections, in order shown.  The [basic lmf tutorial](https://github.com/lordcephei/lordcephei.github.io/blob/master/pages/fpintrotut.md) has a useful template to follow.

    Purpose
    Preliminaries
    Command summary (optional)
    Tutorial
    Other Resources (optional)
    FAQ (optional)
    Additional Exercises (optional)
    
##### _Table of Contents_
Documents with multiple references or subsections should contain a table of contents, usually before any other text. Jekyll/Kramdown has support for auto-generating this ToC as shown here:

~~~
### _Table of Contents_
{:.no_toc}
*  Auto generated table of contents
{:toc}  
~~~

Adding the

    {:.no_toc}

flag directly under a header will exclude that category and its subcategories from the ToC autogeneration. 

##### _Front Matter_
Front matter is always placed at the top of *.md files. Jekyll uses this data to format the page in question. More information on the capabilities of the Front Matter can be found [here](http://jekyllrb.com/docs/frontmatter/). The Front Matter used for most files is as such:

~~~
---
layout: page-fullwidth
title: "Site Formatting Guide"
subheadline: ""
show_meta: false
teaser: ""
permalink: "/formatting/"
header: no
---
~~~

This should be edited for the page in question.

##### _Headers_
Headers are nested automatically in the table of contents generation by number of # used. Generally, the site uses ### for primary headings and an extra ## for each subheading under that. For example, your primary heading may be ###, a subheading ##### and a subheading under the first subheading #######. In addition, headers are italicized with single underscores surrounding the header (\_Header\_).

##### _Colours_
The site uses colours to denote certain things. **Blue**{: style="color: blue"} is used for program/package names and terminal commands, such as the **lm**{: style="color: blue"} package or the console command **cd**{: style="color: blue"}. _Green_{: style="color: green"} is used for directories or files, such as the _ctrl.si_{: style="color: green"} file. **Red**{: style="color: red"} is used for important points such as a **Note:**{: style="color: red"}. Colouring items can be achieved with:

    **Placeholder Text**{: style="color: blue"}

"blue" can be changed to "red", "green" or any standard colour. Note that to colour a string (with or without spaces) there must be a text emphasis element (such as \_ \_ or \*\* \*\* etc) surrounding the string.

##### _Text Emphasis_
**Bold** is used for programs/package names, noteworthy points (**Note:**) and the names of input file tags (e.g. **SITE\_ATOM\_POS**). _Italics_ are used for directories, files and headers.

##### _Code Blocks_
Code blocks, as would be expected, should be used for any code, input or outputs (such as the _ctrl.si_{: style="color: green"} input file), terminal commands and general instructions. Code blocks are always on a new line so it is not suitable if inline text is desired.  

Code blocks can be defined with either a 4-space indentation relative to the current indentation (so if your block of text has a 4-space indentation already, your code block would need to be 8-space). Code blocks can also be denoted with ~~~ at the open and close of a block.

~~~~~
~~~

Code here

~~~
~~~~~

##### _Drop Down Boxes_
Drop down boxes allow for hiding of information unless the user manually opens it, enabling tutorials and documentation to be condensed and easier to follow while not removing information. Drop down boxes are not included within standard Kramdown formatting and are implemented with html. To use a dropdown box, the syntax is:

<div onclick="elm = document.getElementById('box0'); if(elm.style.display == 'none') elm.style.display = 'block'; else elm.style.display = 'none';"><button type="button" class="button tiny radius">Click to show.</button></div>
{::nomarkdown}<div style="display:none;margin:0px 25px 0px 25px;"id="box0">{:/}

~~~
<div onclick="elm = document.getElementById('foobar'); if(elm.style.display == 'none') elm.style.display = 'block'; else elm.style.display = 'none';"><button type="button" class="button tiny radius">Click to show.</button></div>
{::nomarkdown}<div style="display:none;margin:0px 25px 0px 25px;"id="foobar">{:/}

Content

{::nomarkdown}</div>{:/}
~~~

{::nomarkdown}</div>{:/}

When using a dropdown box, both instances of the "foobar" ID need to be changed and also be unique to that dropdown box.

##### _Equations_
Mathematical equations can be added in-line within the markdown files by enclosing the equation in double dollar signs:

    $$equation$$

The equation itself is standard LaTeX syntax. If you are not familiar with LaTeX equation formatting, more information can be found [here](https://en.wikibooks.org/wiki/LaTeX/Mathematics).

### _Making Changes_

##### _Using Git_
The site is currently hosted on GitHub and **Git**{: style="color: blue"} is used to manage the site and upload changes. To contribute to the site, please contact . in order to recieve permissions to edit the repository.    

Actually making changes, for those of you unfamiliar with **Git**{: style="color: blue"}, is fairly simple. You will need **Git**{: style="color: blue"} installed on your machine before proceeding, more information [here](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git). First, clone the repository to your local disk.

    git clone https://github.com/lordcephei/lordcephei.github.io.git

This will clone the site's files in to the _lordcephei.github.io_{: style="color: green"} folder. You can now make your changes or additions to the site source files. When these are completed, we must add the file to the index for committing. The following commands assume you are working from the repository directory.

    git add *

You can also add files individually

    git add [filename]

With the files indexed, we can now set up the commit

    git commit -m "Commit message"

Where "Commit message" should be a useful message to let other people using the respository know what you are committing.    

Finally, we can commit the changes

    git push origin master

You may be asked for username and password details, fill these in and assuming you have repository access, all should be fine.   

When you want to edit the repository again, you do not need to clone a new copy. Instead, make sure you update your local copy with all the changes other developers have made. And follow the steps above, starting with the _add_{: style="color: blue"} command.

    git pull origin master

##### _Hosting Locally_
The site can be built and hosted locally for you to check errors, formatting and the like. To do this, ensure **jekyll**{: style="color: blue"} is installed on your machine, more information [here](https://jekyllrb.com/docs/installation/).   

With **jekyll**{: style="color: blue"} installed, you can either build the site html for hosting elsewhere, or host with **jekyll**{: style="color: blue"}'s built in webserver. To build without hosting, simply

    jekyll build

From within the repository's directory. This will produce a _\_site_{: style="color: green"} folder which contains the copiled html files for the site. To host the site locally

    jekyll serve

This will create the same _\_site_{: style="color: green"} folder, but will also host the website locally. Read your terminal output for the address of the site.
