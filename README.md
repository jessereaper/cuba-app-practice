Example Cuba App
================

This is an example Cuba app to use as a starting point for a project in [CSET 160][cset160].

  [cset160]: http://chadoh.com/cset160/


Getting Started
===============

You could clone this repo, but the idea here is that you build your own little
codebase. So click the "clone or download" button above, and select "download
zip". This will give you the files without any git history.

You can copy the files into an existing repository, or start a new repository
with the files in the zip.

Install all project dependencies with

    bundle install

Before you start the app with `rackup`, you'll have to initialize the database.


Initializing The Database
=========================

The code is set up to create a `dev.db` file in the `db` folder. This is fine.
Renaming it is more trouble than it's worth.

This database doesn't exist yet, as the db file is `gitignore`d (look at the
`.gitignore` file to confirm this).

To create the database and a table in it, run the migrations:

    ruby db/migrate.rb

You can open up `db/migrate.rb` in your editor to see what it does. The main
event is in the `db/migrations` folder. This is important! You'll need to
change the migration for your own data, so take a look and get familiar with
what's going on.


Running the app with restart
============================

You can run the app with a simple

    rackup

This command looks at the `config.ru` file ("ru" stands for "rack up"), and
does whatever it says.

However, as you work, you'll probably want your server to automatically update
when you make changes to files. For that, install [rerun]:

    gem install rerun rb-fsevent

(the above command installs _two_ gems, `rerun` and `rb-fsevent`. `rerun`
depends on `rb-fsevent` when using macOS.)

And then run the app with

    rerun rackup

Now as you make changes, if you check your command line, you'll see that it
reloads everything.

  [rerun]: https://github.com/alexch/rerun


Exploring the app
=================

`app.rb` is the brain of the app. Read it first. If it leaves you totally lost
and glazed over, try these first:

* **Is basic Ruby syntax still just foreign territory?** You may need to read
  up more on basic Ruby. [Ruby Monk](https://rubymonk.com/) seems like a great
  way to do that.
* **Are `get` and `post` leaving you confused?** These are part of HTTP! Here's
  [a nice-looking short video about GET vs POST and HTML
  forms](https://www.youtube.com/watch?v=9o_4lsOkQ3g)
* **Is Cuba throwing you off?** Try skimming [the Cuba
  documentation](https://github.com/soveran/cuba) until you find the part you
  want to learn more about.

If you're feeling like you kinda get what's going on, but want to explore the
code more, throw in some print statements. For example, try this:

```diff
  on root do
    student_array = db.execute("SELECT * FROM students")
+   p "student_array", student_array
    students = student_array.map do |id, name, email, discord|
+     p "student", id, name, email, discord
      { :id => id, :name => name, :email => email, :discord => discord }
    end
+   p "students", students
    res.write view("index", students: students)
  end
```

Then, when you reload the home page, look at your terminal output. It'll show
you what `student_array`, each individual `student`, and the `students`
variable all look like.

Wanna dig in deeper? Sure you do. Try this:

    gem install pry

And then insert this line:

```diff
  on root do
    student_array = db.execute("SELECT * FROM students")
    students = student_array.map do |id, name, email, discord|
      { :id => id, :name => name, :email => email, :discord => discord }
    end
+   require 'pry'; binding.pry
    res.write view("index", students: students)
  end
```

Yeah, the syntax is weird. Don't worry about what `binding` means at this
point.

Now, run your app with just `rackup`, not `rerun rackup`. `rerun` can
cause problems with `pry`.

Then reload the home page.  You'll see that it gets stuck and never loads.
Check your terminal. You'll see that it gave you some sort of prompt. This lets
you play with the code in context. You can type `req` and see what `req` looks
like.

(If you did that, you'll see that `req` is *really big!* So big that it can't
all show in your terminal at once. Don't know how to scroll? It's using `more`.
Don't remember `more`? [Refresh your memory](http://commandline.guide/#/5/3).)

Pry is a powerful debugging tool. Like any powerful tool, using it well
requires learning it well. They have a nice video on [their
homepage](http://pryrepl.org/).
