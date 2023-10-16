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

# ╔═╡ c76b6672-53df-4fd1-a39a-609248914446
using PlutoUI, PlutoTeachingTools

# ╔═╡ 2aa60451-2e25-4b9d-ba0c-13b416f0d7af
using BenchmarkTools

# ╔═╡ 4e6cb703-b011-4f8a-8c9a-4863459ee7a2
md"> Astro 528: High-Performance Scientific Computing for Astrophysics (Fall 2023)"

# ╔═╡ aecdcdbc-5ef6-4a7b-bd65-d01ed1cfe497
ChooseDisplayMode()

# ╔═╡ f7fdc34c-2c99-493d-9977-f206bb7a2810
md"ToC on side $(@bind toc_aside CheckBox(;default=true))"

# ╔═╡ dddb4b7c-b23c-41a4-ae2a-d75bab617104
TableOfContents(aside=toc_aside)

# ╔═╡ 545d6631-9a06-4e59-a306-cddc6d405689
md"""
# Week 9 Discussion:
### Parallelization for Distributed Memory Systems &
### Using Computer Clusters (e.g., Roar Collab) 
"""

# ╔═╡ f3165718-746e-431d-9e2d-e1ce39722d4d
md"""
#### Parallel Architectures
- Shared Memory (Lab 6)
- Distributed Memory (Lab 7)
- Hardware Accelerator (Lab 8)
"""

# ╔═╡ 98fb8836-d12b-426a-8c68-9e93f0a19973
md"# Penn State's Roar Clusters"

# ╔═╡ 239d5354-6eec-431d-874e-617ca6a1ce41
md"""
- Roar Restricted = Original Roar ≈ "ACI-b"
  - Prioritizes security and compliance with NIST 800-171
- Roar Collab
  - For ["Level I" data](https://security.psu.edu/awareness/icdt/)
"""

# ╔═╡ dc55d795-eb2c-44b9-a0f5-02b31e6fe71c
tip(md"""
Level 1:  Unauthorized access, use, disclosure, or loss is likely to have low or no risk to individuals, groups, or the University. These adverse effects may, but are unlikely to, include limited reputational, psychological, social, or financial harm. Low Risk Information may include some non-public data. Examples include:
- Data made freely available by public sources
- Published data
- Educational data
- Initial and intermediate Research Data
""")

# ╔═╡ 6f4d55a3-621c-4710-81e4-37a46dd9eeff
md"""### ICDS Hardware

Over 30,000 CPU cores spread across:
- Basic nodes: 
  - 24-64 cores
  - 128-256GB RAM/node
  - 4 GM/core
  - Ethernet
- Standard Memory nodes:
   - 48 cores
   - 384-512 GB RAM per node
   - 8-10 GB/core
   - Infiniband
- High Memory nodes:
  - 40 cores
  - 1 TB RAM per node
  - 25 GB/core
  - Infiniband
- GPU (A100) nodes:
  - 2 NVIDIA A100 GPUs
  - 24 CPU cores/node
  - 192 GB RAM
  - Infiniband
- GPU (P100) nodes:
  - 1 NVIDIA P100 GPU
  - 24 CPU cores/node
  - 256 GB RAM
  - Infiniband
- Multi-Instance GPU (1/8th A100 Slice)	of node
  - ≈900 CUDA core and 5GB VRAM
  - CPU cores and 24 GB RAM
- Multi-Instance GPU (1/2 A100 Slice) of node 
  - ≈3600 CUDA core and 20GB VRAM
  - 12 CPU cores and 96 GB RAM	$200 per partial
- Various special nodes: login/submit, data manager, etc.
"""

# ╔═╡ 0e937ed1-f40c-4889-b3e6-292ff43650ef
md"""
## Queues/Allocations
- Open Queue
- Guarenteed Responce Time Allocations (GReaT)
"""

# ╔═╡ 895e1960-8593-41c1-8b7a-ecc74b28f23a
md"""### Open Queue
University offers to Penn State researchers free of charge:
- Up to 100 jobs pending
- Up to 100 cores executing jobs at any given time
- All Roar users have equal priority for Open Queue access.  


Limitations:
- Maximum 48-hour job wall-time
- Maximum 24-hour interactive session durations
- 800G total memory across all jobs
- Jobs start and run only when sufficient idle cores are available
- No guaranteed start time
- Jobs may be suspended if cores are needed for jobs on other queues
"""

# ╔═╡ 5cc81ea1-e2b9-48b3-807d-aad2083c8781
md"""
### GReaT Allocations
Principal Investigators can pay for their group to gain access to increased resources:
- Each allocation is for a specific number of cores and hardware type
- Any jobs that you submit within your allocation limit are guaranteed to start within one hour of when you submit them.  (Usually much faster.)
- No wall time limit
- Burst capability (default up to 4N cores for a limited period of time)
- 5 TB of Group storage with minimum purchase
"""

# ╔═╡ b438d653-146e-4ebd-97ab-720a0ef837bd
md"""
## Storage on Roar Collab
- Home	/storage/home/userID:	10 GB,  Backed up, lower performance than group/scratch 
- Work	/storage/work/userID:	128 GB,  Backed up
- Scratch	/storage/scratch/userID:	No limit, **NOT** backed up, **Auto-deleted after 30 days**
- Group	/storage/group/groupID/default/:		Whatever you pay for, Backed up
- Archive	(from data manager nodes):		Whatever you pay for, Tape robot → Suggested lower limit of 1G/file.  
"""

# ╔═╡ 94f69762-74a9-4857-8d84-84c68ec0eac0
md"""
# Using a supercomputing facility
- Log in to an interactive node
- Prepare code and data files
- Create script to perform expensive calculation
- Submit `job` to run a scheduler/resource manager
- Wait for job to start
- Wait for job to finish
- Log in to interactive node to see/download results
"""

# ╔═╡ 4eaec57f-c899-43ed-827b-bd6c0aa186a5
md"## Submitting jobs to Roar Collab cluster"

# ╔═╡ 45ad9b8f-e946-41cd-8dc4-24f9952bc342
md"""
## Slurm commands for batch jobs:

- `sbatch`: Submit a job 
- `scancel`: Cancel a job
- `squeue`: Check the status of a job	
- `squeue –u YOURID`: Check the status of all jobs by user	
- `scontrol hold`: Hold a job	
- `scontrol release`: Release a job	
"""

# ╔═╡ d36148c7-b65c-4ed7-ad9c-d2a83ca30156
md"""
## Submitting a job
```shell
cd dir_with_script_to_run
sbatch job_script.slurm
```
"""

# ╔═╡ 3e673750-85d0-4e84-8a81-8514af848d97
md"""
## What's in job_script.slurm?
```bash
#!/bin/bash
#SBATCH --partition=open 
#SBATCH --time=0:05:00 
#SBATCH --nodes=1 
#SBATCH --ntasks=1 
#SBATCH --ntasks-per-node=1
#SBATCH --mem-per-cpu=1GB
#SBATCH --job-name=ex1_serial

#SBATCH --mail-type=ALL
#SBATCH --mail-user=YOUR_EMAIL_HERE@psu.edu

# begin standard shell script to run your code
...
```

"""

# ╔═╡ 72b3f722-ae08-4455-b463-584c1add5dc7
md"""
## Accessing the allocation for our class
Replace
```shell
#SBATCH --partition=open 
```
with
```shell
#SBATCH --partition=sla-prio
#SBATCH --account=ebf11-fa23
```
"""

# ╔═╡ 321a7187-2dcf-4159-be83-7c2f812d1e2a
md"""
## Bursting
```bash
#SBATCH --account=ebf11-fa23
#SBATCH --partition=burst 
#SBATCH --qos=burst4x 
```
"""

# ╔═╡ 21dc6771-a1f2-4841-a3c0-0bb17dec2c33
md"""
## Parallel Jobs
- Shared memory
```bash
#SBATCH --nodes=1 
#SBATCH --ntasks-per-node=4
#SBATCH --ntasks=4 
...
julia --project -t $SLURM_TASKS_PER_NODE ex1_parallel.jl
```
- Distributed memory on one node
```bash
#SBATCH --nodes=4 
#SBATCH --ntasks-per-node=1
#SBATCH --ntasks=4 
...
julia --project --machine-file $PBS_NODEFILE ex1_parallel.jl
julia --project=. -p $SLURM_TASKS_PER_NODE ex1_parallel.jl
```
- Distributed memory over multiple nodes
```bash
#SBATCH --nodes=4 
#SBATCH --ntasks-per-node=1
#SBATCH --ntasks=4 
...
julia --project=. -e 'include("setup_slurm_manager.jl"); include("ex1_parallel.jl") ' 

```
"""

# ╔═╡ b7081a51-fb3c-4114-b87b-3a9f37547110
md"""
```julia
import Pkg
Pkg.UPDATED_REGISTRY_THIS_SESSION[] = true  
Pkg.activate(".")                            # If didn't specify on command line
Pkg.instantiate()                            # Make sure installed
Pkg.precompile()                             # and precompiled before adding workers

using Distributed, SlurmClusterManager;

addprocs(SlurmManager(), exeflags=["--project=$(Base.active_project())",] )

@everywhere (import Pkg; Pkg.UPDATED_REGISTRY_THIS_SESSION[] = true;)   
```
"""

# ╔═╡ e936caa9-c3ed-48d0-be3a-40874c07f1cd
md"""
## Slurm Job Arrays
```bash
#SBATCH --nodes=1 
#SBATCH --ntasks=1 
#SBATCH --array=1-10%5
...
julia --project=. ex1_job_array.jl $SLURM_ARRAY_TASK_ID 
```
"""

# ╔═╡ 34c2815f-c9fc-4885-9473-0f8771821441
md"""
## Accessing Slurm Environment Variables
```bash
...
echo "Starting job $SLURM_JOB_NAME"
echo "Job id: $SLURM_JOB_ID"
echo "Number of nodes: $SLURM_NNODES"
echo "Processor cores per node:  $SLURM_TASKS_PER_NODE"
echo "About to change into  $SLURM_SUBMIT_DIR"
echo "Job arrayid: $SLURM_ARRAY_TASK_ID"
cd $SLURM_ARRAY_TASK_ID
echo "About to start Julia"
julia --project=. -t $SLURM_TASKS_PER_NODE ex1_job_array.jl $SLURM_ARRAY_TASK_ID 
echo "Julia exited"
```
"""

# ╔═╡ fdee5aa9-8957-4e6a-859c-7d086c6ce83c
md"""
### Accessing command line parameters
- Simple
```julia
job_arrayid = parse(Int64,ARGS[1])
```
More flexible packages:
- [ArgParse.jl](https://carlobaldassi.github.io/ArgParse.jl/stable/)
- [Comonicon.jl](https://github.com/comonicon/Comonicon.jl)

"""

# ╔═╡ e768db3b-5c68-4bdb-9d28-b4b7a4be6072
md"""
```julia
using CSV, DataFrames, Random 

job_array_data = CSV.read("ex1_job_array_in.csv", DataFrame)
job_arrayid = parse(Int64,ARGS[1])


idx = findfirst(x-> x==job_arrayid, job_array_data[!,:array_id] )
@assert idx != nothing
@assert 1 <= idx  <= size(job_array_data, 1)

n = job_array_data[idx,:n]
s = job_array_data[idx,:seed]

Random.seed!(s)

...
df_out = compute_something(n)
...

output_filename = @sprintf("ex1_out_%02d.csv",job_arrayid)
CSV.write(output_filename, df_out)
```
"""

# ╔═╡ 1a4408f3-9223-4726-9495-2a660ab20555
md"""
## Requesting an interactive job (for debugging)
```bash
salloc -N 1 -n 4 --mem-per-cpu=1024 -t 3:00:00
```
"""

# ╔═╡ 19216b89-bd81-4af7-961f-629f2c7dd9b1
md"# Q&A"

# ╔═╡ a9343319-f10c-4a38-9dd1-7f95c29fa42e
blockquote(md"""
What’s special with Pluto Notebook in helping us managing distributed computation?
""")

# ╔═╡ 1c80868b-f005-4ce7-94ff-2ffb504ddf77
md"""
Nothing. I recommend not performing distributed computing inside a Pluto notebook, because Pluto is already using multiple processes for each notebook's kernel and the user-interface.
"""

# ╔═╡ 3f8d11ba-ead9-4870-a9b3-47cae647dac5
blockquote(md"""
Are we likely to encounter a need for using the --machine-file option on Roar Collab?
""")

# ╔═╡ 378d2c5c-b326-4544-8e08-e8c43e7a6f8a
md"""
No, because they've moved from PBS to Slurm. See example for using `SlurmClusterManager` in lab 7.
"""

# ╔═╡ 620bc421-284d-43d8-86d5-a44a605a9d27
blockquote(md"""
If I wanted to get very controlling with data/memory management, is there a way to use pointers to allocate memory more concisely in Julia?
""")

# ╔═╡ d067a863-be21-4fab-9c0a-8d0c263611b8
md"""
Technically, yes...
See [documentation](pointer) for `unsafe_load`, `unsafe_store!`, `pointer`, `pointer_from_objref`, `wrap`, etc.   But please only do that if you really, really need to.  
Using raw pointers means your data can't be tracked by the garbage collector, and thus is very much discouraged.  However, sometimes it is necessary for sharing data across cross-lanaguages.  
"""

# ╔═╡ 6f5cf567-b7c9-41ea-8701-2570a413b9be
blockquote(md"""
Can you clarify the differences between workers, threads, processes, and channels and how they operate within parallelization across distributed/shared memory?
""")

# ╔═╡ 4ed8d861-4173-48dd-b2f0-04cc21ef68c7
md"""
- Worker:  More generatl term and could refer to either a thread or a process.
- Threads:  All access a common memory system.  
- Processes:  Each has its own memory space.  Must send messages between workers. communications
- Channel:  Mechanism for communications between workers.
"""

# ╔═╡ 1865d52f-7fb4-47f1-bc68-15b2b92156df
blockquote(md"""
We have now seen parallel maps in both lab and reading, but I am still struggling with understanding how to correctly apply them. In what situation would it be useful to consider using a pmap or a map reduce to help with our projects?
""")

# ╔═╡ e9bae383-6344-4a2b-8061-2c32d28c5d8d
md"""
- If you can acheive your science goal using:
- `ThreadsX.map` (shared memory) and 
- `pmap` (distributed memory), 
then that's were I suggest you start.

If you can acheive your science goal using:
- `ThreadsX.mapreduce` (shared memory) and
- `ParallelUtilities.pmapreduce` (distributed memory), 
then there's a good chance that's were you should stop!
"""

# ╔═╡ fb495f19-530c-4044-83b1-0db7343269f0
blockquote(md"""
In what circumstance is a reduction operator necessary? What exactly is its purpose?
""")

# ╔═╡ c3c4eaa7-6aa3-4000-8348-39333f2d2c14
md"""
It's not necessary.  But it can significantly improve efficiencty if you can reduce the communications between workers by formulating your problem as a `mapreduce` operation. 
"""

# ╔═╡ b092334b-b6a4-4753-b583-6079d873c52b
blockquote(md"""
What’s the best way to decide on the parallelization method? How should we decide between built-in functions like @distributed vs something external like floop or is it just by preference?
""")

# ╔═╡ c9013543-de41-4ca7-9e62-046b169b95d4
md"# Helper Code"

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
BenchmarkTools = "6e4b80f9-dd63-53aa-95a3-0cdb28fa8baf"
PlutoTeachingTools = "661c6b06-c737-4d37-b85c-46df65de6f69"
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"

[compat]
BenchmarkTools = "~1.3.2"
PlutoTeachingTools = "~0.2.13"
PlutoUI = "~0.7.52"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.9.2"
manifest_format = "2.0"
project_hash = "86aec2b4e792ab5744cd0e7af328a5a0304d93ab"

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

[[deps.BenchmarkTools]]
deps = ["JSON", "Logging", "Printf", "Profile", "Statistics", "UUIDs"]
git-tree-sha1 = "d9a9701b899b30332bbcb3e1679c41cce81fb0e8"
uuid = "6e4b80f9-dd63-53aa-95a3-0cdb28fa8baf"
version = "1.3.2"

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
git-tree-sha1 = "c47c5fa4c5308f27ccaac35504858d8914e102f9"
uuid = "ac1192a8-f4b3-4bfe-ba22-af5b92cd3ab2"
version = "0.9.4"

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
git-tree-sha1 = "81dc6aefcbe7421bd62cb6ca0e700779330acff8"
uuid = "aa1ae85d-cabe-5617-a682-6adf51b2e16a"
version = "0.9.25"

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

[[deps.Printf]]
deps = ["Unicode"]
uuid = "de0858da-6303-5e67-8744-51eddeeeb8d7"

[[deps.Profile]]
deps = ["Printf"]
uuid = "9abbd945-dff8-562f-b5e8-e1ebf5ef1b79"

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
git-tree-sha1 = "609c26951d80551620241c3d7090c71a73da75ab"
uuid = "295af30f-e4ad-537b-8983-00126c2a3abe"
version = "3.5.6"

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
git-tree-sha1 = "aadb748be58b492045b4f56166b5188aa63ce549"
uuid = "410a4b4d-49e4-4fbc-ab6d-cb71b17b3775"
version = "0.1.7"

[[deps.URIs]]
git-tree-sha1 = "b7a5e99f24892b6824a954199a45e9ffcc1c70f0"
uuid = "5c2747f8-b7ea-4ff2-ba2e-563bfd36b1d4"
version = "1.5.0"

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
# ╟─4e6cb703-b011-4f8a-8c9a-4863459ee7a2
# ╟─dddb4b7c-b23c-41a4-ae2a-d75bab617104
# ╟─aecdcdbc-5ef6-4a7b-bd65-d01ed1cfe497
# ╟─f7fdc34c-2c99-493d-9977-f206bb7a2810
# ╟─545d6631-9a06-4e59-a306-cddc6d405689
# ╟─f3165718-746e-431d-9e2d-e1ce39722d4d
# ╟─98fb8836-d12b-426a-8c68-9e93f0a19973
# ╟─239d5354-6eec-431d-874e-617ca6a1ce41
# ╟─dc55d795-eb2c-44b9-a0f5-02b31e6fe71c
# ╟─6f4d55a3-621c-4710-81e4-37a46dd9eeff
# ╟─0e937ed1-f40c-4889-b3e6-292ff43650ef
# ╟─895e1960-8593-41c1-8b7a-ecc74b28f23a
# ╟─5cc81ea1-e2b9-48b3-807d-aad2083c8781
# ╟─b438d653-146e-4ebd-97ab-720a0ef837bd
# ╟─94f69762-74a9-4857-8d84-84c68ec0eac0
# ╟─4eaec57f-c899-43ed-827b-bd6c0aa186a5
# ╟─45ad9b8f-e946-41cd-8dc4-24f9952bc342
# ╟─d36148c7-b65c-4ed7-ad9c-d2a83ca30156
# ╟─3e673750-85d0-4e84-8a81-8514af848d97
# ╟─72b3f722-ae08-4455-b463-584c1add5dc7
# ╟─321a7187-2dcf-4159-be83-7c2f812d1e2a
# ╟─21dc6771-a1f2-4841-a3c0-0bb17dec2c33
# ╟─b7081a51-fb3c-4114-b87b-3a9f37547110
# ╟─e936caa9-c3ed-48d0-be3a-40874c07f1cd
# ╟─34c2815f-c9fc-4885-9473-0f8771821441
# ╟─fdee5aa9-8957-4e6a-859c-7d086c6ce83c
# ╟─e768db3b-5c68-4bdb-9d28-b4b7a4be6072
# ╟─1a4408f3-9223-4726-9495-2a660ab20555
# ╟─19216b89-bd81-4af7-961f-629f2c7dd9b1
# ╟─a9343319-f10c-4a38-9dd1-7f95c29fa42e
# ╟─1c80868b-f005-4ce7-94ff-2ffb504ddf77
# ╟─3f8d11ba-ead9-4870-a9b3-47cae647dac5
# ╟─378d2c5c-b326-4544-8e08-e8c43e7a6f8a
# ╟─620bc421-284d-43d8-86d5-a44a605a9d27
# ╟─d067a863-be21-4fab-9c0a-8d0c263611b8
# ╟─6f5cf567-b7c9-41ea-8701-2570a413b9be
# ╟─4ed8d861-4173-48dd-b2f0-04cc21ef68c7
# ╟─1865d52f-7fb4-47f1-bc68-15b2b92156df
# ╟─e9bae383-6344-4a2b-8061-2c32d28c5d8d
# ╟─fb495f19-530c-4044-83b1-0db7343269f0
# ╟─c3c4eaa7-6aa3-4000-8348-39333f2d2c14
# ╟─b092334b-b6a4-4753-b583-6079d873c52b
# ╟─c9013543-de41-4ca7-9e62-046b169b95d4
# ╠═c76b6672-53df-4fd1-a39a-609248914446
# ╠═2aa60451-2e25-4b9d-ba0c-13b416f0d7af
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
