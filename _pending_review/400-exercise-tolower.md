---
title: Exercise To Lower
layout: tutorial
prev: 300-application.html
next: 410-exercise-service.html
summary: A tiny exercises in extending the OSGi enRoute Demo App
---

In the previous section we created a fresh clean OSGi enRoute demo application based on Angular and Bootstrap. In this section we have a number of exercises that you can use to find out if the explanations were sufficient. (If not, fork and send a pull request, we love to be forked!)

## To Lower

The demo application turns the word into an upper case word. Let's make the first exercise really trivial and turn it into lower case. The `UpperApplication` class contains the code that is called from the REST interface. You can change the method to:

	public String getUpper(RESTRequest rq, String string) {
		return string.toLowerCase();
	}

