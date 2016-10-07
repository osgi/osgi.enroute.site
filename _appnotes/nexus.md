---
title: Releasing to a Nexus server
summary: Shows how the OSGi enRoute bundles and API are released to Maven Central
version: 2.0.0
---

This App note shows how to setup a workspace to release snapshots and stage releases.
It uses the OSGi enRoute bundles project and API project as example since these
are released to Maven Central this way.

We are using Github and Travis for the Git support and continuous integration
support.

This App Note expects that you have experience in working with Git, Bndtools, and Travis.

## Compatibility

This App Note assumes the following minimum versions:

* bnd – 3.3.0
* Gradle – 2.13 (should be download automatically

Make sure your gradle.properties reflect at least bnd 3.3.0

## Strategy

The release strategy that we think is the best is to release snapshots on every
commit via a continuous integration build. That is, never a build on your local
system. Once the snapshots are working, we change the version to the release version,
tag the build, commit. The build that is then triggered should release to 
a staging repository. We then verify the staged repository, sign it, and release
it.

1 Set the version to a snapshot version
2 Compile, edit, debug
3 Commit to git
4 Trigger a build on travis by pushing
5 Release the workspace projects as snapshots
6 Repeat from step 1

Once the snapshots are ready for release:

1 Set the version to a release version
2 Tag the repository with the version
3 Build locally to verify all is ok
4 Commit to git
5 Tag the repository
5 Create a staging repository on Nexus or drop an existing one (you can only have one)
5 Push the repository
6 Verify the results of the staging repo (this will fail because they are not signed)
7 Sign the staging repo from the command line
8 Close the staging repo on Nexus (might trigger rules)
9 Release the staging repo on Nexus

## OSGi Repositories on Central

The OSGi Alliance has a number of repositories on Maven Central to release its
artifacts. Anybody can see these repositories on the [OSS Sonatype Repository Manager][1].

The OSGi has the following repositories:

* Osgi Repositores visible – https://oss.sonatype.org/content/groups/osgi/
* Osgi With Staging – https://oss.sonatype.org/content/groups/osgi-with-staging/
* Osgi Releases – https://oss.sonatype.org/content/repositories/osgi-releases/
* Osgi Snapshots – https://oss.sonatype.org/content/repositories/osgi-snapshots/

The given URLs are the URLs under which the artifacts are made available, the
deply artifacts can differ.

## Workspace

In this case we assume the `ogsi.enroute` workspace. This workspace has a number
of bundles that must be released to Maven Central.

On Travis, we've connected a build server to this repository.

If you make your own workspace then make sure it is stored on Github and
and that it is automatically build by Travis. The [Base Tutorial] shows you
how to set this up.

## The Release Repository

To release to Maven Central we need to setup a Maven repository in a bnd workspace.
The following settings in, for example `cnf/build.bnd` should do this for you:

	-plugin.osgi.nexus: \
	\
		aQute.bnd.repository.maven.provider.MavenBndRepository; \
			snapshotUrl=https://oss.sonatype.org/content/repositories/osgi-snapshots/; \
			releaseUrl= https://oss.sonatype.org/service/local/staging/deploy/maven2/; \
			index=${.}/osgi-nexus.maven; \
			name="OSGiNexus"
	
	-releaserepo: OSGiNexus

## About the Maven Bnd Repository

The `snapshotUrl` maps directly to our snapshot repository. All projects that have a 
version that ends in `-SNAPSHOT` are automatically stored in the snapshot repository.

The `releaseUrl` is, however, quite different from the content URL. The reason
is that we create a special staging repository. This will be discussed later.

You can find more information about the plugin in the [manual](http://bnd.bndtools.org/plugins/maven.html).

## Credentials

This is one of the few places in open source where we need credentials.

What credentials should you use? You could use the credentials you have on
Nexus but that is dangerous. If someone can access then they can do harm. For this
reason Nexus can create _user tokens_. These user tokens can be withdrawn at any
time.

You access or create a user token by logging into Nexus. Then select the user
profile by clicking on your user id. Select  `Profile`. THen click on the popup
menu and select `User Token`. You will have to log in again. You can create
a new user token or reset an existing token. These tokens (a base 64 encoded
string) should be used as credentials.

The easiest way is to provide the credentials through the [bnd settings][2]. However,
we want to release from Travis. This requires a bit more work because
that means that we need to handle the secrets through an open source
repository and build system.

### Travis

Travis has a facility to encrypt environment variables and that is what we use.
We can access these environment variables from any bnd file.

So to encrypt the environment variables we have to do the following:

	osgi.enroute $ travis encrypt \
	    REPOSITORY_USERNAME=john \
	    REPOSITORY_PASSWORD=doe \
	    --add env.global

This adds some magic to the .travis.yml file. Since this is encrypted, we can
safely store this in Git.

	sudo: false
	language: java
	jdk:
	- oraclejdk8
	
	install:
	- "./gradlew --version"
	script:
	- "./gradlew --continue build release"
	after_success:
	- git status
	cache:
	  directories:
	  - "$HOME/.gradle"
	
	env:
	  global:
	    secure: h3TeZlSXo5RaHjd4q2rSj+xVoxiQmZAFY9QoGAjvFkogn5+PBIwbbQ08TBESrz2v+R1mRum5AoV3SRvohzWorXIBVWXM0N+/jhEWQ41UImJv3RrW87vN5v/gUmIjIXIUJx2w+6PzLpvhroD2un7UeQ29N5rNYj65xjYcKNmCQaE=

### bnd

In the build.bnd file we can distinguish between a local build (no password) and a
remote build (password). We then use this information to set the credentials in the
`cnf/build.bnd` file. This is a bit of bnd macro magic.

	pwd = ${env;REPOSITORY_PASSWORD;}
	usr = ${env;REPOSITORY_USERNAME;}

	-connection-settings: \
		${if;${pwd};server;-dummy}; \
			id=https://oss.sonatype.org; \
			username=${usr}; \
			password=${pwd}, \
			-bnd


What it does is to create a server credentials block or a dummy if no credentials are there.

Note that if we set the `REPOSITORY_PASSWORD` and `REPOSITORY_USERNAME` environment variables
in the shell we can also release from the command line.

## Versioning

All projects in the `osgi.enroute` workspace are sharing the same version. That is, we release
all artifacts with a single version. We there set the Bundle-Version header in `cnf/build.bnd`:

	base.version:           2.0.0
	Bundle-Version:         ${base.version}.${tstamp}-SNAPSHOT

As long as the projects in the workspace do not override the Bundle-Version header, they
will all inherit this version.

For normal builds we sue the `-SNAPSHOT` extension, the Maven Bnd Repository uses that,
just like Maven, as a signifier for releasing to the snapshot repository.

## POM Generation

The POM is generated by bnd. It uses as much information as possible from the 
OSGi manifest headers. However, it needs to know the `groupId` 

	-groupid:               org.osgi

We also want to make sure the version for Maven is consistently formatted. In OSGi versions
can be written differently but are the same version, in Maven a version is an
opaque identifier. We therefore canonicalize the version. 

	-pom:                   version=${versionmask;===s;${@version}}

The `${@version}` is set by the pom generator when this macro is expanded. It
is the version calculated for the bundle itself. This allows us to
slightly tweak the version. We are using the major, minor, and micro part but
then only add the snapshot part if present. We ignore the qualifier. This is a
timestamp and does not work well with maven.

The POM generator uses the following Manifest headers to create the POM.

* Bundle-SymbolicName – The `artifactId` 
* Bundle-Name – The ``name`
* Bundle-Description – Goes into the POM description
* Bundle-DocURL – The `url` element
* Bundle-Vendor – Organization name and url. The url part is set if the header ends in an http or https url.
* Bundle-License – Added as license
* Bundle-SCM – Source Control Management. All attributes are expanded as elements
* Bundle-Developers – Defines the developers.

An example of headers that work:

	Bundle-Vendor:    		OSGi Alliance http://www.osgi.org/
	Bundle-Copyright: 		${copyright}
	Bundle-License: 		http://opensource.org/licenses/apache2.0.php; \
	                			link="http://www.apache.org/licenses/LICENSE-2.0"; \
	                			description="Apache License, Version 2.0"
	Bundle-DocURL:    		http://enroute.osgi.org/
	Bundle-SCM:       		url=https://github.com/osgi/osgi.enroute, \
	                  			connection=scm:git:https://github.com/osgi/osgi.enroute.git, \
	                  			developerConnection=scm:git:git@github.com:osgi/osgi.enroute.git
	Bundle-Developers: 		osgi; \
								email=info@osgi.org; \
								name="OSGi Alliance"; \
								organization="OSGi Alliance"

The Bundle-SCM and Bundle-Developers headers are not OSGi standardized but they are
necessary to release to Maven Central.

Release a non-snapshot release will automatically create the javadoc and sources jars.

## Releasing a Snapshot

If we set the `REPOSITORY_USERNAME` and `REPOSITORY_PASSWORD` environment variables
then we can test our build from the command line with gradle.

	osgi.enroute $ export REPOSITORY_USERNAME=john
	osgi.enroute $ export REPOSITORY_PASSWORD=doe
	osgi.enroute $ ./gradlew release
	:osgi.enroute.base.api:compileJava UP-TO-DATE
	:osgi.enroute.base.api:processResources UP-TO-DATE
	:osgi.enroute.base.api:classes UP-TO-DATE
	:osgi.enroute.base.api:jar
	:osgi.enroute.base.api:assemble
	:osgi.enroute.base.api:release
	Upload https://oss.sonatype.org/content/repositories/osgi-snapshots/org/osgi/osgi.enroute.base.api/2.0.0-SNAPSHOT/osgi.enroute.base.api-2.0.0-20161007.133049-1.pom
	Upload https://oss.sonatype.org/content/repositories/osgi-snapshots/org/osgi/osgi.enroute.base.api/2.0.0-SNAPSHOT/osgi.enroute.base.api-2.0.0-20161007.133049-1.pom.sha1
	...
	Download https://oss.sonatype.org/content/repositories/osgi-snapshots/org/osgi/osgi.enroute.base.api/2.0.0-SNAPSHOT/maven-metadata.xml
	Upload https://oss.sonatype.org/content/repositories/osgi-snapshots/org/osgi/osgi.enroute.base.api/2.0.0-SNAPSHOT/maven-metadata.xml
	Upload https://oss.sonatype.org/content/repositories/osgi-snapshots/org/osgi/osgi.enroute.base.api/2.0.0-SNAPSHOT/maven-metadata.xml.sha1
	Upload https://oss.sonatype.org/content/repositories/osgi-snapshots/org/osgi/osgi.enroute.base.api/2.0.0-SNAPSHOT/maven-metadata.xml.md5
	...
	Upload https://oss.sonatype.org/service/local/staging/deploy/maven2/org/osgi/osgi.enroute.pom.distro/2.0.0/osgi.enroute.pom.distro-2.0.0-sources.jar.sha1
	Upload https://oss.sonatype.org/service/local/staging/deploy/maven2/org/osgi/osgi.enroute.pom.distro/2.0.0/osgi.enroute.pom.distro-2.0.0-sources.jar.md5
	
	BUILD SUCCESSFUL

The release process will add a new snapshot to the remote repository! 

Now this works, we can easily do this from Travis. Just commit your workspace.
You can then go to Travis to see your workspace build: [https://travis-ci.org/osgi/osgi.enroute](https://travis-ci.org/osgi/osgi.enroute).

## Releasing a Real Release

Nexus supports staging releases. This means that we release to a temporary 
repository which we can then later release on the Nexus GUI.

Before you begin, you should make sure there is no staging repository for your
build already available. If so, it should be dropped. 

## Release Version

First we need to change the version of the repository to non-SNAPSHOT. We change
`build.bnd`.

	base.version:           2.0.0
	Bundle-Version:         ${base.version}.${tstamp}
	#-SNAPSHOT

## Git Work

We commit the changes, set a tag and push

	osgi.enroute $ git add .
	osgi.enroute $ git commit -m "
	osgi.enroute $ git tag v2.0.0
	osgi.enroute $ git push
{: .shell }

This will trigger a Travis build that will send the workspace's bundles
to Nexus. 

## Staging Repository

After Travis has released the artifacts to Nexus, we need to look them up in
Nexus. When you're logged into Nexus you can go to the staging repositories.
You can search for the repositories you want, in our case `osgi`.

For example, we've implicitly created the repository `orgosgi-1090`.

We can then list the files from the command lines with bnd:

	osgi.enroute $ bnd nexus -u https://oss.sonatype.org/service/local/repositories/orgosgi-1090 files
	content/org/osgi/osgi.enroute.base.guard/2.0.0/osgi.enroute.base.guard-2.0.0.pom
	content/org/osgi/osgi.enroute.base.guard/2.0.0/osgi.enroute.base.guard-2.0.0.jar
	content/org/osgi/osgi.enroute.base.guard/2.0.0/osgi.enroute.base.guard-2.0.0-javadoc.jar
	content/org/osgi/osgi.enroute.base.guard/2.0.0/osgi.enroute.base.guard-2.0.0-sources.jar
	...
{: .shell }

## Signing

The release on Travis will not sign the files because this would require the
GPG key to be present on Travis which is not a good idea. This key is a personal
key.

We can now sign the files with bnd:

	osgi.enroute $ bnd nexus -u https://oss.sonatype.org/service/local/repositories/orgosgi-1090 files
	Password: ....
{: .shell }

The sign command will download all files and sign them locally. It then uploads the `asc` file
to nexus. This keeps your GPG key local.

## Release

On nexus you can now close the staging repository. This could trigger rules, which might fail.
If they fail, you might have to start over.

## Finalize

You now have to change the `cnf/build.bnd` file to go to the next version:

	base.version:           2.1.0
	Bundle-Version:         ${base.version}.${tstamp}-SNAPSHOT

Commit this to git to start the next snapshot build. You might want to cleanup the 
snapshot versions from Nexus.


[1]: https://oss.sonatype.org/#view-repositories
[2]: http://bnd.bndtools.org/instructions/connection-settings.html
[Base Tutorial]: http://enroute.osgi.org/tutorial_base/050-start.html

