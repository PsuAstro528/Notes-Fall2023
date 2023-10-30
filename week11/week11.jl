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

# ╔═╡ a02e1141-6567-4675-bd65-34d0b5133f08
using Random123 # Package with a counter-based RNG

# ╔═╡ 715d4760-6020-41c5-b16a-740a160655c7
using KernelAbstractions, KernelGradients, Adapt, Enzyme

# ╔═╡ 1c640715-9bef-4935-9dce-f94ff2a3740b
begin
	using PlutoUI, PlutoTest, PlutoTeachingTools
	using CUDA, FLoops, Folds
end

# ╔═╡ 0b431bf7-1f57-40c4-ad0c-012cbdbf9528
md"> Astro 528: High-Performance Scientific Computing for Astrophysics (Fall 2021)"

# ╔═╡ a21b553b-eecb-4105-a0ed-d936e500788b
ChooseDisplayMode()

# ╔═╡ afe9b7c1-d031-4e1f-bd5b-5aeed30d7048
md"ToC on side $(@bind toc_aside CheckBox(;default=true))"

# ╔═╡ 080d3a94-161e-4482-9cf4-b82ffb98d0ed
TableOfContents(aside=toc_aside)

# ╔═╡ 959f2c12-287c-4648-a585-0c11d0db812d
md"""
# Week 11 Discussion Topics
- Priorities for Scientific Computing
- Build & Workflow Management systems
- Parallel Random Number Generation
- Autodifferentiation on GPU
- Q&A
"""

# ╔═╡ 1ce7ef5b-c213-47ba-ac96-9622b62cda61
md"""
# Project Updates
- Parallel version of code (multi-core) (due Oct 30)
- Second parallel version of code (distributed-memory/GPU/cloud) (due Nov 13)
- Completed code, documentation, tests, packaging (optional) & reflection (due Nov 29)
- Class presentations (Nov 27 - Dec 6, [schedule](https://github.com/PsuAstro528/PresentationsSchedule2023/blob/main/README.md) )
"""

# ╔═╡ 316b2027-b3a6-45d6-9b65-e26b4ab42e5e
md"""
# Priorities for Scientific Computing
"""

# ╔═╡ d8ce73d3-d4eb-4d2e-b5e6-88afe0920a47
hint(md"""
According to textbook:
- Correctness
- Numerical stability
- Accuracy (e.g., Discritization, Monte Carlo)
- Flexibility
- Efficiency
   + Time
   + Memory
   + Code development
""")

# ╔═╡ 94d6612c-364c-4892-ac4b-b0ca21f49589
blockquote(md"""What is a good example of "use a build tool to automate workflows"?""")

# ╔═╡ cd04a158-150e-4679-8602-68ab9666f21e
md"""
## Build System
"""

# ╔═╡ 741de66c-968e-4dc6-ad7a-67ac5f995775
md"""### Example Makefiles
#### Simple Makefile
```make
all: myprog.c 
	gcc -g -Wall -o myprog myprog.c

clean: 
	rm -f myprog
```

#### Makefile w/ variable & rule
```make
CPPFLAGS := -Wall -O3 -fopenmp

%.o : %.c
        $(CC) -c $(CFLAGS) $(CPPFLAGS) $< -o $@
```

Run makefile from command line with 
```shell
make
```

For a nice tutorial, see [makefiletutorial.com](https://makefiletutorial.com/#pattern-rules).
"""

# ╔═╡ 2a020c98-01a2-4ca0-8db9-8636394ab05c
md"""
## Snakemake
"""

# ╔═╡ 4d1468bb-90db-45cb-b21e-7045ccb50d06
md"""
### Example Snakemake file
```snakemake
MEANS = ["0", "1", "2" ]
SIGMAS = ["1", "2" ]

rule all:
   input:
      expand("summary_mu={mean}_sigma={sigma}.toml", mean=MEANS, sigma=SIGMAS)

rule instantiate:
   output: 
      "0_instantiated"
   shell:
      "julia --project -e 'import Pkg; Pkg.instantiate()'; touch {output}"

rule gen_rand_vars:
   input:
      check = "0_instantiated"
   params:
      num_draws = "10"
   output:
      "draws_mu={mean}_sigma={sigma}.csv"
   shell:
      "julia --project draw_vars.jl --mean={wildcards.mean} --sigma={wildcards.sigma} --n={params.num_draws} {output}"

rule calc_summary:
   input:
      check = "0_instantiated",
      fn = "draws_mu={mean}_sigma={sigma}.csv"
   output:
      "summary_mu={mean}_sigma={sigma}.toml"
   shell:
      "julia --project calc_summary.jl {input.fn} > {output} "

```

"""

# ╔═╡ eee2e610-a771-4c97-acc3-4bc209368a56
md"""
### Running workflow on one node, one core
```shell
conda activate snakemake 
cd DIR_WITH_SNAKEFILE
snakemake -c 1
```
"""

# ╔═╡ f9a7be5b-4019-4137-ab07-fed0faec48b3
md"""
### Running workflow on one node, multiple cores 
Each step runs as separate process on same node.
```shell
snakemake -c 4
```
"""

# ╔═╡ af0b34cb-1a6a-437c-9888-c358c1bed4f0
md"""
### Running Snakemake workflow as many jobs via slurm
```shell
snakemake --profile PROFILE_DIR  --latency-wait 20
```
"""

# ╔═╡ d3d08b5a-d8ce-4832-a7bd-0ec3f9db517f
md"""
#### Slurm Profile
In a file named config.yaml in a separate directory for this profile.
```yaml
default-resources: 
   mem_mb_per_cpu: 4096   # in MB
   nodes: 1               # nodes per job  
   tasks: 1               # tasks per job
   cpus_per_task: 1       # cores per job
   runtime: 15            # in minutes
cluster: "sbatch --job-name={rule} -A ebf11-fa23 --partition sla-prio --time={resources.runtime} --nodes={resources.nodes} --ntasks={resources.tasks} --cpus-per-task={resources.cpus_per_task} --mem-per-cpu={resources.mem_mb_per_cpu} --export=ALL"
jobs: 10
verbose: true
notemp: true
```
"""

# ╔═╡ b9740055-70da-4330-a533-6ff779463808
md"""
### 2nd Example Snakemake file
```snakemake
DATETIMES, = glob_wildcards("neidL2_{datetime}.fits")

rule all:
   input:
      "0_instantiated",
      "0_download_complete",
      expand("neidL2_{datetime}.toml", datetime=DATETIMES),
      "output.csv"

rule instantiate:
   output: 
      "0_instantiated"
   shell:
      "julia --project -e 'import Pkg; Pkg.instantiate()'; touch {output}"

rule download:
   output: 
      "0_download_complete" 
   shell:
      "source neid_download_files_2023_10_14.sh; touch {output}"

rule make_toml:
   input:
      fits = "neidL2_{datetime}.fits",
      check1 = "0_instantiated",
      check2 = "0_download_complete" 
   output:
      "neidL2_{datetime}.toml"
   shell:
      "julia --project preprocess.jl {input.fits} {output} "

rule post_process:
   input:
      check1 = "0_instantiated",
      check2 = "0_download_complete", 
      input_fn = expand("neidL2_{datetime}.toml", datetime=DATETIMES)
   output:
      "output.csv"
   shell:
      "julia --project postprocess.jl . {output}"

```
"""

# ╔═╡ d5fa33ed-fa54-44a6-aeb5-2e3c825149dd
blockquote(md"""
Is there a reason why we would ever want to not use a command line interphase to work on projects?
""")

# ╔═╡ 3bb2feb8-6e54-44f4-bb81-7afea27f64d5
md"""
# Parallel Random Number Generators
(Example from [FoldsCUDA.jl example](https://github.com/JuliaFolds/FoldsCUDA.jl/blob/master/examples/monte_carlo_pi.jl))
"""

# ╔═╡ 914e41bb-7cfc-44f7-9764-a3351c586bc7
md"""
In this example, we use [`Random123.Philox2x`](https://sunoru.github.io/RandomNumbers.jl/stable/lib/random123/#Random123.Philox2x).
This RNG gives us two `UInt64`s for each counter which wraps around at `typemax(UInt64)`.
"""

# ╔═╡ 282922d5-7283-43df-bca5-3ba1f9d333f6
begin
	rng_a = Philox2x(0)
	rng_b = Philox2x(0)
	@test rng_a == rng_b
end

# ╔═╡ ec2066da-6431-422f-b9c3-57ee12d4411c
rng_jump = 10

# ╔═╡ dbefd6a4-0529-4eb4-8f0d-c6a8dee4f9d8
begin
	set_counter!(rng_a, 0)
	set_counter!(rng_b, rng_jump)
	for i in 1:rng_jump 
		rand(rng_a, 2)
	end
	@test rng_a == rng_b
end

# ╔═╡ 563f2567-ca72-4133-b3a8-0aeb217a4ca3
# Create a helper function that divides `UInt64(0):typemax(UInt64)` into `n` equal intervals
function counters(n)
    stride = typemax(UInt64) ÷ n
    return UInt64(0):stride:(typemax(UInt64)-stride)
end

# ╔═╡ ecebd8cf-06ac-43c0-8c14-a9cd891d05b6
function monte_carlo_pi(n; m = 10_000, ex = has_cuda_gpu() ? CUDAEx() : ThreadedEx())
    @floop ex for ctr in counters(n)
		# Use "independent" RNG for each `ctr`-th iteration:
        rng = set_counter!(Philox2x(0), ctr)
        nhits = 0
        for _ in 1:m
            x = rand(rng)
            y = rand(rng)
            nhits += x^2 + y^2 < 1
        end
        @reduce(tot = 0 + nhits)
    end
    return 4 * tot / (n * m)
end


# ╔═╡ 3c4e85fd-2741-4a81-be38-0d8d7a28c129
monte_carlo_pi(10_000)

# ╔═╡ 98ff3fc5-8a4a-4185-a656-82769d90b1fe
with_terminal() do
	@time monte_carlo_pi(4, m=100_000, ex=ThreadedEx()) 
	@time monte_carlo_pi(4, m=100_000, ex=ThreadedEx()) 
	@time monte_carlo_pi(4, m=100_000, ex=SequentialEx()) 
	@time monte_carlo_pi(4, m=100_000, ex=SequentialEx()) 
	if has_cuda_gpu()
		@time monte_carlo_pi(56*64, m=100_000 ÷ (56*16) ) 
		@time monte_carlo_pi(56*64, m=100_000 ÷ (56*16) ) 
	end
end

# ╔═╡ f98a63cc-253c-48ad-bfb5-52c70983049a
blockquote(md"""
What is something you personally believed needs to be created/invested in by the astro community to better facilitate positive scientific software practices? Do you view it more as a funding or astro-cultural issue?
""")

# ╔═╡ 8b297ffb-bc91-4603-b144-5838a7c0b314
md"""
#### Deprioritizing being "first", so that people can focus on:
- Testing one's own work more thoroughly (both science and code) before publishing
- Designing software thoughtfully (rather than sprinting)
- Maintaining/improving existing software for benefit of others.
"""

# ╔═╡ 54d44ca6-9b20-476e-9d79-b808e42ab5d9
md"""# GPUs with Autodifferentiation
(Example based on JuliaCon 2021's [GPU Workshop's enzyme notebook](https://github.com/maleadt/juliacon21-gpu_workshop/blob/main/enzyme/enzyme.ipynb))
"""

# ╔═╡ a504a5d6-df69-4ef7-b19e-09b165944f89
has_gpu = false

# ╔═╡ bc5156bd-e0e3-4032-8d37-e4e61274aabe
begin
	if has_gpu
		a = adapt(CuArray, rand(64, 128))
		b = adapt(CuArray, rand(128, 32))
		c = adapt(CuArray, zeros(64, 32))
	else
		a = rand(64, 128)
		b = rand(128, 32)
		c = zeros(64, 32)
	end
	nothing
end

# ╔═╡ 9c04effb-2b4b-401c-9858-d9491c20d895
begin
	@kernel function generic_matmul_kernel!(out, a, b)
    i, j = @index(Global, NTuple)

    # creating a temporary sum variable for matrix multiplication
    tmp_sum = zero(eltype(out))
    for k = 1:size(a)[2]
        tmp_sum += @inbounds a[i, k] * b[k, j]
    end

    @inbounds out[i,j] = tmp_sum
	end
	
	if has_gpu
		matmul_kernel! = generic_matmul_kernel!(CUDADevice(),32)
	else
		matmul_kernel! = generic_matmul_kernel!(CPU())
	end
	
end

# ╔═╡ 5234f042-755d-4550-a73c-5136c194f1ba
begin
	wait(matmul_kernel!(c, a, b, ndrange=size(c)))
	ran_matmul_kernel = true
end;

# ╔═╡ 77d86ec7-07e5-4464-9992-c4baa931c79d
begin
	ran_matmul_kernel 
	@test collect(c) ≈ collect(a*b)
end

# ╔═╡ 814a1ef0-f7fc-4180-a868-fb932951a1ad
begin
	dc = similar(c)
	fill!(c, 0)
	fill!(dc, 1)
	copy_dc = copy(dc)
	
	da = zero(a)
	db = zero(b)
	if has_gpu
		matmul_adjoint_kernel = autodiff(generic_matmul_kernel!(CUDADevice(),32))
	else
		matmul_adjoint_kernel = autodiff(generic_matmul_kernel!(CPU()))
	end
end

# ╔═╡ bc4b4f32-9a54-48f2-8da0-a01ab3d17992
if false
	wait(matmul_adjoint_kernel(Duplicated(c, dc), Duplicated(a, da), Duplicated(b, db), ndrange=size(c)))
	ran_matmul_adjoint_kernel = true
else
	ran_matmul_adjoint_kernel = false
end;

# ╔═╡ 62ace3b8-0e38-4150-80e6-2488d19f8d5d
if ran_matmul_adjoint_kernel
	ran_matmul_adjoint_kernel
	@test db ≈ a' * copy_dc
end

# ╔═╡ 25dd3208-1b76-4122-9de4-7c177f136b6d
if ran_matmul_adjoint_kernel
	ran_matmul_adjoint_kernel
	da ≈ copy_dc * b'
end

# ╔═╡ b6b281af-64a1-44b4-a9b6-ee0ba17f5c0b
md"""
# Your Questions
"""

# ╔═╡ 0b5dd506-d79a-4094-8c9e-e885f0273ab1


# ╔═╡ 24cb813e-af85-435f-9c43-db38e8eaa1d2
md"""# Project Rubrics

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

# ╔═╡ b8fb2e42-7d3a-4654-8bbd-6b342239882e
md"""
**Q:** What's the difference between a "workflow management tool" and a "build tool"?  How would we go about implementing/using each?

**A:** Build tools designed to compile code.  Examples:
- [`make` & Makefile](https://opensource.com/article/18/8/what-how-makefile)
- [`Cmake`](https://cmake.org/)
- [tons more](https://en.wikipedia.org/wiki/List_of_build_automation_software)

Workflow management tools designed to automate running of codes, finding inputs, tracking dependancies, finding resources, etc:
- [snakemake](https://snakemake.readthedocs.io/en/stable/)
- [bds (Big Data SCript)](https://pcingola.github.io/bds/)
- [NextFlow](https://www.nextflow.io/)
- [Ruffus](http://www.ruffus.org.uk/)
- [Pegasus](https://pegasus.isi.edu/)
- [Bpipe](http://docs.bpipe.org/)
- [Galaxy](https://galaxyproject.org/)
"""

# ╔═╡ d2ead952-d962-457a-8eba-ea4f47c58bfa
md"""
## Planning your time
**Q**: What is a good average amount of code that should be written at a time *before pausing for* unit tests, debugging, committing, or feedback? Is it more of a per line suggestion or per-function?

**A (commiting):**  Commit often.  If want to keep main branch clean, commit interim work to feature branch and [*squash* instead of *merge*](https://docs.github.com/en/github/collaborating-with-pull-requests/incorporating-changes-from-a-pull-request/about-pull-request-merges) into main branch once its ready.  IDEs make small commits easier.


**A (testing, debugging):** Some considerations:
- How long can you focus well?  (Be realistic.)
  - Are you sitting down fresh after a break?  
  - Are you cramming it in between two meetings?
  - How frequently do you need to take breaks?
- How much quality code do you write in that time?
  - How complex is the function(s) you're writing is?
  - Are you scripting doing the same thing over and over?
  - Are you implementing a complex algorithm?
- Where are natural stopping points?
  - Do you want to interupt yourself before you pass your tests?
  - Do you want to take a fresh look at your code before
- Other factors?

**A (feedback):**  It depends on what kind of feedback you are looking for.

- Early:
  - Is there a reason to consider different data structures?
  - Does the overall organizaztion make sense?
  - Are there other packages/libraries that I should consider using?
- Mid:
  - Why is my code failing this test?
  - Is there an alternative algorithm that would be a better fit for my problem?
- Late:
  - How could I improve the performance of this function?
  - I'm thinking of parallelizing my code this way.  Do you see any other alternatives I could consider?
- Try to avoid:
  - My code isn't finished yet, and I don't have any unit tests for the functions that I have written.  Please review my code anyway.

**Other examples?**
"""



# ╔═╡ a93bb394-4566-4dc2-a3b0-e535013c5453
md"""
**Q:** Can you re-explain what the [Julia registry](https://github.com/JuliaRegistries/General) is?

Why do we include code to **prevent it from being updaed by** new threads/cores in Labs 6 and 7?

```julia
@everywhere import Pkg
@everywhere Pkg.offline(true)
```

**A:** Package manager queries the general registry to see if updates are avaliable.  Often some package we don't care about has been updated, triggering it to download and process the updated registry.  We don't want multiple processors doing that simultaneously.
"""

# ╔═╡ e040dee5-387d-4755-81fa-a4c46a2323b2
md"""
**Q:** The reading talks about repetition of previous commands being one reason why command-line interfaces are still popular. Isn't a command-line interface just the terminal? What would be the alternative to using a terminal?

**A:** Yes, the terminal is an example of a command-line interface.  Alternatives would be things like using a mouse to click menus/buttons, giving voice commands, etc.  """

# ╔═╡ 0c91f6b7-36d1-4d9a-8508-53d0e3bd05c2
md"""
**Q:** How can collaboration on the same project working on the same lines be better handled?

**A:** Real-time collaboration tools, e.g.:
- [VS Code LiveShare](https://code.visualstudio.com/learn/collaboration/live-share)
"""

# ╔═╡ 8759b216-cc38-42ed-b85c-04d508579c54
md"# Helper Code"

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
Adapt = "79e6a3ab-5dfb-504d-930d-738a2a938a0e"
CUDA = "052768ef-5323-5732-b1bb-66c8b64840ba"
Enzyme = "7da242da-08ed-463a-9acd-ee780be4f1d9"
FLoops = "cc61a311-1640-44b5-9fba-1b764f453329"
Folds = "41a02a25-b8f0-4f67-bc48-60067656b558"
KernelAbstractions = "63c18a36-062a-441e-b654-da1e3ab1ce7c"
KernelGradients = "e5faadeb-7f6c-408e-9747-a7a26e81c66a"
PlutoTeachingTools = "661c6b06-c737-4d37-b85c-46df65de6f69"
PlutoTest = "cb4044da-4d16-4ffa-a6a3-8cad7f73ebdc"
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
Random123 = "74087812-796a-5b5d-8853-05524746bad3"

[compat]
Adapt = "~3.7.1"
CUDA = "~4.0.1"
Enzyme = "~0.10.18"
FLoops = "~0.2.1"
Folds = "~0.2.8"
KernelAbstractions = "~0.8.6"
KernelGradients = "~0.1.2"
PlutoTeachingTools = "~0.2.13"
PlutoTest = "~0.2.2"
PlutoUI = "~0.7.52"
Random123 = "~1.6.1"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.9.2"
manifest_format = "2.0"
project_hash = "a7465d06f7ed99fb6fdc93d0a2e8d59ff61ccc11"

[[deps.AbstractFFTs]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "d92ad398961a3ed262d8bf04a1a2b8340f915fef"
uuid = "621f4979-c628-5d54-868e-fcf4e3e8185c"
version = "1.5.0"

    [deps.AbstractFFTs.extensions]
    AbstractFFTsChainRulesCoreExt = "ChainRulesCore"
    AbstractFFTsTestExt = "Test"

    [deps.AbstractFFTs.weakdeps]
    ChainRulesCore = "d360d2e6-b24c-11e9-a2a3-2a2ae2dbcce4"
    Test = "8dfed614-e22c-5e08-85e1-65c5234f0b40"

[[deps.AbstractPlutoDingetjes]]
deps = ["Pkg"]
git-tree-sha1 = "91bd53c39b9cbfb5ef4b015e8b582d344532bd0a"
uuid = "6e696c72-6542-2067-7265-42206c756150"
version = "1.2.0"

[[deps.Accessors]]
deps = ["CompositionsBase", "ConstructionBase", "Dates", "InverseFunctions", "LinearAlgebra", "MacroTools", "Test"]
git-tree-sha1 = "a7055b939deae2455aa8a67491e034f735dd08d3"
uuid = "7d9f7c33-5ae7-4f3b-8dc6-eff91059b697"
version = "0.1.33"

    [deps.Accessors.extensions]
    AccessorsAxisKeysExt = "AxisKeys"
    AccessorsIntervalSetsExt = "IntervalSets"
    AccessorsStaticArraysExt = "StaticArrays"
    AccessorsStructArraysExt = "StructArrays"

    [deps.Accessors.weakdeps]
    AxisKeys = "94b1ba4f-4ee9-5380-92f1-94cde586c3c5"
    IntervalSets = "8197267c-284f-5f27-9208-e0e47529a953"
    Requires = "ae029012-a4dd-5104-9daa-d747884805df"
    StaticArrays = "90137ffa-7385-5640-81b9-e52037218182"
    StructArrays = "09ab397b-f2b6-538f-b94a-2f83cf4a842a"

[[deps.Adapt]]
deps = ["LinearAlgebra", "Requires"]
git-tree-sha1 = "02f731463748db57cc2ebfbd9fbc9ce8280d3433"
uuid = "79e6a3ab-5dfb-504d-930d-738a2a938a0e"
version = "3.7.1"
weakdeps = ["StaticArrays"]

    [deps.Adapt.extensions]
    AdaptStaticArraysExt = "StaticArrays"

[[deps.ArgCheck]]
git-tree-sha1 = "a3a402a35a2f7e0b87828ccabbd5ebfbebe356b4"
uuid = "dce04be8-c92d-5529-be00-80e4d2c0e197"
version = "2.3.0"

[[deps.ArgTools]]
uuid = "0dad84c5-d112-42e6-8d28-ef12dabb789f"
version = "1.1.1"

[[deps.Artifacts]]
uuid = "56f22d72-fd6d-98f1-02f0-08ddc0907c33"

[[deps.Atomix]]
deps = ["UnsafeAtomics"]
git-tree-sha1 = "c06a868224ecba914baa6942988e2f2aade419be"
uuid = "a9b6321e-bd34-4604-b9c9-b65b8de01458"
version = "0.1.0"

[[deps.BFloat16s]]
deps = ["LinearAlgebra", "Printf", "Random", "Test"]
git-tree-sha1 = "dbf84058d0a8cbbadee18d25cf606934b22d7c66"
uuid = "ab4f0b2a-ad5b-11e8-123f-65d77653426b"
version = "0.4.2"

[[deps.BangBang]]
deps = ["Compat", "ConstructionBase", "InitialValues", "LinearAlgebra", "Requires", "Setfield", "Tables"]
git-tree-sha1 = "e28912ce94077686443433c2800104b061a827ed"
uuid = "198e06fe-97b7-11e9-32a5-e1d131e6ad66"
version = "0.3.39"

    [deps.BangBang.extensions]
    BangBangChainRulesCoreExt = "ChainRulesCore"
    BangBangDataFramesExt = "DataFrames"
    BangBangStaticArraysExt = "StaticArrays"
    BangBangStructArraysExt = "StructArrays"
    BangBangTypedTablesExt = "TypedTables"

    [deps.BangBang.weakdeps]
    ChainRulesCore = "d360d2e6-b24c-11e9-a2a3-2a2ae2dbcce4"
    DataFrames = "a93c6f00-e57d-5684-b7b6-d8193f3e46c0"
    StaticArrays = "90137ffa-7385-5640-81b9-e52037218182"
    StructArrays = "09ab397b-f2b6-538f-b94a-2f83cf4a842a"
    TypedTables = "9d95f2ec-7b3d-5a63-8d20-e2491e220bb9"

[[deps.Base64]]
uuid = "2a0f44e3-6c83-55bd-87e4-b1978d98bd5f"

[[deps.Baselet]]
git-tree-sha1 = "aebf55e6d7795e02ca500a689d326ac979aaf89e"
uuid = "9718e550-a3fa-408a-8086-8db961cd8217"
version = "0.1.1"

[[deps.CEnum]]
git-tree-sha1 = "eb4cb44a499229b3b8426dcfb5dd85333951ff90"
uuid = "fa961155-64e5-5f13-b03f-caf6b980ea82"
version = "0.4.2"

[[deps.CUDA]]
deps = ["AbstractFFTs", "Adapt", "BFloat16s", "CEnum", "CUDA_Driver_jll", "CUDA_Runtime_Discovery", "CUDA_Runtime_jll", "CompilerSupportLibraries_jll", "ExprTools", "GPUArrays", "GPUCompiler", "LLVM", "LazyArtifacts", "Libdl", "LinearAlgebra", "Logging", "Preferences", "Printf", "Random", "Random123", "RandomNumbers", "Reexport", "Requires", "SparseArrays", "SpecialFunctions"]
git-tree-sha1 = "edff14c60784c8f7191a62a23b15a421185bc8a8"
uuid = "052768ef-5323-5732-b1bb-66c8b64840ba"
version = "4.0.1"

[[deps.CUDA_Driver_jll]]
deps = ["Artifacts", "JLLWrappers", "LazyArtifacts", "Libdl", "Pkg"]
git-tree-sha1 = "75d7896d1ec079ef10d3aee8f3668c11354c03a1"
uuid = "4ee394cb-3365-5eb0-8335-949819d2adfc"
version = "0.2.0+0"

[[deps.CUDA_Runtime_Discovery]]
deps = ["Libdl"]
git-tree-sha1 = "d6b227a1cfa63ae89cb969157c6789e36b7c9624"
uuid = "1af6417a-86b4-443c-805f-a4643ffb695f"
version = "0.1.2"

[[deps.CUDA_Runtime_jll]]
deps = ["Artifacts", "CUDA_Driver_jll", "JLLWrappers", "LazyArtifacts", "Libdl", "TOML"]
git-tree-sha1 = "ed00f777d2454c45f5f49634ed0a589da07ee0b0"
uuid = "76a88914-d11a-5bdc-97e0-2f5a05c973a2"
version = "0.2.4+1"

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

[[deps.Compat]]
deps = ["UUIDs"]
git-tree-sha1 = "8a62af3e248a8c4bad6b32cbbe663ae02275e32c"
uuid = "34da2185-b29b-5c13-b0c7-acf172513d20"
version = "4.10.0"
weakdeps = ["Dates", "LinearAlgebra"]

    [deps.Compat.extensions]
    CompatLinearAlgebraExt = "LinearAlgebra"

[[deps.CompilerSupportLibraries_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "e66e0078-7015-5450-92f7-15fbd957f2ae"
version = "1.0.5+0"

[[deps.CompositionsBase]]
git-tree-sha1 = "802bb88cd69dfd1509f6670416bd4434015693ad"
uuid = "a33af91c-f02d-484b-be07-31d278c5ca2b"
version = "0.1.2"
weakdeps = ["InverseFunctions"]

    [deps.CompositionsBase.extensions]
    CompositionsBaseInverseFunctionsExt = "InverseFunctions"

[[deps.ConstructionBase]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "c53fc348ca4d40d7b371e71fd52251839080cbc9"
uuid = "187b0558-2788-49d3-abe0-74a17ed4e7c9"
version = "1.5.4"

    [deps.ConstructionBase.extensions]
    ConstructionBaseIntervalSetsExt = "IntervalSets"
    ConstructionBaseStaticArraysExt = "StaticArrays"

    [deps.ConstructionBase.weakdeps]
    IntervalSets = "8197267c-284f-5f27-9208-e0e47529a953"
    StaticArrays = "90137ffa-7385-5640-81b9-e52037218182"

[[deps.ContextVariablesX]]
deps = ["Compat", "Logging", "UUIDs"]
git-tree-sha1 = "25cc3803f1030ab855e383129dcd3dc294e322cc"
uuid = "6add18c4-b38d-439d-96f6-d6bc489c04c5"
version = "0.1.3"

[[deps.DataAPI]]
git-tree-sha1 = "8da84edb865b0b5b0100c0666a9bc9a0b71c553c"
uuid = "9a962f9c-6df0-11e9-0e5d-c546b8b5ee8a"
version = "1.15.0"

[[deps.DataValueInterfaces]]
git-tree-sha1 = "bfc1187b79289637fa0ef6d4436ebdfe6905cbd6"
uuid = "e2d170a0-9d28-54be-80f0-106bbe20a464"
version = "1.0.0"

[[deps.Dates]]
deps = ["Printf"]
uuid = "ade2ca70-3891-5945-98fb-dc099432e06a"

[[deps.DefineSingletons]]
git-tree-sha1 = "0fba8b706d0178b4dc7fd44a96a92382c9065c2c"
uuid = "244e2a9f-e319-4986-a169-4d1fe445cd52"
version = "0.1.2"

[[deps.Distributed]]
deps = ["Random", "Serialization", "Sockets"]
uuid = "8ba89e20-285c-5b6f-9357-94700520ee1b"

[[deps.DocStringExtensions]]
deps = ["LibGit2"]
git-tree-sha1 = "2fb1e02f2b635d0845df5d7c167fec4dd739b00d"
uuid = "ffbed154-4ef7-542d-bbb7-c09d3a79fcae"
version = "0.9.3"

[[deps.Downloads]]
deps = ["ArgTools", "FileWatching", "LibCURL", "NetworkOptions"]
uuid = "f43a241f-c20a-4ad4-852c-f6b1247861c6"
version = "1.6.0"

[[deps.Enzyme]]
deps = ["CEnum", "EnzymeCore", "Enzyme_jll", "GPUCompiler", "LLVM", "Libdl", "LinearAlgebra", "ObjectFile", "Printf", "Random"]
git-tree-sha1 = "6249c3e023101edeb71e5c476c8945bd078e29e2"
uuid = "7da242da-08ed-463a-9acd-ee780be4f1d9"
version = "0.10.18"

[[deps.EnzymeCore]]
deps = ["Adapt"]
git-tree-sha1 = "238032b8e2a02e06bc8e257ff9484a96db8fea1b"
uuid = "f151be2c-9106-41f4-ab19-57ee4f262869"
version = "0.1.0"

[[deps.Enzyme_jll]]
deps = ["Artifacts", "JLLWrappers", "LazyArtifacts", "Libdl", "Pkg", "TOML"]
git-tree-sha1 = "ab56cf1c49ca27bce4e4f7cc91889cedfe83bd03"
uuid = "7cc45869-7501-5eee-bdea-0790c847d4ef"
version = "0.0.48+1"

[[deps.ExprTools]]
git-tree-sha1 = "27415f162e6028e81c72b82ef756bf321213b6ec"
uuid = "e2ba6199-217a-4e67-a87a-7c52f15ade04"
version = "0.1.10"

[[deps.ExternalDocstrings]]
git-tree-sha1 = "1224740fc4d07c989949e1c1b508ebd49a65a5f6"
uuid = "e189563c-0753-4f5e-ad5c-be4293c83fb4"
version = "0.1.1"

[[deps.FLoops]]
deps = ["BangBang", "Compat", "FLoopsBase", "InitialValues", "JuliaVariables", "MLStyle", "Serialization", "Setfield", "Transducers"]
git-tree-sha1 = "ffb97765602e3cbe59a0589d237bf07f245a8576"
uuid = "cc61a311-1640-44b5-9fba-1b764f453329"
version = "0.2.1"

[[deps.FLoopsBase]]
deps = ["ContextVariablesX"]
git-tree-sha1 = "656f7a6859be8673bf1f35da5670246b923964f7"
uuid = "b9860ae5-e623-471e-878b-f6a53c775ea6"
version = "0.1.1"

[[deps.FileWatching]]
uuid = "7b1f6079-737a-58dc-b8bc-7a2ca5c1b5ee"

[[deps.FixedPointNumbers]]
deps = ["Statistics"]
git-tree-sha1 = "335bfdceacc84c5cdf16aadc768aa5ddfc5383cc"
uuid = "53c48c17-4a7d-5ca2-90c5-79b7896eea93"
version = "0.8.4"

[[deps.Folds]]
deps = ["Accessors", "BangBang", "Baselet", "DefineSingletons", "Distributed", "ExternalDocstrings", "InitialValues", "MicroCollections", "Referenceables", "Requires", "Test", "ThreadedScans", "Transducers"]
git-tree-sha1 = "638109532de382a1f99b1aae1ca8b5d08515d85a"
uuid = "41a02a25-b8f0-4f67-bc48-60067656b558"
version = "0.2.8"

[[deps.Formatting]]
deps = ["Printf"]
git-tree-sha1 = "8339d61043228fdd3eb658d86c926cb282ae72a8"
uuid = "59287772-0a20-5a39-b81b-1366585eb4c0"
version = "0.4.2"

[[deps.Future]]
deps = ["Random"]
uuid = "9fa8497b-333b-5362-9e8d-4d0656e87820"

[[deps.GPUArrays]]
deps = ["Adapt", "GPUArraysCore", "LLVM", "LinearAlgebra", "Printf", "Random", "Reexport", "Serialization", "Statistics"]
git-tree-sha1 = "2e57b4a4f9cc15e85a24d603256fe08e527f48d1"
uuid = "0c68f7d7-f131-5f86-a1c3-88cf8149b2d7"
version = "8.8.1"

[[deps.GPUArraysCore]]
deps = ["Adapt"]
git-tree-sha1 = "2d6ca471a6c7b536127afccfa7564b5b39227fe0"
uuid = "46192b85-c4d5-4398-a991-12ede77f4527"
version = "0.1.5"

[[deps.GPUCompiler]]
deps = ["ExprTools", "InteractiveUtils", "LLVM", "Libdl", "Logging", "TimerOutputs", "UUIDs"]
git-tree-sha1 = "19d693666a304e8c371798f4900f7435558c7cde"
uuid = "61eb1bfa-7361-4325-ad38-22787b887f55"
version = "0.17.3"

[[deps.Hyperscript]]
deps = ["Test"]
git-tree-sha1 = "8d511d5b81240fc8e6802386302675bdf47737b9"
uuid = "47d2ed2b-36de-50cf-bf87-49c2cf4b8b91"
version = "0.0.4"

[[deps.HypertextLiteral]]
deps = ["Tricks"]
git-tree-sha1 = "c47c5fa4c5308f27ccaac35504858d8914e102f9"
uuid = "ac1192a8-f4b3-4bfe-ba22-af5b92cd3ab2"
version = "0.9.4"

[[deps.IOCapture]]
deps = ["Logging", "Random"]
git-tree-sha1 = "d75853a0bdbfb1ac815478bacd89cd27b550ace6"
uuid = "b5f81e59-6552-4d32-b1f0-c071b021bf89"
version = "0.2.3"

[[deps.InitialValues]]
git-tree-sha1 = "4da0f88e9a39111c2fa3add390ab15f3a44f3ca3"
uuid = "22cec73e-a1b8-11e9-2c92-598750a2cf9c"
version = "0.3.1"

[[deps.InteractiveUtils]]
deps = ["Markdown"]
uuid = "b77e0a4c-d291-57a0-90e8-8db25a27a240"

[[deps.InverseFunctions]]
deps = ["Test"]
git-tree-sha1 = "68772f49f54b479fa88ace904f6127f0a3bb2e46"
uuid = "3587e190-3f89-42d0-90ee-14403ec27112"
version = "0.1.12"

[[deps.IrrationalConstants]]
git-tree-sha1 = "630b497eafcc20001bba38a4651b327dcfc491d2"
uuid = "92d709cd-6900-40b7-9082-c6be49f344b6"
version = "0.2.2"

[[deps.IteratorInterfaceExtensions]]
git-tree-sha1 = "a3f24677c21f5bbe9d2a714f95dcd58337fb2856"
uuid = "82899510-4779-5014-852e-03e436cf321d"
version = "1.0.0"

[[deps.JLLWrappers]]
deps = ["Artifacts", "Preferences"]
git-tree-sha1 = "7e5d6779a1e09a36db2a7b6cff50942a0a7d0fca"
uuid = "692b3bcd-3c85-4b1f-b108-f13ce0eb3210"
version = "1.5.0"

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

[[deps.JuliaVariables]]
deps = ["MLStyle", "NameResolution"]
git-tree-sha1 = "49fb3cb53362ddadb4415e9b73926d6b40709e70"
uuid = "b14d175d-62b4-44ba-8fb7-3064adc8c3ec"
version = "0.2.4"

[[deps.KernelAbstractions]]
deps = ["Adapt", "Atomix", "InteractiveUtils", "LinearAlgebra", "MacroTools", "SparseArrays", "StaticArrays", "UUIDs", "UnsafeAtomics", "UnsafeAtomicsLLVM"]
git-tree-sha1 = "cf9cae1c4c1ff83f6c02cfaf01698f05448e8325"
uuid = "63c18a36-062a-441e-b654-da1e3ab1ce7c"
version = "0.8.6"

[[deps.KernelGradients]]
deps = ["Enzyme", "KernelAbstractions"]
git-tree-sha1 = "6dbcc9f869625fa50e1c7483f1c4200c65f17f9c"
uuid = "e5faadeb-7f6c-408e-9747-a7a26e81c66a"
version = "0.1.2"

[[deps.LLVM]]
deps = ["CEnum", "LLVMExtra_jll", "Libdl", "Printf", "Unicode"]
git-tree-sha1 = "f044a2796a9e18e0531b9b3072b0019a61f264bc"
uuid = "929cbde3-209d-540e-8aea-75f648917ca0"
version = "4.17.1"

[[deps.LLVMExtra_jll]]
deps = ["Artifacts", "JLLWrappers", "LazyArtifacts", "Libdl", "TOML"]
git-tree-sha1 = "070e4b5b65827f82c16ae0916376cb47377aa1b5"
uuid = "dad2f222-ce93-54a1-a47d-0025e8a3acab"
version = "0.0.18+0"

[[deps.LaTeXStrings]]
git-tree-sha1 = "f2355693d6778a178ade15952b7ac47a4ff97996"
uuid = "b964fa9f-0449-5b57-a5c2-d3ea65f4040f"
version = "1.3.0"

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

[[deps.LazyArtifacts]]
deps = ["Artifacts", "Pkg"]
uuid = "4af54fe1-eca0-43a8-85a7-787d91b784e3"

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

[[deps.LogExpFunctions]]
deps = ["DocStringExtensions", "IrrationalConstants", "LinearAlgebra"]
git-tree-sha1 = "7d6dd4e9212aebaeed356de34ccf262a3cd415aa"
uuid = "2ab3a3ac-af41-5b50-aa03-7779005ae688"
version = "0.3.26"

    [deps.LogExpFunctions.extensions]
    LogExpFunctionsChainRulesCoreExt = "ChainRulesCore"
    LogExpFunctionsChangesOfVariablesExt = "ChangesOfVariables"
    LogExpFunctionsInverseFunctionsExt = "InverseFunctions"

    [deps.LogExpFunctions.weakdeps]
    ChainRulesCore = "d360d2e6-b24c-11e9-a2a3-2a2ae2dbcce4"
    ChangesOfVariables = "9e997f8a-9a97-42d5-a9f1-ce6bfc15e2c0"
    InverseFunctions = "3587e190-3f89-42d0-90ee-14403ec27112"

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

[[deps.MLStyle]]
git-tree-sha1 = "bc38dff0548128765760c79eb7388a4b37fae2c8"
uuid = "d8e11817-5142-5d16-987a-aa16d5891078"
version = "0.4.17"

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

[[deps.MicroCollections]]
deps = ["BangBang", "InitialValues", "Setfield"]
git-tree-sha1 = "629afd7d10dbc6935ec59b32daeb33bc4460a42e"
uuid = "128add7d-3638-4c79-886c-908ea0c25c34"
version = "0.1.4"

[[deps.Mmap]]
uuid = "a63ad114-7e13-5084-954f-fe012c677804"

[[deps.MozillaCACerts_jll]]
uuid = "14a3606d-f60d-562e-9121-12d972cd8159"
version = "2022.10.11"

[[deps.NameResolution]]
deps = ["PrettyPrint"]
git-tree-sha1 = "1a0fa0e9613f46c9b8c11eee38ebb4f590013c5e"
uuid = "71a1bf82-56d0-4bbc-8a3c-48b961074391"
version = "0.1.5"

[[deps.NetworkOptions]]
uuid = "ca575930-c2e3-43a9-ace4-1e988b2c1908"
version = "1.2.0"

[[deps.ObjectFile]]
deps = ["Reexport", "StructIO"]
git-tree-sha1 = "55ce61d43409b1fb0279d1781bf3b0f22c83ab3b"
uuid = "d8793406-e978-5875-9003-1fc021f44a92"
version = "0.3.7"

[[deps.OpenBLAS_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "Libdl"]
uuid = "4536629a-c528-5b80-bd46-f80d51c5b363"
version = "0.3.21+4"

[[deps.OpenLibm_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "05823500-19ac-5b8b-9628-191a04bc5112"
version = "0.8.1+0"

[[deps.OpenSpecFun_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "13652491f6856acfd2db29360e1bbcd4565d04f1"
uuid = "efe28fd5-8261-553b-a9e1-b2916fc3738e"
version = "0.5.5+0"

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
git-tree-sha1 = "e47cd150dbe0443c3a3651bc5b9cbd5576ab75b7"
uuid = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
version = "0.7.52"

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

[[deps.PrettyPrint]]
git-tree-sha1 = "632eb4abab3449ab30c5e1afaa874f0b98b586e4"
uuid = "8162dcfd-2161-5ef2-ae6c-7681170c5f98"
version = "0.2.0"

[[deps.Printf]]
deps = ["Unicode"]
uuid = "de0858da-6303-5e67-8744-51eddeeeb8d7"

[[deps.REPL]]
deps = ["InteractiveUtils", "Markdown", "Sockets", "Unicode"]
uuid = "3fa0cd96-eef1-5676-8a61-b3b8758bbffb"

[[deps.Random]]
deps = ["SHA", "Serialization"]
uuid = "9a3f8284-a2c9-5f02-9a11-845980a1fd5c"

[[deps.Random123]]
deps = ["Random", "RandomNumbers"]
git-tree-sha1 = "552f30e847641591ba3f39fd1bed559b9deb0ef3"
uuid = "74087812-796a-5b5d-8853-05524746bad3"
version = "1.6.1"

[[deps.RandomNumbers]]
deps = ["Random", "Requires"]
git-tree-sha1 = "043da614cc7e95c703498a491e2c21f58a2b8111"
uuid = "e6cf234a-135c-5ec9-84dd-332b85af5143"
version = "1.5.3"

[[deps.Reexport]]
git-tree-sha1 = "45e428421666073eab6f2da5c9d310d99bb12f9b"
uuid = "189a3867-3050-52da-a836-e630ba90ab69"
version = "1.2.2"

[[deps.Referenceables]]
deps = ["Adapt"]
git-tree-sha1 = "e681d3bfa49cd46c3c161505caddf20f0e62aaa9"
uuid = "42d2dcc6-99eb-4e98-b66c-637b7d73030e"
version = "0.1.2"

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

[[deps.Setfield]]
deps = ["ConstructionBase", "Future", "MacroTools", "StaticArraysCore"]
git-tree-sha1 = "e2cc6d8c88613c05e1defb55170bf5ff211fbeac"
uuid = "efcf1570-3423-57d1-acb7-fd33fddbac46"
version = "1.1.1"

[[deps.Sockets]]
uuid = "6462fe0b-24de-5631-8697-dd941f90decc"

[[deps.SparseArrays]]
deps = ["Libdl", "LinearAlgebra", "Random", "Serialization", "SuiteSparse_jll"]
uuid = "2f01184e-e22b-5df5-ae63-d93ebab69eaf"

[[deps.SpecialFunctions]]
deps = ["IrrationalConstants", "LogExpFunctions", "OpenLibm_jll", "OpenSpecFun_jll"]
git-tree-sha1 = "e2cfc4012a19088254b3950b85c3c1d8882d864d"
uuid = "276daf66-3868-5448-9aa4-cd146d93841b"
version = "2.3.1"

    [deps.SpecialFunctions.extensions]
    SpecialFunctionsChainRulesCoreExt = "ChainRulesCore"

    [deps.SpecialFunctions.weakdeps]
    ChainRulesCore = "d360d2e6-b24c-11e9-a2a3-2a2ae2dbcce4"

[[deps.SplittablesBase]]
deps = ["Setfield", "Test"]
git-tree-sha1 = "e08a62abc517eb79667d0a29dc08a3b589516bb5"
uuid = "171d559e-b47b-412a-8079-5efa626c420e"
version = "0.1.15"

[[deps.StaticArrays]]
deps = ["LinearAlgebra", "Random", "StaticArraysCore"]
git-tree-sha1 = "0adf069a2a490c47273727e029371b31d44b72b2"
uuid = "90137ffa-7385-5640-81b9-e52037218182"
version = "1.6.5"
weakdeps = ["Statistics"]

    [deps.StaticArrays.extensions]
    StaticArraysStatisticsExt = "Statistics"

[[deps.StaticArraysCore]]
git-tree-sha1 = "36b3d696ce6366023a0ea192b4cd442268995a0d"
uuid = "1e83bf80-4336-4d27-bf5d-d5a4f845583c"
version = "1.4.2"

[[deps.Statistics]]
deps = ["LinearAlgebra", "SparseArrays"]
uuid = "10745b16-79ce-11e8-11f9-7d13ad32a3b2"
version = "1.9.0"

[[deps.StructIO]]
deps = ["Test"]
git-tree-sha1 = "010dc73c7146869c042b49adcdb6bf528c12e859"
uuid = "53d494c1-5632-5724-8f4c-31dff12d585f"
version = "0.3.0"

[[deps.SuiteSparse_jll]]
deps = ["Artifacts", "Libdl", "Pkg", "libblastrampoline_jll"]
uuid = "bea87d4a-7f5b-5778-9afe-8cc45184846c"
version = "5.10.1+6"

[[deps.TOML]]
deps = ["Dates"]
uuid = "fa267f1f-6049-4f14-aa54-33bafae1ed76"
version = "1.0.3"

[[deps.TableTraits]]
deps = ["IteratorInterfaceExtensions"]
git-tree-sha1 = "c06b2f539df1c6efa794486abfb6ed2022561a39"
uuid = "3783bdb8-4a98-5b6b-af9a-565f29a5fe9c"
version = "1.0.1"

[[deps.Tables]]
deps = ["DataAPI", "DataValueInterfaces", "IteratorInterfaceExtensions", "LinearAlgebra", "OrderedCollections", "TableTraits"]
git-tree-sha1 = "cb76cf677714c095e535e3501ac7954732aeea2d"
uuid = "bd369af6-aec1-5ad0-b16a-f7cc5008161c"
version = "1.11.1"

[[deps.Tar]]
deps = ["ArgTools", "SHA"]
uuid = "a4e569a6-e804-4fa4-b0f3-eef7a1d5b13e"
version = "1.10.0"

[[deps.Test]]
deps = ["InteractiveUtils", "Logging", "Random", "Serialization"]
uuid = "8dfed614-e22c-5e08-85e1-65c5234f0b40"

[[deps.ThreadedScans]]
deps = ["ArgCheck"]
git-tree-sha1 = "ca1ba3000289eacba571aaa4efcefb642e7a1de6"
uuid = "24d252fe-5d94-4a69-83ea-56a14333d47a"
version = "0.1.0"

[[deps.TimerOutputs]]
deps = ["ExprTools", "Printf"]
git-tree-sha1 = "f548a9e9c490030e545f72074a41edfd0e5bcdd7"
uuid = "a759f4b9-e2f1-59dc-863e-4aeb61b1ea8f"
version = "0.5.23"

[[deps.Transducers]]
deps = ["Adapt", "ArgCheck", "BangBang", "Baselet", "CompositionsBase", "ConstructionBase", "DefineSingletons", "Distributed", "InitialValues", "Logging", "Markdown", "MicroCollections", "Requires", "Setfield", "SplittablesBase", "Tables"]
git-tree-sha1 = "53bd5978b182fa7c57577bdb452c35e5b4fb73a5"
uuid = "28d57a85-8fef-5791-bfe6-a80928e7c999"
version = "0.4.78"

    [deps.Transducers.extensions]
    TransducersBlockArraysExt = "BlockArrays"
    TransducersDataFramesExt = "DataFrames"
    TransducersLazyArraysExt = "LazyArrays"
    TransducersOnlineStatsBaseExt = "OnlineStatsBase"
    TransducersReferenceablesExt = "Referenceables"

    [deps.Transducers.weakdeps]
    BlockArrays = "8e7c35d0-a365-5155-bbbb-fb81a777f24e"
    DataFrames = "a93c6f00-e57d-5684-b7b6-d8193f3e46c0"
    LazyArrays = "5078a376-72f3-5289-bfd5-ec5146d43c02"
    OnlineStatsBase = "925886fa-5bf2-5e8e-b522-a9147a512338"
    Referenceables = "42d2dcc6-99eb-4e98-b66c-637b7d73030e"

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

[[deps.UnsafeAtomics]]
git-tree-sha1 = "6331ac3440856ea1988316b46045303bef658278"
uuid = "013be700-e6cd-48c3-b4a1-df204f14c38f"
version = "0.2.1"

[[deps.UnsafeAtomicsLLVM]]
deps = ["LLVM", "UnsafeAtomics"]
git-tree-sha1 = "ead6292c02aab389cb29fe64cc9375765ab1e219"
uuid = "d80eeb9a-aca5-4d75-85e5-170c8b632249"
version = "0.1.1"

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
# ╟─1ce7ef5b-c213-47ba-ac96-9622b62cda61
# ╟─316b2027-b3a6-45d6-9b65-e26b4ab42e5e
# ╟─d8ce73d3-d4eb-4d2e-b5e6-88afe0920a47
# ╟─94d6612c-364c-4892-ac4b-b0ca21f49589
# ╟─cd04a158-150e-4679-8602-68ab9666f21e
# ╟─741de66c-968e-4dc6-ad7a-67ac5f995775
# ╟─2a020c98-01a2-4ca0-8db9-8636394ab05c
# ╟─4d1468bb-90db-45cb-b21e-7045ccb50d06
# ╟─eee2e610-a771-4c97-acc3-4bc209368a56
# ╟─f9a7be5b-4019-4137-ab07-fed0faec48b3
# ╟─af0b34cb-1a6a-437c-9888-c358c1bed4f0
# ╟─d3d08b5a-d8ce-4832-a7bd-0ec3f9db517f
# ╟─b9740055-70da-4330-a533-6ff779463808
# ╟─d5fa33ed-fa54-44a6-aeb5-2e3c825149dd
# ╟─3bb2feb8-6e54-44f4-bb81-7afea27f64d5
# ╟─914e41bb-7cfc-44f7-9764-a3351c586bc7
# ╠═a02e1141-6567-4675-bd65-34d0b5133f08
# ╠═282922d5-7283-43df-bca5-3ba1f9d333f6
# ╠═ec2066da-6431-422f-b9c3-57ee12d4411c
# ╠═dbefd6a4-0529-4eb4-8f0d-c6a8dee4f9d8
# ╠═563f2567-ca72-4133-b3a8-0aeb217a4ca3
# ╠═ecebd8cf-06ac-43c0-8c14-a9cd891d05b6
# ╠═3c4e85fd-2741-4a81-be38-0d8d7a28c129
# ╠═98ff3fc5-8a4a-4185-a656-82769d90b1fe
# ╟─f98a63cc-253c-48ad-bfb5-52c70983049a
# ╟─8b297ffb-bc91-4603-b144-5838a7c0b314
# ╟─54d44ca6-9b20-476e-9d79-b808e42ab5d9
# ╠═715d4760-6020-41c5-b16a-740a160655c7
# ╠═a504a5d6-df69-4ef7-b19e-09b165944f89
# ╠═bc5156bd-e0e3-4032-8d37-e4e61274aabe
# ╠═9c04effb-2b4b-401c-9858-d9491c20d895
# ╠═5234f042-755d-4550-a73c-5136c194f1ba
# ╠═77d86ec7-07e5-4464-9992-c4baa931c79d
# ╠═814a1ef0-f7fc-4180-a868-fb932951a1ad
# ╠═bc4b4f32-9a54-48f2-8da0-a01ab3d17992
# ╠═62ace3b8-0e38-4150-80e6-2488d19f8d5d
# ╠═25dd3208-1b76-4122-9de4-7c177f136b6d
# ╟─b6b281af-64a1-44b4-a9b6-ee0ba17f5c0b
# ╠═0b5dd506-d79a-4094-8c9e-e885f0273ab1
# ╟─24cb813e-af85-435f-9c43-db38e8eaa1d2
# ╟─f69f32fc-f759-4567-9c1c-37676eaf713d
# ╟─b8fb2e42-7d3a-4654-8bbd-6b342239882e
# ╟─d2ead952-d962-457a-8eba-ea4f47c58bfa
# ╟─a93bb394-4566-4dc2-a3b0-e535013c5453
# ╟─e040dee5-387d-4755-81fa-a4c46a2323b2
# ╟─0c91f6b7-36d1-4d9a-8508-53d0e3bd05c2
# ╟─8759b216-cc38-42ed-b85c-04d508579c54
# ╠═1c640715-9bef-4935-9dce-f94ff2a3740b
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
