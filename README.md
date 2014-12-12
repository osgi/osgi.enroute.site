# OSGi enRoute Web Site

This repository holds the OSGi enRoute website hosted at [http://enroute.osgi.org][enroute]. This web site is maintained as markdown and turned into HTML by [Jekyll][jekyll] under guidance of Travis. We have the following layout in the _site folder:

* _book – Is the main set of chapters. The entries are listed in the nav bar
* _qs – Quick Start Tutorial
* _services – The Services Catalog
* _tutorial_base – The base tutorial
* ... – miscellaneous stuff, should be clear for someone with some web experience 

## Editing

You can clone this repository and then run jekyll (2.0.3+) in the root directory:

	$ bundle exec jekyll server -w -s _source -d _site

Then go to [http://localhost:4000](http://localhost:4000). The pages are automatically updated when you edit a markdown file, though you do have to refresh the browser to see these changes. Eclipse later revisions have a decent markdown editor build in.

## License

The contents of this repository are made available to the public under the terms of the [Apache License, Version 2.0](https://www.apache.org/licenses/LICENSE-2.0)

## Contributing

Want to hack on osgi.enroute.site? There are [instructions](CONTRIBUTING.md) to get you
started.

They are probably not perfect, please let us know if anything feels
wrong or incomplete.

[enroute]: http://enroute.osgi.org
[jekyll]: http://jekyllrb.com/
