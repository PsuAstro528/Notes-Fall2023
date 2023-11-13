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
# Week 13 Discussion Topics
- Cloud computing
- Q&A
"""

# ╔═╡ 6f4b5d3e-2f2b-44cb-809e-6a7f309880ee
md"""# Cloud Computing

## Cloud Services
- Productivity Tools:  Email, calenders, documents, spreadsheets, presentations
- Conferencing:  Zoom, Teams, etc.
- Web: website hosting, design, blogs, audo/videos streaming
- Databases: Oracle, AWS, IBM, 
- Commercial:  Storefront, payroll, etc.
- Programming:  GitHub, [Google Colaboratory](https://colab.google/), [Repl.it](https://replit.com/)
- Research data storage: [Zenodo](https://zenodo.org/), [Dataverse](https://dataverse.harvard.edu/) 

## Cloud services for programmers
- [GitHub](https://github.com/)
- [Binder](https://mybinder.org/)
- [JuliaHub](https://juliacomputing.com/products/juliahub/)
- Industry-focused:
  - [Domino Data Lab](https://www.dominodatalab.com/)
  - [MS Azure Notebooks](https://visualstudio.microsoft.com/vs/features/notebooks-at-microsoft/)
  - [Code Ocean](https://codeocean.com/)
  - Many more
- Science-focused:
   - [SciServer](https://idies.jhu.edu/what-we-offer/sciserver/)

"""

# ╔═╡ 89405d73-0d8f-465d-b1ea-43d74d25bbf8
md"""
## Big General-purpose Cloud Providers
- Amazon Web Services (AWS)
- Microsoft Azure
- Google Cloud Platform
- Alibaba
- Oracle
- Dell/VMWare
- IBM
"""

# ╔═╡ 0c7a11e0-c484-48bf-86f0-1de678c3ffbc
md"""
## [AWS Instance types](https://aws.amazon.com/ec2/instance-types/)

|Instance Size|	vCPU|	Memory (GiB)|	Instance Storage (GiB)|	Network Bandwidth (Gbps)|  EBS Bandwidth (Mbps)|
|-----------|---|---|-----------|-----------|--------------|
|c6g.medium		|1	|2		|EBS-Only		|Up to 10	|Up to 4,750|
|c6g.large		|2	|4		|EBS-Only		|Up to 10	|Up to 4,750|
|c6g.xlarge		|4	|8		|EBS-Only		|Up to 10	|Up to 4,750|
|c6g.2xlarge	|8	|16		|EBS-Only		|Up to 10	|Up to 4,750|
|c6g.4xlarge	|16	|32		|EBS-Only		|Up to 10	|4750|
|c6g.8xlarge	|32	|64		|EBS-Only		|12		|9000|
|c6g.12xlarge	|48	|96		|EBS-Only		|20		|13500|
|c6g.16xlarge	|64	|128	|EBS-Only		|25		|19000|
|c6g.metal		|64	|128	|EBS-Only		|25		|19000|
|c6gd.medium	|1	|2		|59 NVMe SSD	|Up to 10	|Up to 4,750|
|c6gd.large		|2	|4		|118 NVMe SSD	|Up to 10	|Up to 4,750|
|c6gd.xlarge	|4	|8		|237 NVMe SSD	|Up to 10	|Up to 4,750|
|c6gd.2xlarge	|8	|16		|474 NVMe SSD	|Up to 10	|Up to 4,750|
|c6gd.4xlarge	|16	|32		|950 NVMe SSD	|Up to 10	|4,750|
|c6gd.8xlarge	|32	|64		|1900 NVMe SSD	|12	|9,000|
|c6gd.12xlarge	|48	|96		|2x1425 NVMe SSD|20	|13,500|
|c6gd.16xlarge	|64	|128	|2x1900 NVMe SSD|25	|19,000|
|c6gd.metal		|64	|128	|2x1900 NVMe SSD|25	|19,000|

Multiple Pricing Models: 
- [On Demand](https://aws.amazon.com/ec2/pricing/on-demand/)
- [Spot](https://aws.amazon.com/ec2/spot/pricing/)
- [Dedicated](https://aws.amazon.com/ec2/dedicated-hosts/pricing/)

Beware of Data Transfer Costs:
- Transfer into AWS: free (so far)
- Tranfer out of AWS: [rates](https://aws.amazon.com/ec2/pricing/on-demand/) potentially significant.  But may be free option via Internet2.

""" 

# ╔═╡ 5061ee9d-d5ee-4c5c-9267-88c22f8973e4
md"""
## Trying to ease access to public clouds
- [Kubernetes (K8s)](https://kubernetes.io/)
For Julia:
- [AWS.jl](https://github.com/JuliaCloud/AWS.jl) (most mature)
- [Kuber.jl](https://github.com/JuliaComputing/Kuber.jl)
- [GoogleCloud.jl](https://juliacloud.github.io/GoogleCloud.jl/latest/)
- [MS Redwood](https://www.youtube.com/watch?v=LTTYXDb31GY) 
"""

# ╔═╡ d58e5f2d-d001-4ffb-b89d-27949e0b7633
md"""
## Academic Clouds
- [NSF Open Science Grid](https://opensciencegrid.org/)
- [Penn State High-Performance Research Cloud (HPRC)](https://www.icds.psu.edu/computing-services/roar-user-guide/#08-00-running-jobs-on-hprc)
"""

# ╔═╡ 6d3ee824-b4e1-466b-b611-7a6c4bfe196a
md"""
### [Penn State HPRC](https://www.icds.psu.edu/computing-services/roar-user-guide/#08-00-running-jobs-on-hprc)

Hardware:
- 2.5 GHz Intel Xeon Processor (Skylake series) 320 virtual cores/server, 
- 1TB RAM/server
- 100 Gbps Ethernet 

Job constraints:
- Memory per core (Pmem): < 8GB
- Memory per job: < 160GB
- Cores per job: <= 20
- Nodes per job: = 1
- Wall time: <=24 hours? (need to check)
"""

# ╔═╡ bbe742aa-8f41-4833-8b5b-5c79cf09b1ee
md"""
### [NSF Open Science Grid (OSG)](https://opensciencegrid.org/)

Designed for Distributed High-Throughput Computing
Good fit for OSG if:
- The application is a Linux application for the x86 or x86_64 architecture.
- The application is single- or multi-threaded but does not require message passing.
- The application has a small runtime between 1 and 24 hours.
- The application can handle being unexpectedly killed and restarted.
- The application is built from software that does not require contact to licensing servers.
- The scientific problem can be described as a workflow consisting of jobs of such kind.
- The scientific problem requires running a very large number of small jobs rather than a few large jobs.
(from [https://opensciencegrid.org/about/introduction/](https://opensciencegrid.org/about/introduction/))

"""

# ╔═╡ f6a0d516-5557-4830-9729-ef2687ffe550
md"""
## Cloud Pros & Cons
- What are some advantages of cloud computing?
- What are some drawbacks of cloud computing?
- What Astronomy projects use cloud computing?
"""

# ╔═╡ 194cb60f-76e7-491c-8498-b9ba096fd790
md"""
# Q&A
"""

# ╔═╡ 6deb218c-aaf3-4526-877e-259cde09a387
blockquote(md"How can you set up a global variable in the main file (Jupyter) for use in a function from a module?")

# ╔═╡ 88e4e35f-4d6e-448f-8c3e-d841ac6b3d9f
module MyModule
	global A
    function getA()  
        global A
		return A
    end
    function setA!(m)  
        global A = m
		return A
    end
end

# ╔═╡ 92cbd27c-1751-454e-9ae8-aaee77cfe6ab
MyModule.setA!([1 2; 3 4])

# ╔═╡ 77985a5e-88e1-4e83-bae0-7dd95023b3b4
MyModule.getA()

# ╔═╡ 8b638aa8-3f29-4b57-9179-ea030bb4308e
md"""
#### What's bad about that?
"""

# ╔═╡ 92caec94-f70c-473d-a602-6d646dd9bd01
hint(md"""**Q:** What are the consequences of type instability?""")

# ╔═╡ 5ad290ca-37be-4bc9-9b9e-0ae348092bcb


# ╔═╡ ba7c3dcf-5fd6-4e9e-a2ab-ec798080402b


# ╔═╡ 8b71c74e-838f-4e02-bf9f-fb74d1dfc5f1


# ╔═╡ c255e517-6f87-4068-a752-a9695634b0ea


# ╔═╡ 5c2680fa-56d7-47da-8540-093e9653bf7f
@code_warntype MyModule.getA()

# ╔═╡ cc16a21e-8771-4176-937b-389780f56bbd
MyModule.setA!(17)

# ╔═╡ 679fb815-d330-48dd-9464-9c29a79663e1
md"""
### Using type annotations
"""

# ╔═╡ 9c164d07-d558-4d2e-88c5-c99f5c83f386
module MyModule2
	global A
	function __init__()
		global A = zeros(Float64,2,2)
	end
	function getA()::Matrix{Float64}  
        global A
		return A
    end
    function setA!(m::Matrix{Float64})  
        global A = m
		return A
    end
end

# ╔═╡ 9f5ecae7-1cb8-402e-9dad-a99c98319794
MyModule2.getA()

# ╔═╡ ea7f7ea9-af24-4f2e-8ad9-a636f55c1a0a
MyModule2.setA!([1.0 2; 3 4])

# ╔═╡ 21f6edd1-6447-450c-9a45-481cb0745289
MyModule2.getA()

# ╔═╡ 1d1d1488-1a3d-4eeb-ad30-88587c484a53
md"""
### Using a global const reference to hold data (that can change) 
"""

# ╔═╡ 1bfe499a-3948-4438-9f8a-447622904b73
@code_warntype MyModule2.getA()

# ╔═╡ 933ce89e-1f9e-4ce8-8917-aca567625c90
module MyModule3
	global const A = Ref(Matrix{Float64}(undef,0,0))
	function __init__()
		A[] = zeros(Float64,2,2)
	end
	function getA()  
        return A[]
    end
    function setA!(m::Matrix{Float64})  
		A[] = m
		return A[]
    end
end

# ╔═╡ bfc5aa39-5393-4635-8bdb-10ec7ddf009f
MyModule3.getA()

# ╔═╡ a4d24ac7-189d-4975-ac94-9005cb4930ec
MyModule3.setA!([5 6; 7 8.0])

# ╔═╡ aeefd8da-318e-464b-ac7d-fa9965a850ec
MyModule3.getA()

# ╔═╡ 2852eeca-a796-4574-99ff-f7c922c84862
blockquote(md"""Can you go over creating your own packages briefly again, and what specifically should go in "MyProject.jl", for the case of our project (an example would be nice there).""")

# ╔═╡ 0ff04c27-e672-4659-9855-2b50032e3521
md"""
Barebones:
```julia
import Pkg
Pkg.generate("MyNewPackage")
```
Feature rich:
- [PkgTemplates](https://github.com/invenia/PkgTemplates.jl)
```julia 
using PkgTemplates
Template(interactive=true)("MyFancyNewPackage")
```
"""

# ╔═╡ 9aa3d6b8-5502-4ef6-97d9-f5cbec0c50ca
md"""
In `src/MyNewPackage.jl` include:
- `import` or `using` the packages that your new package will directly depend on. 
- Functions
- Types
- Variables (or constants) with module scope
- Often do that via `include` statements to keep code well organized.
- What to export?
  - Yes:  API to your package (i.e., functions & structs meant to be used by users)
  - No: Internal functions & structs (i.e., functions meant to be called by other functions in your package )
"""

# ╔═╡ c697bb88-65cb-4842-84cd-c66d41c59341
md"""
Example: 
```julia
module lab6

using Distributions
using QuadGK

include("model_spectrum.jl")

end # module
```
"""

# ╔═╡ a9e63186-731b-4264-a6c2-34578c4d5a99
md"""
What's in `model_spectrum.jl`?
```julia
# Constants
const limit_kernel_width_default = 10.0
const speed_of_light = 299792458.0 # m/s

# spectrum.jl:  utils for computing simple spectrum models
include("spectrum.jl")
export AbstractSpectrum, SimpleSpectrum, SimulatedSpectrum, ConvolvedSpectrum
export doppler_shifted_spectrum

# convolution_kernels.jl:  utils for convolution kernels
include("convolution_kernels.jl")
export AbstractConvolutionKernel, GaussianConvolutionKernel, GaussianMixtureConvolutionKernel
```
"""

# ╔═╡ 8cbeb34d-53a0-4677-982a-349641269559
md"# Old Questions"

# ╔═╡ b59287dc-5271-492b-82ad-23e726442a54
md"""
### Tests
**Q:**
Can you explain again what integration and regression tests are and the difference between them?

**A:** 

- **Unit tests**:  Tests one specific piece of code, usually small and well-defined behavior.  Aim for each function that actually does a calculation to have _at least_ one unit test.  

- **Integration tests**:  Tests how two (or more) pieces of code (e.g., functions, packages) interact.  E.g., Calling one function with outputs of another function, reading outputs of code as inputs to another code.  Aim to test each handoff of data from one stage of your analysis to the next.
   Common errors that can be easily detected with integration tests:  
    - Variable/structure types
    - Names of variables, columns, arguements
    - Units
    - Which array index is for what dimension
    - Order of variables (if using order rather than names)
    - Changes to parameters required/accepted by function

- **End-to-end tests**:  Tests code from beginning to final result.  Might test for limiting cases where behavior can be predicted analytically.  Might test for more typical values by comparing to another result.  Very often implemented as a regression test.  

- **Regression tests**:  Tests whether the outputs match expectations.  Can apply to unit-tests, integration tests, or end-to-end tests.  Often checking that results don't change (significantly) compared to a previous version of the code.  
"""

# ╔═╡ b2a15aa0-b2cb-4a4d-a612-4cbd3ee6a5f3
md"""
### What goes into Julia.Base?
**Q:** Some packages are extremely useful and I'm surprised I have to add them. What does it take for packages to get integrated into the default Julia environment?

**A:** 
Julia developers discuss and decide what to include.  Policy is that new features that would directly affect users (e.g., incorporating a package into Base) should only happen in major (e.g., v1.0, v2.0,...) or minor releases (e.g., 1.6.0, 1.7.0).  Recently, developers have aimed for minor release roughly twice a year.  

Julia is open-source, so anyone can create their own fork of Julia that includes more packages by default.  Why haven't they?  
- It's easy to add packages, so not worth the effort.
- People value having development effort concentrated in one version.
- People are sufficiently satisfied (or at least not very dissatisfied) with how it's been handled.

What do maintainers look for (not official, just my guesses):
- Generally applicable as opposed to highly specialized.
- Mature implementation that works well and isn't changing.
- Mature API that is unlikely to need changes soon.
- Integrates well with existing types and functions in Julia Base.
- Quality tests and good coverage.
- Sufficient documentation.
- Practical plan for maintaing code.


Example: Building a fast CSV reader.  ([CSV.jl](https://github.com/JuliaData/CSV.jl) & [benchmarks](thttps://juliacomputing.com/blog/2020/06/fast-csv/))

"""

# ╔═╡ e6e7e24e-ff66-47ac-bbfb-63d9059dcf7a
md"""
### Multi-threading vs Multi-processing
**Q:** What is the difference between multithreaded programming and multiprocessing?

**A:**
1. Shared/Separate memory spaces: 
   - Threads share access to a common memory space
   - Processes are each allocated their own memory space
2.  Potential for conflicts
   - Threads use locks to prevent avoid memory conflicts
   - Each process can write to its own memory without checking if anyone else is using it. 
3.  Ability to scale up
   - Multithreading only works on shared-memory systems
   - Multiprocessing can work on either shared or distributed-memory systems
"""


# ╔═╡ e2d34d5c-1298-483e-b7fe-fe2d21a385fc
md"""
### Others Q&As:
**Q:** Can you go over again how to implement packages such that anyone who is sent a code can also run it effectively?

**A:** See Lab 9, Ex 1 for step by step for creating a Julia package.  If that's not what you're asking, then please follow-up.
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

# ╔═╡ 8759b216-cc38-42ed-b85c-04d508579c54
md"# Helper Code"

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
PlutoTeachingTools = "661c6b06-c737-4d37-b85c-46df65de6f69"
PlutoTest = "cb4044da-4d16-4ffa-a6a3-8cad7f73ebdc"
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"

[compat]
PlutoUI = "~0.7.16"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.9.2"
manifest_format = "2.0"
project_hash = "0a2f1a7d2aefb3a56df0c18ccf7ebee67ade6594"

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
git-tree-sha1 = "62fbfbbed77a20e9390c4f02219cb3b11d21708d"
uuid = "295af30f-e4ad-537b-8983-00126c2a3abe"
version = "3.5.8"

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
# ╟─6f4b5d3e-2f2b-44cb-809e-6a7f309880ee
# ╟─89405d73-0d8f-465d-b1ea-43d74d25bbf8
# ╟─0c7a11e0-c484-48bf-86f0-1de678c3ffbc
# ╟─5061ee9d-d5ee-4c5c-9267-88c22f8973e4
# ╟─d58e5f2d-d001-4ffb-b89d-27949e0b7633
# ╟─6d3ee824-b4e1-466b-b611-7a6c4bfe196a
# ╟─bbe742aa-8f41-4833-8b5b-5c79cf09b1ee
# ╟─f6a0d516-5557-4830-9729-ef2687ffe550
# ╟─194cb60f-76e7-491c-8498-b9ba096fd790
# ╟─6deb218c-aaf3-4526-877e-259cde09a387
# ╠═88e4e35f-4d6e-448f-8c3e-d841ac6b3d9f
# ╠═92cbd27c-1751-454e-9ae8-aaee77cfe6ab
# ╠═77985a5e-88e1-4e83-bae0-7dd95023b3b4
# ╟─8b638aa8-3f29-4b57-9179-ea030bb4308e
# ╟─92caec94-f70c-473d-a602-6d646dd9bd01
# ╠═5ad290ca-37be-4bc9-9b9e-0ae348092bcb
# ╠═ba7c3dcf-5fd6-4e9e-a2ab-ec798080402b
# ╠═8b71c74e-838f-4e02-bf9f-fb74d1dfc5f1
# ╠═c255e517-6f87-4068-a752-a9695634b0ea
# ╠═5c2680fa-56d7-47da-8540-093e9653bf7f
# ╠═cc16a21e-8771-4176-937b-389780f56bbd
# ╟─679fb815-d330-48dd-9464-9c29a79663e1
# ╠═9c164d07-d558-4d2e-88c5-c99f5c83f386
# ╠═9f5ecae7-1cb8-402e-9dad-a99c98319794
# ╠═ea7f7ea9-af24-4f2e-8ad9-a636f55c1a0a
# ╠═21f6edd1-6447-450c-9a45-481cb0745289
# ╟─1d1d1488-1a3d-4eeb-ad30-88587c484a53
# ╠═1bfe499a-3948-4438-9f8a-447622904b73
# ╠═933ce89e-1f9e-4ce8-8917-aca567625c90
# ╠═bfc5aa39-5393-4635-8bdb-10ec7ddf009f
# ╠═a4d24ac7-189d-4975-ac94-9005cb4930ec
# ╠═aeefd8da-318e-464b-ac7d-fa9965a850ec
# ╟─2852eeca-a796-4574-99ff-f7c922c84862
# ╟─0ff04c27-e672-4659-9855-2b50032e3521
# ╟─9aa3d6b8-5502-4ef6-97d9-f5cbec0c50ca
# ╟─c697bb88-65cb-4842-84cd-c66d41c59341
# ╟─a9e63186-731b-4264-a6c2-34578c4d5a99
# ╟─8cbeb34d-53a0-4677-982a-349641269559
# ╟─b59287dc-5271-492b-82ad-23e726442a54
# ╟─b2a15aa0-b2cb-4a4d-a612-4cbd3ee6a5f3
# ╟─e6e7e24e-ff66-47ac-bbfb-63d9059dcf7a
# ╟─e2d34d5c-1298-483e-b7fe-fe2d21a385fc
# ╟─24cb813e-af85-435f-9c43-db38e8eaa1d2
# ╟─8759b216-cc38-42ed-b85c-04d508579c54
# ╟─1c640715-9bef-4935-9dce-f94ff2a3740b
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
