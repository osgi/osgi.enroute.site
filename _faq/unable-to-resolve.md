---
title: Can't Resolve!
summary: What to do when you cannot resolve a bndrun file
---

If you run in the problem that you can't resolve and have a problem understanding, here are some tips.

First, try to resolve ONLY the provider (i.e. is the only requirement in the bndrun file) and see what it says. Likely the provider has a problem. You could also add the bundle that is reported as the last item in the diagnostic information from the resolver in the blacklist in your bndrun file. For example:

	-runblacklist.eval:	\
		osgi.identity;filter:=‘(osgi.identity=com.example.foo.provider)

The resolver will then probably provide the next thing it cannot resolve. Which unfortunately is often quite logical and simple :-(

The resolver is pretty bad in telling what the culprit is. The reason is that it uses back-tracking. So the diagnostics are basically the last thing that was tried. 