### A Pluto.jl notebook ###
# v0.19.27

using Markdown
using InteractiveUtils

# This Pluto notebook uses @bind for interactivity. When running this notebook outside of Pluto, the following 'mock version' of @bind gives bound variables a default value (instead of an error).
macro bind(def, element)
    quote
        local iv = try Base.loaded_modules[Base.PkgId(Base.UUID("6e696c72-6542-2067-7265-42206c756150"), "AbstractPlutoDingetjes")].Bonds.initial_value catch; b -> missing; end
        local el = $(esc(element))
        global $(esc(def)) = Core.applicable(Base.get, el) ? Base.get(el) : iv(el)
        el
    end
end

# ╔═╡ 1c640715-9bef-4935-9dce-f94ff2a3740b
begin
	using PlutoUI, PlutoTest, PlutoTeachingTools
end

# ╔═╡ 0b431bf7-1f57-40c4-ad0c-012cbdbf9528
md"> Astro 528: High-Performance Scientific Computing for Astrophysics (Fall 2023)"

# ╔═╡ a21b553b-eecb-4105-a0ed-d936e500788b
ChooseDisplayMode()

# ╔═╡ afe9b7c1-d031-4e1f-bd5b-5aeed30d7048
md"ToC on side $(@bind toc_aside CheckBox(;default=true))"

# ╔═╡ 080d3a94-161e-4482-9cf4-b82ffb98d0ed
TableOfContents(aside=toc_aside)

# ╔═╡ 959f2c12-287c-4648-a585-0c11d0db812d
md"""
# Week 12 Discussion Topics
- Reproduciblity & Replicability
   - Code behind the figures
   - Sharing code
- Package managers & Environments
   - Creating your own package
   - Registering your own package
- Reproducibile Computing Environments
   - Julia
   - Docker/Singularity
- Q&A
"""

# ╔═╡ 7d9df421-8bdc-4876-90e4-6d8d437a2385
md"""
# Reproducibility & Replicability
"""

# ╔═╡ 6fdd5ec6-3761-4c31-84a3-b9f394a0febb
md"""
## Data behind the figures
- [AAS Journals Data Guide](https://journals.aas.org/data-guide/#machine_readable_tables)
- [AAS Web converter](https://authortools.aas.org/MRT/upload.html)

- **NASA grants:**  
   - ``At a minimum the Data Management Plan (DMP) for ROSES must explain how you will release the data needed to reproduce figures, tables and other representations in publications, at the time of publication. Providing this data via supplementary materials with the journal is one really easy way to do this and it has the advantage that the data and the figures are linked together in perpetuity without any ongoing effort on your part.'' and
   - ``Software, whether a stand-alone program, an enhancement to existing code, or a module that interfaces with existing codes, created as part of a ROSES award, should be made publicly available when it is practical and feasible to do so, and when there is scientific utility in doing so... SMD expects that the source code, with associated documentation sufficient to enable use of the code, will be made publicly available as Open Source Software (OSS) under an appropriately permissive license (e.g., Apache-2, BSD-3-Clause, GPL). This includes all software developed with SMD funding used in the production of data products, as well as software developed to discover, access, visualize, and transform NASA data.'' -- [NASA SARA DMP FAQ](https://science.nasa.gov/researchers/sara/faqs/dmp-faq-roses)

- **NSF:** 
   - ``Investigators are expected to share with other researchers, at no more than incremental cost and within a reasonable time, the primary data, samples, physical collections and other supporting materials created or gathered in the course of work under NSF grants. Grantees are expected to encourage and facilitate such sharing.'' -- [NSF Data Management Plan Requirements](https://www.nsf.gov/bfa/dias/policy/dmp.jsp)
   - ``Providing software to read and analyze scientific data products can greatly increase value of these products. Investigators should use one of many software collaboration sites, like Github.com. These sites enable code sharing, collaboration and documentation at one location.'' -- [AST-specific Advice to PIs on the DMP](https://www.nsf.gov/bfa/dias/policy/dmpdocs/ast.pdf)

"""

# ╔═╡ 53a16e4d-ed25-4db3-9335-d79212a33f6a
md"""
## How to share code
### Old-school
- Source code for a few functions published as an appendix.
- Source code avaliable upon request.
- Source code avaliable from my website.

### Modern
Practical sharing of evolving code:
- [GitHub](http://github.com/)
- Institutional Git server (e.g., [PSU's GitLab](https://git.psu.edu/help/#getting-started-with-gitlab))
Archiving of code (& data):
- Dedicated archive with
   - Long-term plan
   - [Digital Object Identifier (DOI)](https://www.doi.org/) for your work
   - Standard file format
   - Metadata
- Examples:
   - [Zenodo](https://zenodo.org/) (by CERN)
   - [Dataverse](https://dataverse.harvard.edu/) (by Harvard)
   - [ScholarSphere](https://scholarsphere.psu.edu/) (by Penn State Libraries)
   - [Data Commons](https://www.datacommons.psu.edu/) (by Penn State EMS)
"""

# ╔═╡ 3f605c86-3083-4c38-bcb7-ba2eb93c867b
md"""
## Problems with sharing non-trivial codes
- Compiling for each processor/OS
- Linking to libraries
- Installing libraries that are needed
- Multi-step instructions (different for each OS) that become out-of-date
"""

# ╔═╡ 53a9051b-2f97-4d19-906e-0ba11e85a451
md"""
# Package managers
- Find package you request
- Indentify dependancies (direct & indirect).  
- Find versions that satisfy all requirements
- Download requested packaged & dependancies.
- Install requested packaged & dependancies.
- Perform any custom build steps.  
"""

# ╔═╡ d69a33e3-ef81-4aa2-9f31-4fbea2e74780
md"""
### What if you have two projects?
- Could let both projects think that they depend on everything the other depends on.
- If a dependancy breaks, which project(s) break?
- What if two projects require different versions?
⇒ Environments
"""

# ╔═╡ 92877d81-1545-4787-83c2-8dee3d43de6b
md"""
## Environments
Environments allow you to have multiple versions of packages installed and rapidly specify which versions you want made avaliable for the current session.  In Julia, 
- Project.toml:  Specifies direct dependencies & version constaints (required)

- Manifest.toml:  Specifies precise version of direct & indirect dependancies, so as to offer a fully reproducible environment (optional)

- If no Manifest.toml, then package manager can find most recent versions that satisfy Project.toml requirements.

`julia`
starts julia with default environment (separate environment for each minor version number, e.g., 1.9)

`julia --project=.` or `julia --project` starts julia using environment specified by Project.toml and Manifest.toml in current directory (if don't exist, will create them).

"""

# ╔═╡ 4368a43d-b468-4117-875a-4f1641ed4c48
blockquote(md"What is the difference between Project.toml and Manifest.toml?")

# ╔═╡ b860247e-204c-4f8a-9d74-c1350f83313c
md"""
**Project.toml** from Lab 3:

```code
name = "lab3"
uuid = "3355e5e9-99a6-4e94-be24-d3293f18bccc"
authors = ["Eric Ford <ebf11@psu.edu>"]
version = "0.1.0"

[deps]
BenchmarkTools = "6e4b80f9-dd63-53aa-95a3-0cdb28fa8baf"
CSV = "336ed68f-0bac-5ca0-87d4-7b16caf5d00b"
DataFrames = "a93c6f00-e57d-5684-b7b6-d8193f3e46c0"
FITSIO = "525bcba6-941b-5504-bd06-fd0dc1a4d2eb"
FileIO = "5789e2e9-d7fb-5bc7-8068-2c6fae9b9549"
InteractiveUtils = "b77e0a4c-d291-57a0-90e8-8db25a27a240"
JLD2 = "033835bb-8acc-5ee8-8aae-3f567f8a3819"
LaTeXStrings = "b964fa9f-0449-5b57-a5c2-d3ea65f4040f"
Markdown = "d6f4376e-aef5-505a-96c1-9c027394607a"
Plots = "91a5bcdd-55d7-5caf-9e0b-520d859cae80"
PlutoTeachingTools = "661c6b06-c737-4d37-b85c-46df65de6f69"
PlutoTest = "cb4044da-4d16-4ffa-a6a3-8cad7f73ebdc"
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
PyCall = "438e738f-606a-5dbb-bf0a-cddfbfd45ab0"
Query = "1a8c2f83-1ff3-5112-b086-8aa67b057ba1"
Random = "9a3f8284-a2c9-5f02-9a11-845980a1fd5c"
```
"""

# ╔═╡ a57dbad3-6153-428e-8e79-645297377d75
md"""
**Manifest.toml** from Lab 3:
```code
# This file is machine-generated - editing it directly is not advised

[[Adapt]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "84918055d15b3114ede17ac6a7182f68870c16f7"
uuid = "79e6a3ab-5dfb-504d-930d-738a2a938a0e"
version = "3.3.1"

[[ArgTools]]
uuid = "0dad84c5-d112-42e6-8d28-ef12dabb789f"

[[Artifacts]]
uuid = "56f22d72-fd6d-98f1-02f0-08ddc0907c33"

[[Base64]]
uuid = "2a0f44e3-6c83-55bd-87e4-b1978d98bd5f"

[[BenchmarkTools]]
deps = ["JSON", "Logging", "Printf", "Statistics", "UUIDs"]
git-tree-sha1 = "aa3aba5ed8f882ed01b71e09ca2ba0f77f44a99e"
uuid = "6e4b80f9-dd63-53aa-95a3-0cdb28fa8baf"
version = "1.1.3"

[[Bzip2_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "c3598e525718abcc440f69cc6d5f60dda0a1b61e"
uuid = "6e34b625-4abd-537c-b88f-471c36dfa7a0"
version = "1.0.6+5"

[[CFITSIO]]
deps = ["CFITSIO_jll"]
git-tree-sha1 = "c860f5545064216f86aa3365ec186ce7ced6a935"
uuid = "3b1b4be9-1499-4b22-8d78-7db3344d1961"
version = "1.3.0"

[[CFITSIO_jll]]
deps = ["Artifacts", "JLLWrappers", "LibCURL_jll", "Libdl", "Pkg"]
git-tree-sha1 = "2fabb5fc48d185d104ca7ed7444b475705993447"
uuid = "b3e40c51-02ae-5482-8a39-3ace5868dcf4"
version = "3.49.1+0"

[[CSV]]
deps = ["Dates", "Mmap", "Parsers", "PooledArrays", "SentinelArrays", "Tables", "Unicode"]
git-tree-sha1 = "b83aa3f513be680454437a0eee21001607e5d983"
uuid = "336ed68f-0bac-5ca0-87d4-7b16caf5d00b"
version = "0.8.5"
...
```
"""

# ╔═╡ 8f98ed9a-6453-4f59-a20d-753af5c847df
md"""
## Pluto & Package Management/Environments
Pluto has [it's own package manager](https://github.com/fonsp/Pluto.jl/wiki/%F0%9F%8E%81-Package-management)!
- Automatically creates a new temporary environment for each notebook, based on where it sees `using` or `import` and a package name.
   - Great for reproducibility
   - Adds a little extra startup time
- Each notebook embeds a Project.toml and Manifest.toml
- Can edit embedded environment 
```
import Pkg, Pluto
Pluto.activate_notebook_environment("~/Documents/hello.jl")
Pkg.update()
```
- Can revert to Julia's package manager by using 'Pkg.activate(path)' in notebook
- Can eliminate startup cost by reusing an existing environment
```julia
begin
    import Pkg
    # activate an existing project environment that 
	# can be shared across multiple sessions and/or notebooks
    Pkg.activate(Base.current_project())
	# load packages that are included in the existing Project.toml & installed
    using Plots, PlutoUI, LinearAlgebra
end
```
"""

# ╔═╡ 69b1eb2f-77f5-4be8-a7d6-d0a96492426d
blockquote(md"""
How does the paper writing process differ between the traditional publishing of scientific results/discoveries versus software developments (such as a the creation of a simulation, a package for scientific use, or a data pipeline)?
""")

# ╔═╡ 1448a5f5-3338-400f-afab-cea76667367a
md"""
[AAS Guidelines for software articles](https://journals.aas.org/policy-statement-on-software/)

AAS Journals welcome articles which describe the design and function of software of relevance to research in astronomy and astrophysics. Such articles should contain a description of the software, its novel features and its intended use. Such articles need not include research results produced using the software, although including examples of applications can be helpful. There is no minimum length requirement for software articles.

If a piece of novel software is important to published research then it is likely appropriate to describe it in such an article.
...
"""

# ╔═╡ 0ad3b202-f19c-433e-bb63-81b5e0475561
md"""
# Creating your own package
- Create a bare-bones package (Project.toml and `src/ExamplePkg.jl` that contains a module named `ExamplePkg`) by 
```shell
mkdir fresh_directory
cd fresh_directory
julia -e 'using Pkg; Pkg.generate("ExamplePkg")'
```
- Add packages that your package will depend on.
```julia
using Pkg
Pkg.activate(".")
Pkg.add(["CSV","DataFrames"])
```
- Install packages that your package depends on (and generates Manifest.toml if missing):
```julia
using Pkg
Pkg.activate(".")
Pkg.instantiate()
```
- Access your barebones package by
```julia
using Pkg
Pkg.activate(".")
using ExamplePkg
```
- In [Lab 9](https://github.com/PsuAstro528/lab9-start) will connect to GitHub and add other key package components (e.g., license, tests, etc.)

"""

# ╔═╡ 1b50b18f-1ce6-4ea7-81b3-4b1024736509
md"""
### Register your package
**Q:** How can a package be added to a registry?"

**A:** [Registrator.jl](https://github.com/JuliaRegistries/Registrator.jl)

!["amelia robot logo"](https://raw.githubusercontent.com/JuliaRegistries/Registrator.jl/master/graphics/logo.png)

Registrator is a GitHub app that automates creation of registration pull requests for your julia packages to the [General](https://github.com/JuliaRegistries/General) registry. Install the app below!
"""

# ╔═╡ de682378-9bf5-46d9-bf35-16480dc61327
Foldable("Detailed instructions",
md"""
## Install Registrator:

[![install](https://img.shields.io/badge/-install%20app-blue.svg)](https://github.com/apps/juliateam-registrator/installations/new)

Click on the "install" button above to add the registration bot to your repository

## How to Use

There are two ways to use Registrator: a web interface and a GitHub app.

### Via the Web Interface

This workflow supports repositories hosted on either GitHub or GitLab.

Go to https://juliahub.com and log in using your GitHub or GitLab account. Then click on "Register packages" on the left menu.
There are also more detailed instructions [here](https://juliaregistries.github.io/Registrator.jl/stable/webui/#Usage-(For-Package-Maintainers)-1).

### Via the GitHub App

Unsurprisingly, this method only works for packages whose repositories are hosted on GitHub.

The procedure for registering a new package is the same as for releasing a new version.  

If the registration bot is not added to the repository, `@JuliaRegistrator register` will not result in package registration.

1. Click on the "install" button above to add the registration bot to your repository
2. Set the [`(Julia)Project.toml`](Project.toml) version field in your repository to your new desired `version`.
3. Comment `@JuliaRegistrator register` on the commit/branch you want to register (e.g. like [here](https://github.com/JuliaRegistries/Registrator.jl/issues/61#issuecomment-483486641) or [here](https://github.com/chakravala/Grassmann.jl/commit/3c3a92610ebc8885619f561fe988b0d985852fce#commitcomment-33233149)).
4. If something is incorrect, adjust, and redo step 2.
5. If the automatic tests pass, but a moderator makes suggestions (e.g., manually updating your `(Julia)Project.toml` to include a [compat] section with version requirements for dependencies), then incorporate suggestions as you see fit into a new commit, and redo step 2 _for the new commit_.  You don't need to do anything to close out the old request.
6. Finally, either rely on the [TagBot GitHub Action](https://github.com/marketplace/actions/julia-tagbot) to tag and make a github release or alternatively tag the release manually.

Registrator will look for the project file in the master branch by default, and will use the version set in the `(Julia)Project.toml` file via, for example, `version = "0.1.0"`. To use a custom branch comment with:

```
@JuliaRegistrator register branch=name-of-your-branch
```

```
@JuliaRegistrator register

Release notes:

- Check out my new features!
```
""")

# ╔═╡ 316b2027-b3a6-45d6-9b65-e26b4ab42e5e
md"""
# Overview Reproduciblity & Julia 
- Environment usually contains multiple packages
   - One environment for each big task (e.g., pipeline for analyzing data from an instrument, performing simulations for one paper)
- Package contains one module (and often more sub-modules)
   - Set of code that is installed together
   - Perform tasks with similar purpose (e.g., working with common statistical distributions, manipulating positive-definite matrices)
- Module typically contains multiple functions
   - Closely related functions (e.g., mutating/non-mutating, basic/advanced interface, different algorithms to compute same thing)
   - Export functions that are intended for others to call
   - Don't export internal functions that perform each small piece of export functions
   - May not export functions with common names (e.g., `CSV.read`, `CSV.write`)

"""

# ╔═╡ b717a30b-0aa9-44ff-bcd0-f6c67441d5ce
md"""
# Reproduciblity for multi-language projects

**Q:** Is it possible to add packages that aren't written in Julia?

**A:** Options:
- Virtual Machines:  Most flexible & secure, but need to install and maintain _everything_, even the OS, security patches, etc.
- Containers:  Specify what software to be installed, but assume basic OS is provided.
   - [Docker](https://docs.docker.com/):  Currently most popular
   - [Singularity](https://singularity.hpcng.org/):  More common in supercomputing environments
"""

# ╔═╡ 33470afe-08d0-4639-b1ff-92591a416cb0
md"""
**Q:** If the hardware/processor changes, will the container still work or a new container have to be developed?

**A:** It depends on whether the new processor is in the same family and whether code was compiled for general or specific processor.  If your code doesn't need low-level access to hardware, then specify an environment means you don't need to worry about those changes.
"""

# ╔═╡ b6b281af-64a1-44b4-a9b6-ee0ba17f5c0b
md"""
# Selected Questions
"""

# ╔═╡ 44258160-f9e9-4361-bf16-402edb61a65b
md"""
**Q:** Is developing a package something that we will likely do many times in the future if we are writing new code for our projects? Or is it only something we would use if we are writing code that we want lots of other researchers to be able to use?

**A:**
It depends:
- Code for running the simulations in a paper (or series of closely related papers):  Likely a package, perhaps more than one.
- Code for all figures in a paper:  Likely a git repo, but probably not a package. 
- Code for one figure:  Not a package.  Likely a script or directory of files in a git repo.
"""

# ╔═╡ 2ef9d590-2ecd-4123-92ad-d972d5aa8c88
md"""
**Q:** What is the difference between the 'add' command and the 'dev' command?  
And what are the uses of each?

**A:** 
- `Pkg.add` specifies a package (git repository) that will be used 'as-is'.  Changing the files at that local (whether registered package, url or local path) will *not* automatically propagate to your code.  
- `Pkg.develop` specifies to use (or create if necessary) a local git repository and julia will load code using the current files in that path (even if they are not committed, pushed, or versioned).

Use `add`:
- to start using a registered package.
- to make a reproducible environment for your final code/data/figures.
Use `develop`:
- while you're working on developing your package
- to your personal fork on someone else's package, if you need to modify it (and consider submitting a pull request).
"""

# ╔═╡ 74b6d7b2-c09d-4d14-805b-969bdd1f0cbf
md"""**Q:** 
How do we make sure the right packages are added when someone else runs our code without telling it to install the package every time (since we'll already have it, or they will after the first time they run it)?

**A:** `Pkg.instantiate()` makes sure they have the right packages installed.  That may require installing packages.  
"""

# ╔═╡ de28eb94-6d7d-44c4-848c-5db84495939b
tip(md"""For running programs many times, check out [PackageCompiler.jl](https://julialang.github.io/PackageCompiler.jl/stable/index.html) or [Comonicon.jl](https://github.com/comonicon/Comonicon.jl#zero-duplication).  These are particularly useful for small programs that will be run often.  

For speeding startup of packages (rather than programs), condiser using `precompile`, as described in [this tutorial](https://julialang.org/blog/2021/01/precompile_tutorial/).""")

# ╔═╡ 9e6d77dd-4743-428a-b12b-23e8125fcaa9
tip(md"""Just like `]` puts you in *Package Manager Mode* from inside the Julia REPL...

`?` puts in you *Help mode*, and 

`;` puts you in *shell mode*.""")

# ╔═╡ 1ce7ef5b-c213-47ba-ac96-9622b62cda61
md"""
# Project Updates
- Second parallel version of code (distributed-memory/GPU/cloud) (due Nov 18)
- Completed code, documentation, tests, packaging (optional) & reflection (due Dec 2)
- Class presentations (Nov 29 - Dec 9, [schedule](https://github.com/PsuAstro528/PresentationsSchedule2021/blob/main/README.md) )
"""

# ╔═╡ 24cb813e-af85-435f-9c43-db38e8eaa1d2
md"""## Project Rubrics

### Second parallelization method
- Choice of portion of code to parallelize (1 point)
- Choice of approach for parallelizing code (1 point)
- Code performs proposed tasks (2 point)
- Unit/regression tests comparing serial & parallel versions (1 point)
- Code passes tests (1 point)
- General code efficiency (1 point)
- Implementation/optimization of second type of parallelism (2 points)
- Significant performance improvement (1 point)


### Final Project Submission
- Results of benchmarking code (typically included in project README, but more comprehensive benchmarking could be in a separate document, notebook or directory)
   - Performance versus problem size for fixed number of workers (1 point)
   - Performance versus number of workers for fixed problem size (1 point)
- Documentation:  
   - README:  (1 point)
      - Project overview
      - Instructions on how to install and run code
      - CI testing or detailed instructions on how to rerun tests
      - Results of benchmarking and/or pointer to where results can be found
      - Overview of code/package structure (if project is larger than one notebook)
   - Docstrings: Coverage, clarity and quality (1 point)
- Summary of lessons learned (1 point)

### Project Presentation
- Motivation/Introduction/Overview of project, so class can understand broader goals (1 point)
- Explanation of specific calculation being performed, so class can understand what follows (1 point)
- Description of optimization and parallelziation approaches attempted (1 point)
- Analysis/explanation
   - Identify most time consuming part(s) of calculations and specify what is being benchmarked (0 points)
   - Benchmarks of how performance of each version scales with problem size for fixed number of workers (1/2 point)
   - Benchmarks of how performance of parallel versions scales with nubmer of workers for given problem size (1/2 point)
- Description/analysis/discussion of what lessons you learned from the class project (1 point)

"""

# ╔═╡ f69f32fc-f759-4567-9c1c-37676eaf713d
md"# Old Questions"

# ╔═╡ 085a5b76-ab3e-4447-b6a3-df4bf3f0d9e9
md"""
**Q:** What is a .toml file?

**A:** [Tom's Obvious Markup Language](https://github.com/toml-lang/toml).  
"""

# ╔═╡ 9981f6ca-baf1-4d3f-be7a-30722b489026
md"""
**Q:** What actually happens when you type the ']' key in the Julia terminal?

**A:** Enters package manager mode to save typing.  E.g.,
```julia
import Pkg
Pkg.activate(".")
Pkg.add("Random")
Pkg.instantiate()
Pkg.status()
```
becomes `]` followed by
```pkg
activate
add Random
instantiate
status
```


**Q:** In python, there isn't an analog to this, is there?

**A:** Does anyone know?
"""

# ╔═╡ 1d10dfa2-f7cc-4a82-8742-4891f190e79e
md"""
**Q:** Is adding packages in Julia the analog of pip install ... in python?

**A:** Probably similar, but might be different in detail.  Anyone know?
"""

# ╔═╡ b8899c70-5af1-4e15-bb16-f1438629bd10
md"""
**Q:** 
"""

# ╔═╡ 6c1aeeb5-e9ab-419c-9984-d9787ff8c531
md"""
**Q:** 
"""

# ╔═╡ 367b496f-a673-4cca-a96b-01bc7de816f6
md"""
**Q:** 
"""

# ╔═╡ 8759b216-cc38-42ed-b85c-04d508579c54
md"# Helper Code"

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
PlutoTeachingTools = "661c6b06-c737-4d37-b85c-46df65de6f69"
PlutoTest = "cb4044da-4d16-4ffa-a6a3-8cad7f73ebdc"
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"

[compat]
PlutoTeachingTools = "~0.2.13"
PlutoTest = "~0.2.2"
PlutoUI = "~0.7.53"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.9.2"
manifest_format = "2.0"
project_hash = "e48d3b81fec411867156554db292ac07b7b0251e"

[[deps.AbstractPlutoDingetjes]]
deps = ["Pkg"]
git-tree-sha1 = "91bd53c39b9cbfb5ef4b015e8b582d344532bd0a"
uuid = "6e696c72-6542-2067-7265-42206c756150"
version = "1.2.0"

[[deps.ArgTools]]
uuid = "0dad84c5-d112-42e6-8d28-ef12dabb789f"
version = "1.1.1"

[[deps.Artifacts]]
uuid = "56f22d72-fd6d-98f1-02f0-08ddc0907c33"

[[deps.Base64]]
uuid = "2a0f44e3-6c83-55bd-87e4-b1978d98bd5f"

[[deps.CodeTracking]]
deps = ["InteractiveUtils", "UUIDs"]
git-tree-sha1 = "c0216e792f518b39b22212127d4a84dc31e4e386"
uuid = "da1fd8a2-8d9e-5ec2-8556-3022fb5608a2"
version = "1.3.5"

[[deps.ColorTypes]]
deps = ["FixedPointNumbers", "Random"]
git-tree-sha1 = "eb7f0f8307f71fac7c606984ea5fb2817275d6e4"
uuid = "3da002f7-5984-5a60-b8a6-cbb66c0b333f"
version = "0.11.4"

[[deps.CompilerSupportLibraries_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "e66e0078-7015-5450-92f7-15fbd957f2ae"
version = "1.0.5+0"

[[deps.Dates]]
deps = ["Printf"]
uuid = "ade2ca70-3891-5945-98fb-dc099432e06a"

[[deps.Distributed]]
deps = ["Random", "Serialization", "Sockets"]
uuid = "8ba89e20-285c-5b6f-9357-94700520ee1b"

[[deps.Downloads]]
deps = ["ArgTools", "FileWatching", "LibCURL", "NetworkOptions"]
uuid = "f43a241f-c20a-4ad4-852c-f6b1247861c6"
version = "1.6.0"

[[deps.FileWatching]]
uuid = "7b1f6079-737a-58dc-b8bc-7a2ca5c1b5ee"

[[deps.FixedPointNumbers]]
deps = ["Statistics"]
git-tree-sha1 = "335bfdceacc84c5cdf16aadc768aa5ddfc5383cc"
uuid = "53c48c17-4a7d-5ca2-90c5-79b7896eea93"
version = "0.8.4"

[[deps.Formatting]]
deps = ["Printf"]
git-tree-sha1 = "8339d61043228fdd3eb658d86c926cb282ae72a8"
uuid = "59287772-0a20-5a39-b81b-1366585eb4c0"
version = "0.4.2"

[[deps.Hyperscript]]
deps = ["Test"]
git-tree-sha1 = "8d511d5b81240fc8e6802386302675bdf47737b9"
uuid = "47d2ed2b-36de-50cf-bf87-49c2cf4b8b91"
version = "0.0.4"

[[deps.HypertextLiteral]]
deps = ["Tricks"]
git-tree-sha1 = "7134810b1afce04bbc1045ca1985fbe81ce17653"
uuid = "ac1192a8-f4b3-4bfe-ba22-af5b92cd3ab2"
version = "0.9.5"

[[deps.IOCapture]]
deps = ["Logging", "Random"]
git-tree-sha1 = "d75853a0bdbfb1ac815478bacd89cd27b550ace6"
uuid = "b5f81e59-6552-4d32-b1f0-c071b021bf89"
version = "0.2.3"

[[deps.InteractiveUtils]]
deps = ["Markdown"]
uuid = "b77e0a4c-d291-57a0-90e8-8db25a27a240"

[[deps.JSON]]
deps = ["Dates", "Mmap", "Parsers", "Unicode"]
git-tree-sha1 = "31e996f0a15c7b280ba9f76636b3ff9e2ae58c9a"
uuid = "682c06a0-de6a-54ab-a142-c8b1cf79cde6"
version = "0.21.4"

[[deps.JuliaInterpreter]]
deps = ["CodeTracking", "InteractiveUtils", "Random", "UUIDs"]
git-tree-sha1 = "0592b1810613d1c95eeebcd22dc11fba186c2a57"
uuid = "aa1ae85d-cabe-5617-a682-6adf51b2e16a"
version = "0.9.26"

[[deps.LaTeXStrings]]
git-tree-sha1 = "50901ebc375ed41dbf8058da26f9de442febbbec"
uuid = "b964fa9f-0449-5b57-a5c2-d3ea65f4040f"
version = "1.3.1"

[[deps.Latexify]]
deps = ["Formatting", "InteractiveUtils", "LaTeXStrings", "MacroTools", "Markdown", "OrderedCollections", "Printf", "Requires"]
git-tree-sha1 = "f428ae552340899a935973270b8d98e5a31c49fe"
uuid = "23fbe1c1-3f47-55db-b15f-69d7ec21a316"
version = "0.16.1"

    [deps.Latexify.extensions]
    DataFramesExt = "DataFrames"
    SymEngineExt = "SymEngine"

    [deps.Latexify.weakdeps]
    DataFrames = "a93c6f00-e57d-5684-b7b6-d8193f3e46c0"
    SymEngine = "123dc426-2d89-5057-bbad-38513e3affd8"

[[deps.LibCURL]]
deps = ["LibCURL_jll", "MozillaCACerts_jll"]
uuid = "b27032c2-a3e7-50c8-80cd-2d36dbcbfd21"
version = "0.6.3"

[[deps.LibCURL_jll]]
deps = ["Artifacts", "LibSSH2_jll", "Libdl", "MbedTLS_jll", "Zlib_jll", "nghttp2_jll"]
uuid = "deac9b47-8bc7-5906-a0fe-35ac56dc84c0"
version = "7.84.0+0"

[[deps.LibGit2]]
deps = ["Base64", "NetworkOptions", "Printf", "SHA"]
uuid = "76f85450-5226-5b5a-8eaa-529ad045b433"

[[deps.LibSSH2_jll]]
deps = ["Artifacts", "Libdl", "MbedTLS_jll"]
uuid = "29816b5a-b9ab-546f-933c-edad1886dfa8"
version = "1.10.2+0"

[[deps.Libdl]]
uuid = "8f399da3-3557-5675-b5ff-fb832c97cbdb"

[[deps.LinearAlgebra]]
deps = ["Libdl", "OpenBLAS_jll", "libblastrampoline_jll"]
uuid = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"

[[deps.Logging]]
uuid = "56ddb016-857b-54e1-b83d-db4d58db5568"

[[deps.LoweredCodeUtils]]
deps = ["JuliaInterpreter"]
git-tree-sha1 = "60168780555f3e663c536500aa790b6368adc02a"
uuid = "6f1432cf-f94c-5a45-995e-cdbf5db27b0b"
version = "2.3.0"

[[deps.MIMEs]]
git-tree-sha1 = "65f28ad4b594aebe22157d6fac869786a255b7eb"
uuid = "6c6e2e6c-3030-632d-7369-2d6c69616d65"
version = "0.1.4"

[[deps.MacroTools]]
deps = ["Markdown", "Random"]
git-tree-sha1 = "9ee1618cbf5240e6d4e0371d6f24065083f60c48"
uuid = "1914dd2f-81c6-5fcd-8719-6d5c9610ff09"
version = "0.5.11"

[[deps.Markdown]]
deps = ["Base64"]
uuid = "d6f4376e-aef5-505a-96c1-9c027394607a"

[[deps.MbedTLS_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "c8ffd9c3-330d-5841-b78e-0817d7145fa1"
version = "2.28.2+0"

[[deps.Mmap]]
uuid = "a63ad114-7e13-5084-954f-fe012c677804"

[[deps.MozillaCACerts_jll]]
uuid = "14a3606d-f60d-562e-9121-12d972cd8159"
version = "2022.10.11"

[[deps.NetworkOptions]]
uuid = "ca575930-c2e3-43a9-ace4-1e988b2c1908"
version = "1.2.0"

[[deps.OpenBLAS_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "Libdl"]
uuid = "4536629a-c528-5b80-bd46-f80d51c5b363"
version = "0.3.21+4"

[[deps.OrderedCollections]]
git-tree-sha1 = "2e73fe17cac3c62ad1aebe70d44c963c3cfdc3e3"
uuid = "bac558e1-5e72-5ebc-8fee-abe8a469f55d"
version = "1.6.2"

[[deps.Parsers]]
deps = ["Dates", "PrecompileTools", "UUIDs"]
git-tree-sha1 = "716e24b21538abc91f6205fd1d8363f39b442851"
uuid = "69de0a69-1ddd-5017-9359-2bf0b02dc9f0"
version = "2.7.2"

[[deps.Pkg]]
deps = ["Artifacts", "Dates", "Downloads", "FileWatching", "LibGit2", "Libdl", "Logging", "Markdown", "Printf", "REPL", "Random", "SHA", "Serialization", "TOML", "Tar", "UUIDs", "p7zip_jll"]
uuid = "44cfe95a-1eb2-52ea-b672-e2afdf69b78f"
version = "1.9.2"

[[deps.PlutoHooks]]
deps = ["InteractiveUtils", "Markdown", "UUIDs"]
git-tree-sha1 = "072cdf20c9b0507fdd977d7d246d90030609674b"
uuid = "0ff47ea0-7a50-410d-8455-4348d5de0774"
version = "0.0.5"

[[deps.PlutoLinks]]
deps = ["FileWatching", "InteractiveUtils", "Markdown", "PlutoHooks", "Revise", "UUIDs"]
git-tree-sha1 = "8f5fa7056e6dcfb23ac5211de38e6c03f6367794"
uuid = "0ff47ea0-7a50-410d-8455-4348d5de0420"
version = "0.1.6"

[[deps.PlutoTeachingTools]]
deps = ["Downloads", "HypertextLiteral", "LaTeXStrings", "Latexify", "Markdown", "PlutoLinks", "PlutoUI", "Random"]
git-tree-sha1 = "542de5acb35585afcf202a6d3361b430bc1c3fbd"
uuid = "661c6b06-c737-4d37-b85c-46df65de6f69"
version = "0.2.13"

[[deps.PlutoTest]]
deps = ["HypertextLiteral", "InteractiveUtils", "Markdown", "Test"]
git-tree-sha1 = "17aa9b81106e661cffa1c4c36c17ee1c50a86eda"
uuid = "cb4044da-4d16-4ffa-a6a3-8cad7f73ebdc"
version = "0.2.2"

[[deps.PlutoUI]]
deps = ["AbstractPlutoDingetjes", "Base64", "ColorTypes", "Dates", "FixedPointNumbers", "Hyperscript", "HypertextLiteral", "IOCapture", "InteractiveUtils", "JSON", "Logging", "MIMEs", "Markdown", "Random", "Reexport", "URIs", "UUIDs"]
git-tree-sha1 = "db8ec28846dbf846228a32de5a6912c63e2052e3"
uuid = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
version = "0.7.53"

[[deps.PrecompileTools]]
deps = ["Preferences"]
git-tree-sha1 = "03b4c25b43cb84cee5c90aa9b5ea0a78fd848d2f"
uuid = "aea7be01-6a6a-4083-8856-8a6e6704d82a"
version = "1.2.0"

[[deps.Preferences]]
deps = ["TOML"]
git-tree-sha1 = "00805cd429dcb4870060ff49ef443486c262e38e"
uuid = "21216c6a-2e73-6563-6e65-726566657250"
version = "1.4.1"

[[deps.Printf]]
deps = ["Unicode"]
uuid = "de0858da-6303-5e67-8744-51eddeeeb8d7"

[[deps.REPL]]
deps = ["InteractiveUtils", "Markdown", "Sockets", "Unicode"]
uuid = "3fa0cd96-eef1-5676-8a61-b3b8758bbffb"

[[deps.Random]]
deps = ["SHA", "Serialization"]
uuid = "9a3f8284-a2c9-5f02-9a11-845980a1fd5c"

[[deps.Reexport]]
git-tree-sha1 = "45e428421666073eab6f2da5c9d310d99bb12f9b"
uuid = "189a3867-3050-52da-a836-e630ba90ab69"
version = "1.2.2"

[[deps.Requires]]
deps = ["UUIDs"]
git-tree-sha1 = "838a3a4188e2ded87a4f9f184b4b0d78a1e91cb7"
uuid = "ae029012-a4dd-5104-9daa-d747884805df"
version = "1.3.0"

[[deps.Revise]]
deps = ["CodeTracking", "Distributed", "FileWatching", "JuliaInterpreter", "LibGit2", "LoweredCodeUtils", "OrderedCollections", "Pkg", "REPL", "Requires", "UUIDs", "Unicode"]
git-tree-sha1 = "ba168f8fc36bf83c8d0573d464b7aab0f8a81623"
uuid = "295af30f-e4ad-537b-8983-00126c2a3abe"
version = "3.5.7"

[[deps.SHA]]
uuid = "ea8e919c-243c-51af-8825-aaa63cd721ce"
version = "0.7.0"

[[deps.Serialization]]
uuid = "9e88b42a-f829-5b0c-bbe9-9e923198166b"

[[deps.Sockets]]
uuid = "6462fe0b-24de-5631-8697-dd941f90decc"

[[deps.SparseArrays]]
deps = ["Libdl", "LinearAlgebra", "Random", "Serialization", "SuiteSparse_jll"]
uuid = "2f01184e-e22b-5df5-ae63-d93ebab69eaf"

[[deps.Statistics]]
deps = ["LinearAlgebra", "SparseArrays"]
uuid = "10745b16-79ce-11e8-11f9-7d13ad32a3b2"
version = "1.9.0"

[[deps.SuiteSparse_jll]]
deps = ["Artifacts", "Libdl", "Pkg", "libblastrampoline_jll"]
uuid = "bea87d4a-7f5b-5778-9afe-8cc45184846c"
version = "5.10.1+6"

[[deps.TOML]]
deps = ["Dates"]
uuid = "fa267f1f-6049-4f14-aa54-33bafae1ed76"
version = "1.0.3"

[[deps.Tar]]
deps = ["ArgTools", "SHA"]
uuid = "a4e569a6-e804-4fa4-b0f3-eef7a1d5b13e"
version = "1.10.0"

[[deps.Test]]
deps = ["InteractiveUtils", "Logging", "Random", "Serialization"]
uuid = "8dfed614-e22c-5e08-85e1-65c5234f0b40"

[[deps.Tricks]]
git-tree-sha1 = "eae1bb484cd63b36999ee58be2de6c178105112f"
uuid = "410a4b4d-49e4-4fbc-ab6d-cb71b17b3775"
version = "0.1.8"

[[deps.URIs]]
git-tree-sha1 = "67db6cc7b3821e19ebe75791a9dd19c9b1188f2b"
uuid = "5c2747f8-b7ea-4ff2-ba2e-563bfd36b1d4"
version = "1.5.1"

[[deps.UUIDs]]
deps = ["Random", "SHA"]
uuid = "cf7118a7-6976-5b1a-9a39-7adc72f591a4"

[[deps.Unicode]]
uuid = "4ec0a83e-493e-50e2-b9ac-8f72acf5a8f5"

[[deps.Zlib_jll]]
deps = ["Libdl"]
uuid = "83775a58-1f1d-513f-b197-d71354ab007a"
version = "1.2.13+0"

[[deps.libblastrampoline_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850b90-86db-534c-a0d3-1478176c7d93"
version = "5.8.0+0"

[[deps.nghttp2_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850ede-7688-5339-a07c-302acd2aaf8d"
version = "1.48.0+0"

[[deps.p7zip_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "3f19e933-33d8-53b3-aaab-bd5110c3b7a0"
version = "17.4.0+0"
"""

# ╔═╡ Cell order:
# ╟─0b431bf7-1f57-40c4-ad0c-012cbdbf9528
# ╟─080d3a94-161e-4482-9cf4-b82ffb98d0ed
# ╟─a21b553b-eecb-4105-a0ed-d936e500788b
# ╟─afe9b7c1-d031-4e1f-bd5b-5aeed30d7048
# ╟─959f2c12-287c-4648-a585-0c11d0db812d
# ╟─7d9df421-8bdc-4876-90e4-6d8d437a2385
# ╟─6fdd5ec6-3761-4c31-84a3-b9f394a0febb
# ╟─53a16e4d-ed25-4db3-9335-d79212a33f6a
# ╟─3f605c86-3083-4c38-bcb7-ba2eb93c867b
# ╟─53a9051b-2f97-4d19-906e-0ba11e85a451
# ╟─d69a33e3-ef81-4aa2-9f31-4fbea2e74780
# ╟─92877d81-1545-4787-83c2-8dee3d43de6b
# ╟─4368a43d-b468-4117-875a-4f1641ed4c48
# ╟─b860247e-204c-4f8a-9d74-c1350f83313c
# ╟─a57dbad3-6153-428e-8e79-645297377d75
# ╟─8f98ed9a-6453-4f59-a20d-753af5c847df
# ╟─69b1eb2f-77f5-4be8-a7d6-d0a96492426d
# ╟─1448a5f5-3338-400f-afab-cea76667367a
# ╟─0ad3b202-f19c-433e-bb63-81b5e0475561
# ╟─1b50b18f-1ce6-4ea7-81b3-4b1024736509
# ╟─de682378-9bf5-46d9-bf35-16480dc61327
# ╟─316b2027-b3a6-45d6-9b65-e26b4ab42e5e
# ╟─b717a30b-0aa9-44ff-bcd0-f6c67441d5ce
# ╟─33470afe-08d0-4639-b1ff-92591a416cb0
# ╟─b6b281af-64a1-44b4-a9b6-ee0ba17f5c0b
# ╟─44258160-f9e9-4361-bf16-402edb61a65b
# ╟─2ef9d590-2ecd-4123-92ad-d972d5aa8c88
# ╟─74b6d7b2-c09d-4d14-805b-969bdd1f0cbf
# ╟─de28eb94-6d7d-44c4-848c-5db84495939b
# ╟─9e6d77dd-4743-428a-b12b-23e8125fcaa9
# ╟─1ce7ef5b-c213-47ba-ac96-9622b62cda61
# ╟─24cb813e-af85-435f-9c43-db38e8eaa1d2
# ╟─f69f32fc-f759-4567-9c1c-37676eaf713d
# ╟─085a5b76-ab3e-4447-b6a3-df4bf3f0d9e9
# ╟─9981f6ca-baf1-4d3f-be7a-30722b489026
# ╟─1d10dfa2-f7cc-4a82-8742-4891f190e79e
# ╠═b8899c70-5af1-4e15-bb16-f1438629bd10
# ╠═6c1aeeb5-e9ab-419c-9984-d9787ff8c531
# ╠═367b496f-a673-4cca-a96b-01bc7de816f6
# ╟─8759b216-cc38-42ed-b85c-04d508579c54
# ╠═1c640715-9bef-4935-9dce-f94ff2a3740b
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
