---
title: The Bndtools Workspaces
summary: How to work with workspaces
---

A common recurring theme on the Bndtools and OSGi enRoute mailing lists is that people, usually from the Maven world, hate the bnd workspace model. The fact that there is a `cnf` directory (like the `.git` directory in Git) and that the project directories must be on the same level as the `cnf` directory is seen as an (often HUGE) constraint. 

## Reasons

The reason that bnd works this way is mostly driven by the simplicity of the model: 

* Since a workspace is a single directory it becomes very easy to recreate it at another place, just like Git does.
* Tools become simpler because everything is in one place and the top level directories are always projects. I.e. the file system exactly represents the structure so no mapping is required. So if we're looking for a bundle, we know the directory is the Bundle Symbolic Name.
* The `cnf` directory playes the same role as the `.git` directory in Git. It marks the workspace as a bnd workspace and contains shared configuration information. In the Maven world, this role is often played by the parent POM in a multi-module setup.

Simplicity pays off in many different places.

## Perspective

In the Maven world every project is stand-alone and coupled via the groupId/artifactId/version coordinates that each stand-alone project has. All interaction goes indrectly through the .m2 repository. However, in practice many projects are quite close together and share common information. That is why in the Maven world real world projects often use the     




