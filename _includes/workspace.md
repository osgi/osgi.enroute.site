## The Workspace

OSGi enRoute requires that you group a number of projects in a _bnd workspace_. A bnd workspace is basically a directory with a `cnf` directory. We start with a template workspace by getting it from git. Though this could be done via EGit in Eclipse but there are about then dialogs for that. So by far the easiest way to do this is via the command line:

	$ cd  ~/git
	$ git init com.acme.prime
	$ cd com.acme.prime
	$ git fetch --depth=1 https://github.com/osgi/workspace master
	$ git checkout FETCH_HEAD -- .

## Opening the bnd Workspace in Eclipse

_(If you're very familiar with Eclipse then import this bnd workspace in a separate Eclipse workspace in the bndtools perspective and skip to the next section.)_	

We can now import the bnd workspace into Eclipse. However, we must ensure that the Eclipse workspace is *not* the same as the bnd workspace. Eclipse stores tons of metadata with lots of personal preferences that we almost never want to share through git. (bnd goes out of its ways to make builds independent of Eclipse preferences.) 

So start an Eclipse session and select a workspace. For our tutorials in OSGi enRoute we use the com.acme.prime workspace name, which is also the directory name. Let's place this test workspace in our home directory at `~/eclipse/com.acme.prime`.

Select `File/Switch Workspace/Other ...`. This gives you the following dialog:

![Switch Workspace](/img/qs/qs-switch-0.png)

After filling in the proper path and then closing the dialog by clicking `OK`, we get an Eclipse restart and should finally get:

![Start Screen](/img/qs/qs-switch-1.png)

### Import the bnd Workspace

Select `@/Import`:

![Import bnd Workspace, context menu](/img/qs/bnd-import-0.png)

Then select `General/Existing Projects into Workspace`:

![Import projects, select existing projects](/img/qs/bnd-import-1.png)

And then select the directory of the bnd workspace `~/git/com.acme.prime` (you have to manually expand the `~`).

![Import projects, select bnd workspace](/img/qs/bnd-import-2.png)

And then click `Finish`. This will import the cnf project into your Eclipse workspace.

Now, select the `Bndtools` perspective with `Window/Open Perspective .../Other ...'. This opens a selection dialog:

![Perspective Selection Dialog](/img/qs/workspace-bndtools-0.png)

Selecting `Bndtools` and clicking `OK` ensures that you are in the proper perspective. Your Eclipse should look similar to (at least after you refresh the repository view at the left bottom):

![Perspective Selection Dialog](/img/qs/workspace-bndtools-1.png)


