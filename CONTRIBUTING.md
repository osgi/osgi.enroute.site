# Contributing to osgi.enroute.site

Want to improve the osgi.enroute.site? Great!
Here are instructions to get you started.

## Table of Contents


<!-- @import "[TOC]" {cmd:"toc", depthFrom:2, depthTo:3, orderedList:false} -->

<!-- code_chunk_output -->

* [Table of Contents](#table-of-contents)
* [Prerequisite](#prerequisite)
* [Reporting Issues](#reporting-issues)
	* [Before Submitting an Issue](#before-submitting-an-issue)
	* [Writing Good Bug Reports and Feature Requests](#writing-good-bug-reports-and-feature-requests)
* [Contributing Improvements](#contributing-improvements)
	* [Install Git, Ruby and Bundler](#install-git-ruby-and-bundler)
	* [Setup SSH for GitHub](#setup-ssh-for-github)
	* [Setup Git Triangular Workflow](#setup-git-triangular-workflow)
	* [How to do a Pull Request](#how-to-do-a-pull-request)
	* [Install and Run Jekyll](#install-and-run-jekyll)
	* [Contribution Guidelines](#contribution-guidelines)

<!-- /code_chunk_output -->

If you want to report an issue and don't know how exactly to do that, just keep reading.
If you are interested in fixing issues and contributing directly to the code base, please go to the [contributing section](#contributing-improvements).

## Prerequisite

Our page is created with GitHub Pages and its code is stored on GitHub. In order to create issues or contribute to this site you should have a GitHub account. You can sign up [here](https://github.com/join) for free.

If you already have an account, please make sure that you are signed in.

## Reporting Issues

Found a bug? The code in a tutorial is not working as intended? Something is missing? Then you probably should submit an issue.

### Before Submitting an Issue
Check that our [issue database](https://github.com/osgi/osgi.enroute.site/issues) doesn't already include that problem or suggestion before submitting an issue. If you find a match, you can use the "subscribe" button to get notified on updates. Please do not leave random "+1" or "I have this too" comments, as they only clutter the discussion, and don't help resolving it. However, if you have ways to reproduce the issue or have additional information that may help resolving the issue, please leave a comment.

### Writing Good Bug Reports and Feature Requests
When reporting [issues](https://github.com/osgi/osgi.enroute.site/issues) on GitHub please file a single issue per problem and feature request. Do not file combo issues. Please do not submit multiple comments on a single issue - write your issue with all the environmental information and reproduction steps so that an engineer can reproduce it.

An bug report could look similar to this:

```
Reproduction Steps:

 1. Do Something
 2. Do something else aaand...
 3. ... break things

Observed behavior:
	Console is exploding

Expected behavior:
	Console should NOT explode!

Environment/Tools:
	OS: Windows 10
	IDE: Eclipse Oxygen
	Java: 1.8.0
	Gradle: 4.1
	...

Additional information:
	anything else that might be useful (e.g. Screenshots)
```
This information will help us review and fix your issue faster.
Feature requests usually can be less formal ;)

## Contributing Improvements

If you are not satisfied with only reporting issues and want to get your hands dirty, then rest assured: Any help is appreciated! We are always thrilled to receive pull requests, and do our best to process them as fast as possible. Not sure if that typo is worth a pull request?
**Do it!**
**We will appreciate it.**

The site uses [GitHub Pages](https://help.github.com/articles/what-are-github-pages/) with the site content in the `master` branch. To build the site locally, you will need to install Ruby, Bundler and Jekyll. If you've never worked with GitHub Pages before, just keep reading. This site also makes use of [Git submodules](https://git-scm.com/book/en/v2/Git-Tools-Submodules) to pull in the [OSGi enRoute GitHub repository](https://github.com/osgi/osgi.enroute) so that code examples can be easily pulled from the enRoute examples.

Or you already are a pro at working with GitHub Pages? You have set up the [git triangular workflow](https://www.sociomantic.com/blog/2014/05/git-triangular-workflow/) for this repository and have Ruby, Bundler and Jekyll running? You have pulled down the enRoute submodule? Then what are you waiting for? Read the [contributing guidelines](#contributing-guidelines) section and start writing!

Github pages can be created either with usual HTML or you can use [Jekyll](https://jekyllrb.com/), a static web site generator, which takes [Markdown](https://daringfireball.net/projects/markdown/) files and transforms them into a static webpage. Usually you want to write in markdown, as this is way more convenient than writing pure HTML.

The following instructions are a shortened form of the official [GitHub article](https://help.github.com/articles/setting-up-your-github-pages-site-locally-with-jekyll/) on setting up your GitHub Pages site locally with Jekyll.

### Install Git, Ruby and Bundler

**Update/Install Git**
* Check if you've already installed Git: type `git --version` in a console
* If a version is printed out it's fine (at the time of writing:  2.14.1)
* If not:
 	* **Windows:** go to [Git](https://git-scm.com/) and download/install the current version
	* **Linux:** type `apt-get install git-all` in a console
	* **MacOS:** type `brew install git` in a console (You can get Homebrew [here](https://brew.sh/))

**Update/Install Ruby**
* Check if you've arleady installed Ruby: type `ruby --version` in a console
* If a version is printed out it's fine (at the time of writing: 2.4.1)
* If not:
	* **Windows:** download [Ruby](https://rubyinstaller.org/) and install it
	* **Linux:** type `apt-get install ruby` in a console
	* **MacOS:** type `brew install ruby` in a console
> *There seems to be a problem with json 1.8.3 and Ruby 2.4.x. So you should either install 2.3.3 for now or follow these [instructions](https://github.com/github/pages-gem/issues/376)*

**Install Bundler**
* Open a console
* Type `gem install bundler`

### Setup SSH for GitHub

We recommend to use SSH when working with your repository. In order to setup SSH for your GitHub account

* Open Git Bash
* Type `ssh-keygen -t rsa -b 4096 -C "your_github_email@example.com"`
* Select default file when prompted by pressing `Enter`
* Enter a passphrase
* Start ssh-agent `eval $(ssh-agent) -s`
* Add your SSH key `ssh-add ~/.ssh/id_rsa`
* Confirm with the passphrase you selected before
* Copy the SSh key to your clipboard `clip < ~/.ssh/id_rsa.pub`
* Go to your GitHub **Settings** on the GitHub website
	* Go to **SSH and GPG keys**
	* Click **New SSH key** or  **Add SSH key**
		* Title: "Some description"
		* Paste your key into the "Key" field
		* Click **Add SSH key**
		* If prompted, confirm with your GitHub password
* Test your SSH connection `ssh -T git@github.com`
	* You may see one of these warnings:
		* `The authenticity of host 'github.com (192.30.252.1)' can't be established.	RSA key fingerprint is 16:27:ac:a5:76:28:2d:36:63:1b:56:4d:eb:df:a6:48. Are you sure you want to continue connecting (yes/no)?`
		* `The authenticity of host 'github.com (192.30.252.1)' can't be established. RSA key fingerprint is SHA256:nThbg6kXUpJWGl7E1IGOCspRomTxdCARLviKw6E5SY8. Are you sure you want to continue connecting (yes/no)?`
	* Verify that the fingerprint in the message you see matches one of the messages, then type `yes`
	* Verify that the resulting message contains your username

Now you've successfuly set up SSH for your GitHub account!

The above instructionset is a shortened version of the official [GitHub Help](https://help.github.com/articles/connecting-to-github-with-ssh/). If you struggle with setting up SSH, have a look at their more detailed instructions.

### Setup Git Triangular Workflow

We use [git triangular workflow](https://www.sociomantic.com/blog/2014/05/git-triangular-workflow/). This means that no one, not even the osgi.enroute.site maintainers, push contributions directly into the [main osgi.enroute.site repo](https://github.com/osgi/osgi.enroute.site). All contribution come in through pull requests. So each contribtor will need to fork the main osgi.enroute.site repo
on GitHub. All contributions are made as commits to your fork. Then you submit a pull request to have them considered for merging into the main osgi.enroute.site repo.

In order to be able to make proper commits you should add your email address and your name to the global git config:

```
git config --global user.email "email@example.com"
git config --global user.name "Your Name"
```

Fork the repository
  * If you have a Github account simply go to [Fork](https://github.com/osgi/osgi.enroute.site/fork)
  * You don't have a Github account? Read the [documentation on forking](https://help.github.com/articles/fork-a-repo/) for how to do this in your case

After forking the main osgi.enroute.site repo on GitHub, you can clone the main repo to your system:

    git clone https://github.com/osgi/osgi.enroute.site.git

This will clone the main repo to a local repo on your disk and set up the `origin` remote in Git.
Next you need to populate the data in the OSGi enRoute submodule, this is effectively a second checkout which will pull in the rest of the code needed to build the site.

    cd osgi.enroute.site
    git submodule update --init --checkout

Next you will set up the the second side of the triangle to your fork repo.

    git remote add fork git@github.com:<YourUserName>/osgi.enroute.site.git

Make sure to replace the URL with the SSH URL to your fork repo on GitHub. Then we configure
the local repo to push your commits to the fork repo.

    git config remote.pushdefault fork

So now you will pull from `origin`, the main repo, and push to `fork`, your fork repo.
This option requires at least Git 1.8.4. It is also recommended that you configure

    git config push.default simple

unless you are already using Git 2.0 where it is the default.

Finally, the third side of the triangle is pull requests from your fork repo to the
main repo.

### How to do a Pull Request
If you've forked the repo on GitHub then it is dead easy to make a pull request.
Go to your forked GitHub repository, switch to the bugfix/feature branch you created and click the **New pull request** button right next to it. That's it!
Your pull request will be reviewed by the maintainers of osgi.enroute.site and either we accept it or will ask you to do additional changes in order to get accepted. If we ask you to make additional changes, just commit them to the bugfix/feature branch of your forked repo you created the pull request for. The pull request will get updated automatically.

### Install and Run Jekyll

In order to install Jekyll:
  * Go to the root folder of your cloned repository (There should be a Gemfile somewhere)
  * Open a console
  * Type `bundle install`

There should be a lot of console output if you are doing this for the first time. At the end there should be some sort of success report.

Run Jekyll in the root directory to build:

	$ bundle exec jekyll build

You can also run a local server to test the site:

	$ bundle exec jekyll serve

Then go to [http://localhost:4000](http://localhost:4000). The pages are automatically updated when you edit a markdown file, though you do have to refresh the browser to see these changes. Eclipse later revisions have a decent markdown editor build in.

#### Fix Problems with Jekyll on Linux

If, after running `bundle exec jekyll build`, you get an error like the following, you need to install the `ruby-dev` package, e.g., with `apt-get install ruby-dev`.

	ERROR:  Error installing jekyll:
		ERROR: Failed to build gem native extension.

		current directory: /var/lib/gems/2.3.0/gems/ffi-1.9.18/ext/ffi_c
	/usr/bin/ruby2.3 -r ./siteconf20171117-322-1cr2dl9.rb extconf.rb
	mkmf.rb can't find header files for ruby at /usr/lib/ruby/include/ruby.h

	extconf failed, exit code 1

Installing the `ruby-dev` package makes the required header files available so the error does not occur.

#### Fix Problems with Jekyll on Windows

There are several errors that might occur when you are trying to run Jekyll on Windows. Usually all of them are documented somewhere in the web, but we've gathered the most common ones and their solutions:

##### Error: "No repo name found"

* Open the file *_config.yml*
* At the end write `repository: <YourUserName>/osgi.enroute.site`
* Make sure not to check in this change

##### Error: "The GitHub API credentials you provided aren’t valid"
* Go to your [Github settings](https://github.com/settings/tokens)
    * Click on "Generate new token"
      * Description: "Jekyll Local Token"
      * Scopes: check "repo"
      * Click on "Generate Token"
    * Create a new system environment variable
      * Key: `JEKYLL_GITHUB_TOKEN`
      * Value: `<TheGeneratedToken>`
    * Close/Reopen your console

##### Error: "Certificate verify failed"
* Download `cacert.pem` file from [here](http://curl.haxx.se/ca/cacert.pem) and save it in a folder of your choice
    * Create a new system environment variable
      * Key: `SSL_CERT_FILE`
      * Value: `C:\path\to\your\cacert.pem`
    * Close/Reopen your console

### Contribution Guidelines

#### Create Issues

Any significant improvement should be documented as [a GitHub issue](https://github.com/osgi/osgi.enroute.site/issues) before anybody starts working on it. For more information on how to create issues please go back to the [reporting issues section](#reporting-issues)

#### Conventions

Fork the repo and make changes on your fork in a branch:

- If it's a bugfix branch, name it XXX-something where XXX is the number of the issue
- If it's a feature branch, create an enhancement issue to announce your
  intentions, and name it XXX-something where XXX is the number of the issue.

Make sure to avoid unnecessary white space changes
which complicate diffs and make reviewing pull requests much more time consuming.

Pull requests descriptions should be as clear as possible and include a
reference to all the issues that they address.

Pull requests must not contain commits from other users or branches.

Commit messages must start with a short summary (max. 50
chars) written in the imperative, followed by an optional, more detailed
explanatory text which is separated from the summary by an empty line.

    index: Remove absolute URLs from the OBR index

    The url for the root was missing a trailing slash. Using File.toURI to
    create an acceptable url.

In Git this can be done via
```
git commit -m "Remove absolute URLs from the OBR index" -m "The url for the root... and so on"
```

Review comments may be added to your pull request. Discuss, then make the
suggested modifications and push additional commits to your feature branch. Be
sure to post a comment after pushing. The new commits will show up in the pull
request automatically, but the reviewers will not be notified unless you
comment.

Before the pull request is merged, make sure that you squash your commits into
logical units of work using `git rebase -i` and `git push -f`. After every
commit, the site must be buildable.

Commits that fix or close an issue should include a reference like `Closes #XXX`
or `Fixes #XXX`, which will automatically close the issue when merged.

#### Sign your work

The sign-off is a simple line at the end of the commit message
which certifies that you wrote it or otherwise have the right to
pass it on as an open-source patch.  The rules are pretty simple: if you
can certify the below (from
[developercertificate.org](http://developercertificate.org/)):

```
Developer Certificate of Origin
Version 1.1

Copyright (C) 2004, 2006 The Linux Foundation and its contributors.
660 York Street, Suite 102,
San Francisco, CA 94110 USA

Everyone is permitted to copy and distribute verbatim copies of this
license document, but changing it is not allowed.


Developer's Certificate of Origin 1.1

By making a contribution to this project, I certify that:

(a) The contribution was created in whole or in part by me and I
    have the right to submit it under the open source license
    indicated in the file; or

(b) The contribution is based upon previous work that, to the best
    of my knowledge, is covered under an appropriate open source
    license and I have the right under that license to submit that
    work with modifications, whether created in whole or in part
    by me, under the same open source license (unless I am
    permitted to submit under a different license), as indicated
    in the file; or

(c) The contribution was provided directly to me by some other
    person who certified (a), (b) or (c) and I have not modified
    it.

(d) I understand and agree that this project and the contribution
    are public and that a record of the contribution (including all
    personal information I submit with it, including my sign-off) is
    maintained indefinitely and may be redistributed consistent with
    this project or the open source license(s) involved.
```

then you just add a line to end of the git commit message:

    Signed-off-by: Joe Smith <joe.smith@email.com>

Or you can make your commit with -s

	git commit -s -m "some message"

using your real name. Sorry, no pseudonyms or anonymous contributions.

Many Git UI tools have support for adding the `Signed-off-by` line to the end of your commit
message. This line can be automatically added by the `git commit` command by using the `-s` option.

##### Small patch exception

There are some exceptions to the signing requirement. Currently these are:

* Your patch fixes spelling or grammar errors.

#### Merge approval

The osgi.enroute.site maintainers will review your pull request and, if approved, will merge into
the main repo.

#### How can I become a maintainer?

* Step 1: learn the repo inside out
* Step 2: make yourself useful by contributing information, bugfixes, support etc.
* Step 3: introduce your self to the other maintainers

Don't forget: being a maintainer is a time investment. Make sure you will have time
to make yourself available. You don't have to be a maintainer to make a difference
on the project!
