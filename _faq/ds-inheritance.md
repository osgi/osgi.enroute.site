---
title: Why does DS Annotations not support inheritance?
summary: It seems logical to inherit the annotations for the bind methods and activate from a super class. This FAQ explains why it is not officially supported so far.
---

Felix Meschberger answered this question very eloquently on a question on the Bndtools list:

> You might be pleased to hear that at the Apache Felix project we once had this feature in our annotations. From that we tried to standardize it actually.
>
> The problem, though, is that we get a nasty coupling issue here between two implementation classes across bundle boundaries and we cannot express this dependency properly using Import-Package or Require-Capability headers.
>
> Some problems springing to mind:
>
> Generally you want to make bind/unbind methods private. Would it be ok for SCR to call the private bind method on the base class ?(It can technically be done, but would it be ok).
> What if we have private methods but the implementor decides to change the name of the private methods — after all they are private and not part of the API surface. The consumer will fail as the bind/unbind methods are listed in the descriptors provided by/for the extension class and they still name the old method names.
> If we don’t support private method names for that we would require these bind/unbind methods to be protected or public. And thus we force implementation-detail methods to become part of the API. Not very nice IMHO.
Note: package private methods don’t work as two different bundles should not share the same package with different contents.
>
> We argued back then that it would be ok-ish to have such inheritance within a single bundle but came to the conclusion that this limitation, the explanations around it, etc. would not be worth the effort. So we dropped the feature again from the roadmap.

This all said, if you still want to try to shoot yourself in the foot: Bnd already supports this with -dsannotations-options: inherit. 
