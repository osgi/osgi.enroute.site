# OSGi enRoute Web Site

This repository holds the OSGi enRoute website hosted at [http://enroute.osgi.org][enroute]. This web site is maintained as markdown and turned into HTML by [Jekyll][jekyll] using [GitHub Pages](https://help.github.com/articles/what-are-github-pages/). We have the following layout in the root folder:

* _book – Is the main set of chapters. The entries are listed in the nav bar
* _qs – Quick Start Tutorial
* _services – The Services Catalog
* _tutorial_base – The base tutorial
* ... – miscellaneous stuff, should be clear for someone with some web experience 

## Run Local

To run Jekyll locally:

	$ bundle exec jekyll serve -w

## Contributing

Want to hack on osgi.enroute.site? See [CONTRIBUTING.md](CONTRIBUTING.md) for information on building, testing and contributing changes.

They are probably not perfect, please let us know if anything feels
wrong or incomplete.

## License

The contents of this repository are made available to the public under the terms of the [Apache License, Version 2.0](https://www.apache.org/licenses/LICENSE-2.0)

[enroute]: http://enroute.osgi.org
[jekyll]: http://jekyllrb.com/
