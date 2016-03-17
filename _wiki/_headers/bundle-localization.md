---
title: Bundle-Localization
summary: Specify the location of the localization directory for internationalized messages
---

The `Bundle-Localization` is a reference to a set of properties files
which can be used to localise aspects of the bundle itself. If a header
value starts with a % then it is interpreted as being a key into a
property file. Furthermore, these may be replaced on a
language-by-language basis depending on the user's view of the
localisation.

This header is optional, but has an implied default of
`OSGI-INF/l10n/bundle`. This will resolve to a file in the bundle itself
with `bundle.properties` being the default and `bundle_en.properties`,
`bundle_fr.properties`, `bundle_de.properties` being used for English,
French and German respectively.

`Bundle-Localisation: path/to/my/properties/file`

[Localization](Category:Manifest Header "wikilink")

