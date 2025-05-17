# AILERON Gateway Website

**[https://aileron-project.github.io/](https://aileron-project.github.io/)**

## Run website on local

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
- `hugo server`

## Add new project

1. Add project name in [.github/workflows/gh-pages.yaml](.github/workflows/gh-pages.yaml).
   1. Project name should go in the `jobs.build.strategy.matrix`.
2. Create project folder in [content/](content/).
   1. Copy example folder [content/aileron-test/](content/aileron-test/) and rename it.
   2. Modify content of copied markdowns.
3. Commit changes.

## Document directory structure

Documents must be in `docs/website/`.
See the example documents in [aileron-test/](aileron-test/).

If documents are in following structure,

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
