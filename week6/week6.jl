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

# ╔═╡ 531f25b0-2d29-4db1-ab44-b927b6377945
begin
	using PlutoUI, PlutoTest, PlutoTeachingTools
end

# ╔═╡ a876b548-3b0e-48d1-98bf-6bf005230e92
md"> Astro 528: High-Performance Scientific Computing for Astrophysics (Fall 2023)"

# ╔═╡ b9baebea-2312-4c28-905c-b47ec3a26415
ChooseDisplayMode()

# ╔═╡ 373376f2-3557-42f5-bdeb-9ae70ed3d060
md"""
# Week 6 Discussion
"""

# ╔═╡ 3d678919-c197-4c9d-aed9-bf94dd431c4c
md"""
# Admin Announcements
## Labs
- Review feedback on Lab 4, Ex 2 via GitHub
- No lab this week, so can work on your projects
- Still meet Wednesday for a group work session
"""

# ╔═╡ b7412f06-287f-41b1-b0b4-0dec44f36a08
md"""
## Class project
- Review [project instructions](https://psuastro528.github.io/Fall2023/project/) on website
- Serial code should be ready for peer code review by Oct 2
- Sign up for [project presentation schedule](https://github.com/PsuAstro528/PresentationsSchedule2023)
  - Click **Fork** button to create your own repository 
  - Edit README.md in your repository (can use web interface for small chagnes)
  - Commmit change to yoru repo and push (if editting local repo)
  - Create **Pull Request** to merge your change into the class repository

"""

# ╔═╡ 7a13c062-b641-4894-9288-4a79c1005c49
md"""
## Serial version of Code Rubic
- Code performs proposed tasks (1 point)
- Comprehensive set of unit tests, at least one integration or regression test (1 point)
- Code passes tests (1 point)
- Student code uses a version control system effectively (1 point)
- Repository includes many regular, small commits (1 point)
- Documentation for functions’ purpose and design (1 point)
- Comprehensive set of assertions (1 point)
- Variable/function names consistent, distinctive & meaningful (1 point)
- Useful & consistent code formatting & style (1 point)
- Code is modular, rather than having chunks of same code copied and pasted (1 point)
"""

# ╔═╡ 56ae82e4-9e28-438b-a6c8-d099b56af913
md"""
## Peer Review Logistics
- Access
   - I'll send you GitHub ID of peer reviewer via Canvas
   - Make sure reviewer(s) can access your repo
   - Make sure you can access the repo you are to review

- If using Jupyter notebooks, make sure to add Markdown version of code for getting feedback
  -  Install Weave (once): `julia --project=. -e 'import Pkg; Pkg.add("Weave")' # 
  -  Convert Jupyter notebook to markdwon (each time you want to update the markdown): `julia --project=. -e 'using Weave; convert\_doc("NOTEBOOK\_NAME.ipynb","NOTEBOOK\_NAME.jmd")' 
- Provide most feedback via [GitHub Issues](https://guides.github.com/features/issues/)
"""

# ╔═╡ 533dbe7a-aae6-41dd-8737-2f995bb6c7f6
md"""
# Q&A
"""

# ╔═╡ d8fd8af3-a65d-4230-bb35-e1144e459520
blockquote(md"""
What exactly is "scratch" memory, and what differentiates it from other kinds of memory?
""")

# ╔═╡ 838815fa-5917-4347-bb3c-bf8300d2d942
md"""
"Scratch" can mean different things depending on context:
- A separate physical disk or file system that is intended to be used for temporary files.
  - E.g., Roar's `/storage/scratch/USERID/` provides large storage but autodeletes your files
- A portion of memory allocated and reserved for holding scratch data
  - E.g., preallocating a workspace to be used for auto-differentiation, integration, factoring a matrix, etc.
"""

# ╔═╡ 5a733830-5b36-4198-ae24-2d8b92fafbdd
blockquote(md"""
Is there a way in Julia where we can easily identify memory that can be released or the program can automatically help us release memory?
""")

# ╔═╡ 352ba7a9-5adb-48d1-a2f5-a0f738dd3ffe
md"""
- That's the garbage collector's job.
- But you can make it's just easier or harder.
"""

# ╔═╡ 2c809a46-3592-4a39-84e2-f7520c6e7bfe
md"""
## Other Questions
"""

# ╔═╡ c8b93838-61ee-4c11-82de-e54a1d1b68af
md"""
## Garbage collection
"""

# ╔═╡ f965c656-6b7b-441d-8111-855ecfe79ca6
blockquote(md"""
How does memory function from cell-to-cell within a notebook? Is it more efficient to split up code over many cells, or have them operate in the same one? How does this impact runtime and general performance?
""")

# ╔═╡ f0fc9af7-737c-4c08-a772-1136be959a6d
md"""
- It's more efficient to split up code into separate functions (regardless of whether they are in the same cell or not).
- There might be a very slight latency cost of having lots of cells.  But that's unlikley significant unless you are making a really big notebook.
"""

# ╔═╡ d2cc4026-b2f0-4201-bf3b-c1615bbc9ab7
blockquote(md"""
What are the main causes of thrashing and how does Julia mitigate it? Specifically, how does Julia’s garbage collection reduce thrashing, if there even is a strong connection?
""")

# ╔═╡ fed62143-6d25-4d6a-927b-84f5d20fab0d
md"""
- Lots of small allocations on the heap
- Java (probably the first "major" language to have garbage collection built-in) gave garbage collection a bad reputation because it only allows mutable user-defined types (and passes all objects by pointers), making it quite hard to avoid heap allocation of even very small objects.  
- Julia (and C#) encourage the use of immutable types
- Julia pass variables by reference (so they can pass variables on the stack)
- C# passes variables by value by default (so they stay on stack, but often unnecessary stack allocations) and can pass by reference.
"""

# ╔═╡ a541ae26-c160-4549-af71-c4473f0eefb7
blockquote(md"""
How severe will thrashing be in a high-level language such as Julia? Should we worry about it immediately or only during optimization?
""")

# ╔═╡ 603442cb-fdd9-4551-b503-6af0dddc86d7
md"""
- Thrasing is a result of programming practices.
- When you're a beginning programmer, focus on other things first.  Benchmark/profile to find inefficient code and then optimize.
- As you gain more experience, you'll start to recognize places where thrashing could occur as you start to write them.  In that case, a little planning early on can save work down the road. 
"""

# ╔═╡ 0969fdf8-9223-4e48-99f9-ef353d92fdb2
blockquote(md"""
How does one check if the code would cause a memory leak?
""")

# ╔═╡ 76c7abf5-8eb5-4fc0-bca0-7c8098699fc1
md"""
- If using pure Julia, then garbage collector prevents leaks (at least in theory)
- In practice, you can use poor practices that cause it to use lots of memory, e.g.,
   - Large/many variables in global/module scope
   - Not organizing code into self-contained functions
   - Allocating more memory than you really need
   - Many small allocations
- If you call C, Fortran, Python, R, etc., then memory leaks are possible.  
- Test your code
- `@time` or `@allocated` to count number/ammount of allocations.  Does it match what you expect?
- In ProfileCanvas.jl, can use `@profview_allocs` to visually find functions/lines that allocate lots of memory (not necessarily a leak).
"""

# ╔═╡ a4e4c54b-cda4-43af-b9ae-b1f5337f5fd0
blockquote(md"""
Can you demonstrate how to import a julia program into python?
""")

# ╔═╡ 4a4c7d04-e9d3-4640-aaf6-cb62a759ee30
md"""
```python
from julia import Base
Base.sind(90)
```

```python
from julia import Main
Main.xs = [1, 2, 3]
Main.eval("sin.(xs)")
```
"""

# ╔═╡ d2f4bb2d-d222-4c61-9c63-a57bdfef1927
md"""
```python
import numpy
import julia

x = np.array([0.0, 0.0, 0.0])

j = julia.Julia()
j.include("my_julia_code.jl")
j.function_in_my_julia_code(x)
```
"""

# ╔═╡ 53f5a5ca-201f-4aea-aa4c-fe82ae0249f2
md"""
Inside Jupyter notebook:
```python
In [1]: %load_ext julia.magic
Initializing Julia runtime. This may take some time...

In [2]: %julia [1 2; 3 4] .+ 1
Out[2]:
array([[2, 3],
       [4, 5]], dtype=int64)
In [3]: arr = [1, 2, 3]

In [4]: %julia $arr .+ 1
Out[4]:
array([2, 3, 4], dtype=int64)

In [5]: %julia sum(py"[x**2 for x in arr]")
Out[5]: 14
```
"""

# ╔═╡ e7736d75-ca00-4b63-90cb-b70f4a4f1a48
md"""
# Preping for Code Review
## Make it easy for your reviewer
- Provide overview of what it's doing in README.md
- Include an example of how to run/use code
- What files should they focus on?
- What files should they ignore?
- Where should they start?
- What type of feedback would you be most appreciative of?

## Make it easy for you
If you have a large code base, then
- Move most code out of notebooks and into `.jl` files, as functions mature.
  - `@ingredients "src/my_great_code.jl` from Pluto notebooks
  - `include("src/my_great_code.jl")` from Jupyter notebooks
  - Near end of semester, I'll describe how to make your code into a registered package.  Then you could simple do `use MyGreatPackage`.
- Organize functions into files `.jl` files in `src` directory
- Use `test`, `examples`, `data`, `docs`, etc. directories as appropritate

"""

# ╔═╡ ac33892a-64ca-412b-865d-cefe2be1df15
md"""
## Peer Code Review Rubric
- Constructive suggestions for improving programming practices (1 point)
- Specific, constructive suggestions for improving code readability/documentation (1 point)
- Specific, constructive suggestions for improving tests and/or assertions (1 point)
- Specific, constructive suggestions for improving code modularity/organization/maintainability (1 point)
- Specific, constructive suggestions for improving code efficiency (1 point)
- Finding any bugs (if code author confirms) (bonus points?)
"""

# ╔═╡ f508c1c8-945b-4b99-8985-5f10946b0239
md"""
![Don't make assumptions cartoon](https://miro.medium.com/max/560/1*g95FYDe5j9X_9SqEj1tycQ.jpeg)

(Credit: [Manu](https://ma.nu/) via [BetterProgramming.pub](https://betterprogramming.pub/13-code-review-standards-inspired-by-google-6b8f99f7fd67))
"""

# ╔═╡ e2a60b81-1584-4d2d-8b08-9055d362cdfb
md"""
# Learning from others with more experience conducting Code Reviews
## [Best Practices for Code Review @ Smart Bear](https://smartbear.com/learn/code-review/best-practices-for-peer-code-review/)
1. Review fewer than 400 lines of code at a time
2. Take your time. Inspection rates should under 500 LOC per hour
3. **Do not review for more than 60 minutes at a time**
4. Set goals and capture metrics
5. **Authors should annotate source code before the review**
6. **Use checklists**
7. Establish a process for fixing defects
8. **Foster a positive code review culture**
9. Embrace the subconscious implications of peer review
10. **Practice lightweight code reviews**
"""

# ╔═╡ 840a2af4-4eab-4857-879d-a9c62b1e27a1
md"""
## [How to excel at code reviews @ BetterProgramming](https://betterprogramming.pub/13-code-review-standards-inspired-by-google-6b8f99f7fd67)
1. The code improves the overall health of the system
2. Quick code reviews, responses, and feedback
3. **Educate and inspire during the code review**
4. Follow the standards when reviewing code
5. Resolving code review conflicts
6. Demo UI changes as a part of code review
7. Ensure that the code review accompanies all tests
8. **When focused, do not interrupt yourself to do code review**
9. Review everything, and **don’t make any assumptions**
10. **Review the code with the bigger picture in mind**
"""

# ╔═╡ 6a0d5ba5-40d0-445d-a0fa-32fcfbad00c9
md"""
## [Code Review Best Practices @ Palantir](https://blog.palantir.com/code-review-best-practices-19e02780015f)
### Purpose
- Does this code accomplish the author’s purpose? 
- **Ask questions.**

### Implementation
- **Think about how you would have solved the problem.**
- Do you see potential for useful abstractions?
- **Think like an adversary, but be nice about it.**
- Think about libraries or existing product code.
- Does the change follow standard patterns?
- **Does the change add dependencies**? 
- Think about your reading experience. 
- Does the code adhere to coding guidelines and code style? 
- Does this code have TODOs? 

### Maintainability
- **Read the tests**.
- Does this CR introduce the risk of breaking test code, staging stacks, or integrations tests?
- Leave feedback on code-level documentation, comments, and commit messages. 
- **Was the external documentation updated?**
"""

# ╔═╡ 9380c6be-90bc-47fa-98b5-92e0e8539110
md"""
## Prioritizing Code Review Feedback
![Handle conflicts different based on the severity. Credit: Alex Hill](https://miro.medium.com/max/560/1*zOvsiXkzqVJ7O8KalHhDZQ.jpeg)
- Credit:  [Alex Hill](https://betterprogramming.pub/13-code-review-standards-inspired-by-google-6b8f99f7fd67)
"""

# ╔═╡ b1fdca22-927d-43e0-ae4e-27ebe33527b2
md"""
## Peer Code Review Rubric = Reviewer's checklist
- Constructive suggestions for improving programming practices
- Specific, constructive suggestions for improving code readability/documentation 
- Specific, constructive suggestions for improving tests and/or assertions 
- Specific, constructive suggestions for improving code modularity/organization/maintainability 
- Specific, constructive suggestions for improving code efficiency 
- Finding any bugs  (bonus points?)
"""

# ╔═╡ 41c77442-6f81-41cc-bb92-c6736cce3ac8
md"""
## Old Questions
"""

# ╔═╡ 9292dbfc-85c7-4c8f-a645-735aa3521da4
md"""
**Q:**  Is it always best to insure a code passes all tests before anything else?

**A1:** Can anyone want share counter examples?

**A2:** Story of Kepler database
"""

# ╔═╡ 2bf6b015-333c-4fca-85e5-830aa7aa4edc
md"""
**Q:**  Even with a readme file and annotations, what are ways we can determine what the code does and whether the approach is correct or wrong?

Ask for clarification"""

# ╔═╡ c247aa92-2803-402d-b1cf-ebbf819c56ac
md"""
# Setup
"""

# ╔═╡ 0588f080-1da7-4df0-930b-582c065cab75
md"ToC on side $(@bind toc_aside CheckBox(;default=true))"

# ╔═╡ c94864a5-996d-432d-8e14-888991c8e119
TableOfContents(aside=toc_aside)

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
PlutoTeachingTools = "661c6b06-c737-4d37-b85c-46df65de6f69"
PlutoTest = "cb4044da-4d16-4ffa-a6a3-8cad7f73ebdc"
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"

[compat]
PlutoTeachingTools = "~0.2.13"
PlutoTest = "~0.2.2"
PlutoUI = "~0.7.52"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.9.2"
manifest_format = "2.0"
project_hash = "c3de1a3f87a3f5745b757a01c2f8e09e1040c30a"

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
git-tree-sha1 = "a1296f0fe01a4c3f9bf0dc2934efbf4416f5db31"
uuid = "da1fd8a2-8d9e-5ec2-8556-3022fb5608a2"
version = "1.3.4"

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
git-tree-sha1 = "7eb1686b4f04b82f96ed7a4ea5890a4f0c7a09f1"
uuid = "21216c6a-2e73-6563-6e65-726566657250"
version = "1.4.0"

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
git-tree-sha1 = "7364d5f608f3492a4352ab1d40b3916955dc6aec"
uuid = "295af30f-e4ad-537b-8983-00126c2a3abe"
version = "3.5.5"

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
# ╟─a876b548-3b0e-48d1-98bf-6bf005230e92
# ╟─b9baebea-2312-4c28-905c-b47ec3a26415
# ╟─373376f2-3557-42f5-bdeb-9ae70ed3d060
# ╟─3d678919-c197-4c9d-aed9-bf94dd431c4c
# ╟─b7412f06-287f-41b1-b0b4-0dec44f36a08
# ╟─7a13c062-b641-4894-9288-4a79c1005c49
# ╟─56ae82e4-9e28-438b-a6c8-d099b56af913
# ╟─533dbe7a-aae6-41dd-8737-2f995bb6c7f6
# ╟─d8fd8af3-a65d-4230-bb35-e1144e459520
# ╟─838815fa-5917-4347-bb3c-bf8300d2d942
# ╟─c8b93838-61ee-4c11-82de-e54a1d1b68af
# ╟─5a733830-5b36-4198-ae24-2d8b92fafbdd
# ╟─352ba7a9-5adb-48d1-a2f5-a0f738dd3ffe
# ╟─0969fdf8-9223-4e48-99f9-ef353d92fdb2
# ╟─76c7abf5-8eb5-4fc0-bca0-7c8098699fc1
# ╟─a541ae26-c160-4549-af71-c4473f0eefb7
# ╟─603442cb-fdd9-4551-b503-6af0dddc86d7
# ╟─d2cc4026-b2f0-4201-bf3b-c1615bbc9ab7
# ╟─fed62143-6d25-4d6a-927b-84f5d20fab0d
# ╟─2c809a46-3592-4a39-84e2-f7520c6e7bfe
# ╟─f965c656-6b7b-441d-8111-855ecfe79ca6
# ╟─f0fc9af7-737c-4c08-a772-1136be959a6d
# ╟─a4e4c54b-cda4-43af-b9ae-b1f5337f5fd0
# ╟─4a4c7d04-e9d3-4640-aaf6-cb62a759ee30
# ╟─d2f4bb2d-d222-4c61-9c63-a57bdfef1927
# ╟─53f5a5ca-201f-4aea-aa4c-fe82ae0249f2
# ╟─e7736d75-ca00-4b63-90cb-b70f4a4f1a48
# ╟─ac33892a-64ca-412b-865d-cefe2be1df15
# ╟─f508c1c8-945b-4b99-8985-5f10946b0239
# ╟─e2a60b81-1584-4d2d-8b08-9055d362cdfb
# ╟─840a2af4-4eab-4857-879d-a9c62b1e27a1
# ╟─6a0d5ba5-40d0-445d-a0fa-32fcfbad00c9
# ╟─9380c6be-90bc-47fa-98b5-92e0e8539110
# ╟─b1fdca22-927d-43e0-ae4e-27ebe33527b2
# ╟─41c77442-6f81-41cc-bb92-c6736cce3ac8
# ╟─9292dbfc-85c7-4c8f-a645-735aa3521da4
# ╟─2bf6b015-333c-4fca-85e5-830aa7aa4edc
# ╟─c247aa92-2803-402d-b1cf-ebbf819c56ac
# ╟─0588f080-1da7-4df0-930b-582c065cab75
# ╟─c94864a5-996d-432d-8e14-888991c8e119
# ╟─531f25b0-2d29-4db1-ab44-b927b6377945
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
