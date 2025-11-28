# overleaf-research-workspace

| action | status | notes |
|--------|--------| ------------|
| Last fetch of manuscript | ![Dynamic JSON Badge](https://img.shields.io/badge/dynamic/json?url=https%3A%2F%2Fraw.githubusercontent.com%2Fdmackinnon1%2Foverleaf-research-workspace%2Fmain%2Fmanuscript-fetch-status.json&query=lastBuild&style=flat-square&label=Last%20Fetch&labelColor=blue&color=black) | [overleaf-research-manuscript](https://github.com/dmackinnon1/overleaf-research-manuscript) is a submodule in this workspace repository| 
| Latest PDF of manuscript | ![Dynamic JSON Badge](https://img.shields.io/badge/dynamic/json?url=https%3A%2F%2Fraw.githubusercontent.com%2Fdmackinnon1%2Foverleaf-research-workspace%2Fmain%2Fpdf-build-status.json&query=lastBuild&style=flat-square&label=Last%20PDF-Compile&labelColor=blue&color=black)| [Download the latest PDF](main.pdf) |
| PDF accessibility verification | ![Dynamic Regex Badge](https://img.shields.io/badge/dynamic/regex?url=https%3A%2F%2Fraw.githubusercontent.com%2Fdmackinnon1%2Foverleaf-research-workspace%2Frefs%2Fheads%2Fmain%2Fa11y-statement.txt&search=(.)*ua2&label=Accessibility%20Test)|[Download the full report](a11y-report.json)|
| PDF showing recent changes | ![Dynamic JSON Badge](https://img.shields.io/badge/dynamic/json?url=https%3A%2F%2Fraw.githubusercontent.com%2Fdmackinnon1%2Foverleaf-research-workspace%2Fmain%2Flatexdiff-run-info.json&query=lastBuild&style=flat-square&label=Last%20latexdiff&labelColor=blue&color=black)|[Download the latest PDF with changes](diff.pdf)|
| MS Word conversion |  ![Dynamic JSON Badge](https://img.shields.io/badge/dynamic/json?url=https%3A%2F%2Fraw.githubusercontent.com%2Fdmackinnon1%2Foverleaf-research-workspace%2Fmain%2Fpandoc-run-info.json&query=lastBuild&style=flat-square&label=Last%20pandoc%20run&labelColor=blue&color=black)|[Obtain the latest MS Word version](main.docx) (no preview in GitHub, use download option)|

# What is a workspace repository?

This repository (overleaf-research-workspace) is an example project that illustrates how to set up a "workspace" repository as a companion to an Overleaf-linked manuscript repository. This example workspace is associated with the example manusecript repo [overleaf-research-management](https://github.com/dmackinnon1/overleaf-research-manuscript). The manuscript repository is a submodule of the workspace repository.

The workspace repository (overleaf-research-workspace) contains:
- The latest version of the compiled PDF for sharing.
- The results of running an accessibility test on the latest PDF
- A report showing recent changes in the manuscript
- Alternate formats of the manuscript (MS Word, HTML)
- Raw data for the project
- Scripts for generating artifacts used in the manuscript
- The manuscript source, as a submodule

The manuscript repository (overleaf-reseearch-manuscript) only contains the LaTeX source code required to build the manuscript. Organizing the research work in this way helps to keep the Overleaf-synched repository free from files that should not be included in the Overleaf project, helps to organize research artifacts and manage workflows. 

# Research workflows using GitHub Actions
Typical scientific workflows (data acquisition, data cleaning, analysis & generation, publishing/distributing) can be modeled using the software development and deployment approach known as CI/CD (Continuous Integration / Continuous Delivery). This approach makes the workflow reproducible and helps ensure the quality and consistency of its output, compared with add-hoc methods using local software.

GitHub Actions provide a simple CI/CD framework. [Overleaf's GitHub synchronization feature](https://docs.overleaf.com/integrations-and-add-ons/git-integration-and-github-synchronization/github-synchronization) provides an easy way to link Overleaf projects into a GitHub Action based workflow.

At first glance, "software delivery," the arena in which CI/CD is used most extensively, may seem worlds away from "scientific research." But the high-level arguments for using CI/CD in research are powerful because they directly address the biggest challenges in modern science: reproducibility, validation, and transparency. The core idea is to treat your scientific paper as the "product" and your code, data, and manuscript as the "source." CI/CD provides a philosophical framework for ensuring this product is built in an automated, reliable, and transparent way.

That being said, CI/CD in research workflows may look quite different than how it is used in software devivery. The CI/CD approach makes enormous sense in a software development setting because of how it helps teams coordinate their efforts. With CI/CD, QA tests can be run directly on checkin, and newly committed and tested code can be delivered right back to other developers, allowing for an incremental development process where code is always current and always tested. For the solo researcher or small team, the use and benefit of CI/CD is quite different, instead providing efficiency and reproducibility. 

The CI/CD workflows in scientific research may have less orchestration and less regidity, for example. In particular, the different actions presented in this example repository all use the `workflow dispatch` trigger (they are manually triggered), rather than being automatically triggered by specific changes or events. More specific automated triggers can be added if a more rigorous and automatic workflow is desired.

## Compiling the PDF

The workflow **Compile Manuscript PDF** [compile-manuscript-pdf.yml](https://raw.githubusercontent.com/dmackinnon1/overleaf-research-workspace/refs/heads/main/.github/workflows/compile-manuscript-pdf.yml) provides an example of how to install TeX Live and compile the main.tex file in the manuscript submodule.

There are several options when it comes to running LaTeX within GitHub Actions.

| option | description | notes|
|--------|-------------|------|
| [TinyTeX](https://yihui.org/tinytex/) | `uses: r-lib/actions/setup-tinytex@v2` | A lightweight minimal install (not full TeX Live) |
| [texlive container](https://hub.docker.com/r/texlive/texlive) | `container: texlive/texlive:latest` | A full TeX Live install using a docker container -- you can specify which release you need to use |
| [xu-cheng's latex action](https://github.com/xu-cheng/latex-action) | `uses: xu-cheng/latex-action@v3` | A popular action that wraps a tex live docker image |
| [xu-cheng's texlive container](https://github.com/xu-cheng/latex-docker) | `container: image: ghcr.io/xu-cheng/texlive-full:latest` | An alternate source for tex live |
| [xu-cheng's texlive action](https://github.com/xu-cheng/texlive-action) | `uses: xu-cheng/texlive-action@v3` | an action to use the tex live container|


## PDF accessibility testing
The LaTeX source code for the manuscript makes use of the latest PDF tagging support available in Tex Live 2025. Please see the LaTeX team's [tagging instructions](https://latex3.github.io/tagging-project/documentation/usage-instructions) for more information.  

The workflow **Check PDF Accessibility (veraPDF)** [a11y-report.yml](https://raw.githubusercontent.com/dmackinnon1/overleaf-research-workspace/refs/heads/main/.github/workflows/a11y-report.yml) provides an example of how to use the [veraPDF](https://github.com/veraPDF) docker container ([verapdf/cli](https://hub.docker.com/u/verapdf)) within an action to generate an accessibility report.

## Showing changes since the previous version

The tool `latexdiff` can be used to show the differences between two different .tex files. A particularly useful wrapper on `latexdiff` is [git-latexdiff](https://gitlab.com/git-latexdiff/git-latexdiff), which allows you to compare versions of a latex source file based on their commits within a repository. 

The workflow **Generate Diff PDF (latexdiff)** [generate-diff-latexdiff.yml](https://raw.githubusercontent.com/dmackinnon1/overleaf-research-workspace/refs/heads/main/.github/workflows/generate-diff-latexdiff.yml) shows a simple application of this, comparing the current version ion the repository to the previous commit.

## Generating alternate formats

[Pandoc](https://pandoc.org/) is a popular document conversion tool, and can be used to convert LaTeX source to MS Word (sometimes required). When it comes to converting LaTeX source to MS Word, there are no guarantees -- results vary depending on the formatting that has been applied in the LaTeX document. 

The workflow **Convert to Word (pandoc)** [convert-to-word-pandoc.yml](https://raw.githubusercontent.com/dmackinnon1/overleaf-research-workspace/refs/heads/main/.github/workflows/convert-to-word-pandoc.yml) shows how to invoke pandoc using the [pandoc action](https://github.com/pandoc/pandoc-action-example)  
