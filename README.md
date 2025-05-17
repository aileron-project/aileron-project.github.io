# AILERON Projects Website

**[https://aileron-project.github.io/](https://aileron-project.github.io/)**

This repository contains website contents

## Documentation mechanism

In additions to the documentation managed in this repository, documentations of sub-projects are also aggregated and hosted.

This idea is just like [Antra](https://antora.org/) which is used by [Spring project](https://spring.io/projects).
But we do not use [Antra](https://antora.org/) to keep this project and documentation mechanism quite simple.

Document aggregation is scripted in

- GitHub workflow ([.github/workflows/gh-pages.yaml](.github/workflows/gh-pages.yaml)).
- Shell Script ([make.sh](make.sh) called from the workflow).
- Make ([Makefile](Makefile) called from the shell).

Scripts fetch documents from tag with semantic version `^v[0-9]+.[0-9]+.[0-9]+$`.

```mermaid
block-beta
  columns 4

  space:1
  website["🟪 <b>aileron-project.github.io</b></br>(This repository)"]:2
  space:1

  space:4

  project1["🟩 <b>Sub Project Foo</b></br>TAG: v1.0.0</br>TAG: v1.0.1</br>TAG: v1.0.3</br>..."]
  project2["🟩 <b>Sub Project Bar</b></br>TAG: v2.1.0</br>TAG: v2.2.0</br>TAG: v2.3.0</br>..."]
  project3["......"]
  project4["🟩 <b>Sub Project Baz</b></br>TAG: v1.5.0</br>TAG: v1.5.1</br>TAG: v1.6.0</br>..."]

  website --"fetch"--> project1
  website --"fetch"--> project2
  website --"fetch"--> project3
  website --"fetch"--> project4
```

## Add new project

1. Add project name in [.github/workflows/gh-pages.yaml](.github/workflows/gh-pages.yaml).
   1. Project name should go in the `jobs.build.strategy.matrix`.
1. Create project folder in [content/](content/).
   1. Copy example folder [content/aileron-example/](content/aileron-example/) and rename it.
   1. Modify the contents of copied markdowns.
1. Add link in [hugo.yaml](hugo.yaml).
   1. Project link should go in the `params.versions`.
1. Commit changes.

## Document structure

Sub-projects must have documentation structure described here.

Documents must be saved in `docs/website/`.
See the example in [aileron-example/](aileron-example/).

If documents follow this structure,

```txt
${project-repo}/
└── docs/
    └── website/
        ├── _index.en.md
        ├── foo/
        │   ├── _index.en.md
        │   └── some-image.svg
        ├── bar/
        │   ├── index.en.md
        │   └── some-image.svg
        └── baz/
            ├── alice.en.md
            └── bob.en.md
```

the actual website structure becomes as follows.

```txt
${tag}/
├── foo          --- /${tag}/foo
├── bar          --- /${tag}/bar
└── baz/         --- /${tag}/baz
    ├── alice    --- /${tag}/baz/alice
    └── bob      --- /${tag}/baz/bob
```

Basically, using `_index.md` or `index.md` is strongly recommended.
And keep a single markdown file and embedded images in a single folder.
It makes it easy to embed images into markdowns because images can be referenced by relative path from the markdown. It also makes local preview available.

## Run website on local

NOTE: This step does not fetch documents from sub-projects.

Environment setup

- Install [Hugo Extended Version](https://gohugo.io/installation/).
- Install [Dart Sass](https://gohugo.io/functions/css/sass/#dart-sass).
- Install [Node.js](https://nodejs.org/).

Run on local

- `git clone --recursive  https://github.com/aileron-project/aileron-project.github.io.git`
- `cd aileron-project.github.io`
- `npm install`
- `cd themes/docsy/ && npm install`
- `cd ../../`
- `hugo server -D`

See also [hugo CLI documentations](https://gohugo.io/commands/hugo_server/).
