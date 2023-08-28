### A Pluto.jl notebook ###
# v0.19.26

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
	#using Unitful, UnitfulAstro
end

# ╔═╡ ff33e1c9-0189-4ae9-a5cb-7e55b60b5000
using LinearAlgebra

# ╔═╡ 0b431bf7-1f57-40c4-ad0c-012cbdbf9528
md"> Astro 528: High-Performance Scientific Computing for Astrophysics (Fall 2023)"

# ╔═╡ 959f2c12-287c-4648-a585-0c11d0db812d
md"""
# Week 2 Q&A
"""

# ╔═╡ a21b553b-eecb-4105-a0ed-d936e500788b
ChooseDisplayMode()

# ╔═╡ afe9b7c1-d031-4e1f-bd5b-5aeed30d7048
md"ToC on side $(@bind toc_aside CheckBox(;default=true))"

# ╔═╡ 080d3a94-161e-4482-9cf4-b82ffb98d0ed
TableOfContents(aside=toc_aside)

# ╔═╡ e42d4ec9-a51e-4f29-9741-d55cc8e09f98
md"""
# Administrative Announcements
- Remember to 
  + Submit Reading Questions via TopHat by 11am
  + Complete the third part of "Lab 3"
  + Make sure it's pushed to your repo on GitHub
```shell
git add goals.md
git commit -m "adding goals"
git push
```
"""

# ╔═╡ b6b281af-64a1-44b4-a9b6-ee0ba17f5c0b
md"""
# Your Questions
"""

# ╔═╡ 43283bfe-6736-447c-9519-633cf97e6473
md"""
## Terminoilogy
"""

# ╔═╡ 6f1964d8-0d7b-4a32-a0a6-eb53c37f76c7
blockquote(md"""
How are "a priori"/ "a posteriori" distinct from "preconditions"/ "postconditions"?
""")

# ╔═╡ 0de09109-9182-4679-9e5d-46bb0cf8880e
md"""
- Pre/Post-conditions refer to statements that should be true at beginning/end of your function.
- Here *a priori/posterior* was to distinguish how error estaimtes are made. 
"""

# ╔═╡ 48fb5bae-9227-49e9-aacd-006e8cb6d74f
md"""
## Conditions
"""

# ╔═╡ 70d0decb-de58-4b1a-b31c-2230a9447a9a
blockquote(md"""
How do you decide how many conditions to introduce into coding without, (1) it not being general enough to use for another project, (2) without going overboard?
""")

# ╔═╡ 1dfb44d6-f77c-4305-97cd-2d71bdd6ef14
md"""
What are you assuming when you write the function?  

Why not document that?
"""

# ╔═╡ 2e9f3b0d-d4ff-496b-9eb6-633deb4be4e6
md"""
## Error Estimates
"""

# ╔═╡ c42bf975-9c1a-4b9d-a85d-333eacc28d6e
blockquote(md"""
In Section 3.3 Accurate Discretization, they suggest a priori error estimate that the error is bounded by $C\cdot h^p$, where $p$ "only depends on the discretization strategy". What does "discretization strategy" mean?
""")

# ╔═╡ 9e9b227c-f74c-4734-af5b-99d087401155
md"""
### Integration via  Midpoint Rule
$$I = \int_a^b f(x)$$
$$I_{M,1} = f\left(\frac{a+b}{2}\right)(b-a)$$
$$I_{M,n} = \sum_{i=1}^n f\left(\frac{x_{i-1}+x_i}{2}\right)\Delta x,$$ 
where $x_i = a + i \Delta x$ and $\Delta x = (b-a)/n$

→ *A priori* Error bound:

$$\left|I - I_{M,n} \right| \le \frac{(b-a)^3}{24n^2} f''(c),$$
where $c = \mathrm{argmax}_c( f''(c) )$ 
"""

# ╔═╡ 21494e02-872f-48a1-ba01-3ac6c35c79a5
blockquote(md"""
How do we know when it is appropriate to obtain an "a priori" error estimate as opposed to an "a posteriori" estimate? What is a typical example of each in an astronomical context?
""")

# ╔═╡ 12fabb9c-5302-42d2-bf18-90d8f4e71fb1
md"""
- *A priori*:  See above
- *A posteriori*:  Comparing results from Adaptive mesh refinement
"""

# ╔═╡ 960357ef-3a9c-4397-b9cf-351925ee64e2
md"""
## Testing
"""

# ╔═╡ a07ab5af-23ca-4ecd-9304-3a1f14fe56bc
blockquote(md"""
When should we use "unit tests", "integration tests", or "regression tests"?
""")

# ╔═╡ ca249c00-db7e-416e-b511-644b4ef0de81
md"""
- Unit tests: Nearly always 
- Integration tests:  At a minimum, when you combine two codes/libraries that weren't intended to be combined.
- Regression tests:  When you have an accurate answer to compare to (and it's not computationally impractical)
"""

# ╔═╡ 4a3a7167-41f6-4b66-a833-4e62f1761446
md"""
## Agile Development
"""

# ╔═╡ 38bbdb0c-9ec2-46f0-985a-cb8b1929d515
blockquote(md"""
Can you give some examples of effective "agile development" methods?
""")

# ╔═╡ e257f61c-3eae-4f60-a7e6-c57d6000a435
md"""
Example **Agile development** process:
- Prepration:  Make a list of all the features you'd like ("product backlog")
- Sprint Planning:  Which features will be addressed next? ("sprint backlog")
  This can include tests and documentation, not just new features.
- Sprint:  Implement tasks from spring backlog.  Add any new issues to the product backlog.
- Review:  Present new features and get feedback from "customer".  
- Retrospective:  What worked?  What didn't work?  Aim to make next spring more effective.
"""

# ╔═╡ 06594327-f428-4a79-b338-4bbb28edc326
md"""
## Memory usage
"""

# ╔═╡ e124daaf-b878-442f-99f2-776b6995dc24
blockquote(md"""
When should we consider the amount of memory required for a code? How will we be aware that we are overloading the memory while running a code?
""")

# ╔═╡ 0df5450d-9241-47f4-aeb4-099855a5ce1f
@allocated sqrt(4.0)

# ╔═╡ ce934a3e-c772-4645-ba48-45aa30d02ed5
let 
	A = rand(3,4)
	B = (A'*A) + 1e-3 * diagm(ones(4)) 
	y = rand(4)
	@allocated x = B \ y
end

# ╔═╡ 22ca5cf2-4f80-4048-bcbb-ed5ebbe1e8c2
let 
	A = rand(3,4)
	B = (A'*A) + 1e-3 * diagm(ones(4)) 
	y = rand(4)
	@allocated x = B \ y
end

# ╔═╡ bde2fd7d-0a9e-4d0c-92be-d2151c411b34
md"""
Fore more detailed memory allocation trackig, there is: 
```
Profile.Allocs.@profile myfunction()
``` 
or 
```shell
> julia --track-allocation=user myprog.jl
```

"""

# ╔═╡ 2e128c72-c6b0-4487-ab48-3ceb6665f6ff
md"""
## Rapid fire question
"""

# ╔═╡ 6d494233-cdd9-4fb1-b824-0d3c0fe83847
blockquote(md"""
Are there instances where we should not follow Big O notation to create a more efficient algorithm?
""")

# ╔═╡ 5f583a12-3d83-4e91-8f8e-097765f76f58
md"""
Notation doesn't help you create an algorithm.  
It's typically used to help you choose between existing algorithms.
Make sure you're counting what matters (more on this later.)
"""

# ╔═╡ 1f31759c-47ff-4b2e-902e-bba94051940c
blockquote(md"""
What are some optimization methods for code limited by memory bandwidth?
""")

# ╔═╡ e6601dca-2f0d-4b90-a9e9-d627e0bdee81
md"""
See week 4.  
"""

# ╔═╡ d668c412-5cdb-4390-9a0b-c3ee48c0dd2b
md"# Git"

# ╔═╡ 14f49798-4eec-4e79-b263-5d63571154ab
md"""
## Conflict Resolution
- Computes line-by-line differences
- If no conflicts, then can merge automatically.
- If two commits to same line, then human merge needed.
- If git can't tell which lines are which, then human needed.
"""

# ╔═╡ 6ce78fcf-fe79-47a3-a93e-830c32dd500c
md"""
## Commons Git commands
- `git add filename`       # __Stage__ file to be commited to local repo
- `git commmit`            # __Commit__ staged files to local repo
  + `git commit -a`        # Stages and commmits all files in local repo and changed since last commit
  + `git commit -m "msg"`  # Sets commmit message on command line
- `git reset filename`     # Unstage a file (before you commmit it)  
- `git push`               # _Push_ commits to remote repo
- `git pull`               # _Pull_ commits from remote repo into local repo
"""

# ╔═╡ 0ae41bea-bb90-4417-a494-1ff6312ff090
md"""
##  What have I done?
- `git status`        # What files have been changed since last commit?  
- `git diff`          # What has changed in files that are not staged?
- `git diff --staged` # What is staged, but not yet commited?
- `git log`           # What recents commits could I revert to?
- `git diff hash`     # What changed since specified commit?
"""

# ╔═╡ 64f0bab8-6520-4745-bfc5-1a4f51083252
md"""
## Going back in time
- `git commit --amend`       # Ammend last commit (Do __not__ do this after you've pushed)
- `git checkout hash`        # Make local directory look like files as of previous commit
- `git reset hash filename`  # Revert file to state as of previous commit
"""

# ╔═╡ d34d03ed-48f3-4119-95a2-52fae45d1efc
md"""
## Git Resources
- [GitHub Guides](https://guides.github.com/)
- [DataCamp Tutorial](https://www.datacamp.com/courses/introduction-to-git-for-data-science)
- Let me know if you find one you like
"""

# ╔═╡ b0cfa2e7-7421-48d5-99fa-fbbf8b104238
md"""
## Other Questions
"""

# ╔═╡ 8759b216-cc38-42ed-b85c-04d508579c54
md"# Helper Code"

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
LinearAlgebra = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"
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

[[AbstractPlutoDingetjes]]
deps = ["Pkg"]
git-tree-sha1 = "91bd53c39b9cbfb5ef4b015e8b582d344532bd0a"
uuid = "6e696c72-6542-2067-7265-42206c756150"
version = "1.2.0"

[[ArgTools]]
uuid = "0dad84c5-d112-42e6-8d28-ef12dabb789f"
version = "1.1.1"

[[Artifacts]]
uuid = "56f22d72-fd6d-98f1-02f0-08ddc0907c33"

[[Base64]]
uuid = "2a0f44e3-6c83-55bd-87e4-b1978d98bd5f"

[[CodeTracking]]
deps = ["InteractiveUtils", "UUIDs"]
git-tree-sha1 = "a1296f0fe01a4c3f9bf0dc2934efbf4416f5db31"
uuid = "da1fd8a2-8d9e-5ec2-8556-3022fb5608a2"
version = "1.3.4"

[[ColorTypes]]
deps = ["FixedPointNumbers", "Random"]
git-tree-sha1 = "eb7f0f8307f71fac7c606984ea5fb2817275d6e4"
uuid = "3da002f7-5984-5a60-b8a6-cbb66c0b333f"
version = "0.11.4"

[[CompilerSupportLibraries_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "e66e0078-7015-5450-92f7-15fbd957f2ae"
version = "1.0.2+0"

[[Dates]]
deps = ["Printf"]
uuid = "ade2ca70-3891-5945-98fb-dc099432e06a"

[[Distributed]]
deps = ["Random", "Serialization", "Sockets"]
uuid = "8ba89e20-285c-5b6f-9357-94700520ee1b"

[[Downloads]]
deps = ["ArgTools", "FileWatching", "LibCURL", "NetworkOptions"]
uuid = "f43a241f-c20a-4ad4-852c-f6b1247861c6"
version = "1.6.0"

[[FileWatching]]
uuid = "7b1f6079-737a-58dc-b8bc-7a2ca5c1b5ee"

[[FixedPointNumbers]]
deps = ["Statistics"]
git-tree-sha1 = "335bfdceacc84c5cdf16aadc768aa5ddfc5383cc"
uuid = "53c48c17-4a7d-5ca2-90c5-79b7896eea93"
version = "0.8.4"

[[Formatting]]
deps = ["Printf"]
git-tree-sha1 = "8339d61043228fdd3eb658d86c926cb282ae72a8"
uuid = "59287772-0a20-5a39-b81b-1366585eb4c0"
version = "0.4.2"

[[Hyperscript]]
deps = ["Test"]
git-tree-sha1 = "8d511d5b81240fc8e6802386302675bdf47737b9"
uuid = "47d2ed2b-36de-50cf-bf87-49c2cf4b8b91"
version = "0.0.4"

[[HypertextLiteral]]
deps = ["Tricks"]
git-tree-sha1 = "c47c5fa4c5308f27ccaac35504858d8914e102f9"
uuid = "ac1192a8-f4b3-4bfe-ba22-af5b92cd3ab2"
version = "0.9.4"

[[IOCapture]]
deps = ["Logging", "Random"]
git-tree-sha1 = "d75853a0bdbfb1ac815478bacd89cd27b550ace6"
uuid = "b5f81e59-6552-4d32-b1f0-c071b021bf89"
version = "0.2.3"

[[InteractiveUtils]]
deps = ["Markdown"]
uuid = "b77e0a4c-d291-57a0-90e8-8db25a27a240"

[[JSON]]
deps = ["Dates", "Mmap", "Parsers", "Unicode"]
git-tree-sha1 = "31e996f0a15c7b280ba9f76636b3ff9e2ae58c9a"
uuid = "682c06a0-de6a-54ab-a142-c8b1cf79cde6"
version = "0.21.4"

[[JuliaInterpreter]]
deps = ["CodeTracking", "InteractiveUtils", "Random", "UUIDs"]
git-tree-sha1 = "81dc6aefcbe7421bd62cb6ca0e700779330acff8"
uuid = "aa1ae85d-cabe-5617-a682-6adf51b2e16a"
version = "0.9.25"

[[LaTeXStrings]]
git-tree-sha1 = "f2355693d6778a178ade15952b7ac47a4ff97996"
uuid = "b964fa9f-0449-5b57-a5c2-d3ea65f4040f"
version = "1.3.0"

[[Latexify]]
deps = ["Formatting", "InteractiveUtils", "LaTeXStrings", "MacroTools", "Markdown", "OrderedCollections", "Printf", "Requires"]
git-tree-sha1 = "f428ae552340899a935973270b8d98e5a31c49fe"
uuid = "23fbe1c1-3f47-55db-b15f-69d7ec21a316"
version = "0.16.1"

    [Latexify.extensions]
    DataFramesExt = "DataFrames"
    SymEngineExt = "SymEngine"

    [Latexify.weakdeps]
    DataFrames = "a93c6f00-e57d-5684-b7b6-d8193f3e46c0"
    SymEngine = "123dc426-2d89-5057-bbad-38513e3affd8"

[[LibCURL]]
deps = ["LibCURL_jll", "MozillaCACerts_jll"]
uuid = "b27032c2-a3e7-50c8-80cd-2d36dbcbfd21"
version = "0.6.3"

[[LibCURL_jll]]
deps = ["Artifacts", "LibSSH2_jll", "Libdl", "MbedTLS_jll", "Zlib_jll", "nghttp2_jll"]
uuid = "deac9b47-8bc7-5906-a0fe-35ac56dc84c0"
version = "7.84.0+0"

[[LibGit2]]
deps = ["Base64", "NetworkOptions", "Printf", "SHA"]
uuid = "76f85450-5226-5b5a-8eaa-529ad045b433"

[[LibSSH2_jll]]
deps = ["Artifacts", "Libdl", "MbedTLS_jll"]
uuid = "29816b5a-b9ab-546f-933c-edad1886dfa8"
version = "1.10.2+0"

[[Libdl]]
uuid = "8f399da3-3557-5675-b5ff-fb832c97cbdb"

[[LinearAlgebra]]
deps = ["Libdl", "OpenBLAS_jll", "libblastrampoline_jll"]
uuid = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"

[[Logging]]
uuid = "56ddb016-857b-54e1-b83d-db4d58db5568"

[[LoweredCodeUtils]]
deps = ["JuliaInterpreter"]
git-tree-sha1 = "60168780555f3e663c536500aa790b6368adc02a"
uuid = "6f1432cf-f94c-5a45-995e-cdbf5db27b0b"
version = "2.3.0"

[[MIMEs]]
git-tree-sha1 = "65f28ad4b594aebe22157d6fac869786a255b7eb"
uuid = "6c6e2e6c-3030-632d-7369-2d6c69616d65"
version = "0.1.4"

[[MacroTools]]
deps = ["Markdown", "Random"]
git-tree-sha1 = "9ee1618cbf5240e6d4e0371d6f24065083f60c48"
uuid = "1914dd2f-81c6-5fcd-8719-6d5c9610ff09"
version = "0.5.11"

[[Markdown]]
deps = ["Base64"]
uuid = "d6f4376e-aef5-505a-96c1-9c027394607a"

[[MbedTLS_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "c8ffd9c3-330d-5841-b78e-0817d7145fa1"
version = "2.28.2+0"

[[Mmap]]
uuid = "a63ad114-7e13-5084-954f-fe012c677804"

[[MozillaCACerts_jll]]
uuid = "14a3606d-f60d-562e-9121-12d972cd8159"
version = "2022.10.11"

[[NetworkOptions]]
uuid = "ca575930-c2e3-43a9-ace4-1e988b2c1908"
version = "1.2.0"

[[OpenBLAS_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "Libdl"]
uuid = "4536629a-c528-5b80-bd46-f80d51c5b363"
version = "0.3.21+4"

[[OrderedCollections]]
git-tree-sha1 = "2e73fe17cac3c62ad1aebe70d44c963c3cfdc3e3"
uuid = "bac558e1-5e72-5ebc-8fee-abe8a469f55d"
version = "1.6.2"

[[Parsers]]
deps = ["Dates", "PrecompileTools", "UUIDs"]
git-tree-sha1 = "716e24b21538abc91f6205fd1d8363f39b442851"
uuid = "69de0a69-1ddd-5017-9359-2bf0b02dc9f0"
version = "2.7.2"

[[Pkg]]
deps = ["Artifacts", "Dates", "Downloads", "FileWatching", "LibGit2", "Libdl", "Logging", "Markdown", "Printf", "REPL", "Random", "SHA", "Serialization", "TOML", "Tar", "UUIDs", "p7zip_jll"]
uuid = "44cfe95a-1eb2-52ea-b672-e2afdf69b78f"
version = "1.9.0"

[[PlutoHooks]]
deps = ["InteractiveUtils", "Markdown", "UUIDs"]
git-tree-sha1 = "072cdf20c9b0507fdd977d7d246d90030609674b"
uuid = "0ff47ea0-7a50-410d-8455-4348d5de0774"
version = "0.0.5"

[[PlutoLinks]]
deps = ["FileWatching", "InteractiveUtils", "Markdown", "PlutoHooks", "Revise", "UUIDs"]
git-tree-sha1 = "8f5fa7056e6dcfb23ac5211de38e6c03f6367794"
uuid = "0ff47ea0-7a50-410d-8455-4348d5de0420"
version = "0.1.6"

[[PlutoTeachingTools]]
deps = ["Downloads", "HypertextLiteral", "LaTeXStrings", "Latexify", "Markdown", "PlutoLinks", "PlutoUI", "Random"]
git-tree-sha1 = "542de5acb35585afcf202a6d3361b430bc1c3fbd"
uuid = "661c6b06-c737-4d37-b85c-46df65de6f69"
version = "0.2.13"

[[PlutoTest]]
deps = ["HypertextLiteral", "InteractiveUtils", "Markdown", "Test"]
git-tree-sha1 = "17aa9b81106e661cffa1c4c36c17ee1c50a86eda"
uuid = "cb4044da-4d16-4ffa-a6a3-8cad7f73ebdc"
version = "0.2.2"

[[PlutoUI]]
deps = ["AbstractPlutoDingetjes", "Base64", "ColorTypes", "Dates", "FixedPointNumbers", "Hyperscript", "HypertextLiteral", "IOCapture", "InteractiveUtils", "JSON", "Logging", "MIMEs", "Markdown", "Random", "Reexport", "URIs", "UUIDs"]
git-tree-sha1 = "e47cd150dbe0443c3a3651bc5b9cbd5576ab75b7"
uuid = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
version = "0.7.52"

[[PrecompileTools]]
deps = ["Preferences"]
git-tree-sha1 = "03b4c25b43cb84cee5c90aa9b5ea0a78fd848d2f"
uuid = "aea7be01-6a6a-4083-8856-8a6e6704d82a"
version = "1.2.0"

[[Preferences]]
deps = ["TOML"]
git-tree-sha1 = "7eb1686b4f04b82f96ed7a4ea5890a4f0c7a09f1"
uuid = "21216c6a-2e73-6563-6e65-726566657250"
version = "1.4.0"

[[Printf]]
deps = ["Unicode"]
uuid = "de0858da-6303-5e67-8744-51eddeeeb8d7"

[[REPL]]
deps = ["InteractiveUtils", "Markdown", "Sockets", "Unicode"]
uuid = "3fa0cd96-eef1-5676-8a61-b3b8758bbffb"

[[Random]]
deps = ["SHA", "Serialization"]
uuid = "9a3f8284-a2c9-5f02-9a11-845980a1fd5c"

[[Reexport]]
git-tree-sha1 = "45e428421666073eab6f2da5c9d310d99bb12f9b"
uuid = "189a3867-3050-52da-a836-e630ba90ab69"
version = "1.2.2"

[[Requires]]
deps = ["UUIDs"]
git-tree-sha1 = "838a3a4188e2ded87a4f9f184b4b0d78a1e91cb7"
uuid = "ae029012-a4dd-5104-9daa-d747884805df"
version = "1.3.0"

[[Revise]]
deps = ["CodeTracking", "Distributed", "FileWatching", "JuliaInterpreter", "LibGit2", "LoweredCodeUtils", "OrderedCollections", "Pkg", "REPL", "Requires", "UUIDs", "Unicode"]
git-tree-sha1 = "1e597b93700fa4045d7189afa7c004e0584ea548"
uuid = "295af30f-e4ad-537b-8983-00126c2a3abe"
version = "3.5.3"

[[SHA]]
uuid = "ea8e919c-243c-51af-8825-aaa63cd721ce"
version = "0.7.0"

[[Serialization]]
uuid = "9e88b42a-f829-5b0c-bbe9-9e923198166b"

[[Sockets]]
uuid = "6462fe0b-24de-5631-8697-dd941f90decc"

[[SparseArrays]]
deps = ["Libdl", "LinearAlgebra", "Random", "Serialization", "SuiteSparse_jll"]
uuid = "2f01184e-e22b-5df5-ae63-d93ebab69eaf"

[[Statistics]]
deps = ["LinearAlgebra", "SparseArrays"]
uuid = "10745b16-79ce-11e8-11f9-7d13ad32a3b2"
version = "1.9.0"

[[SuiteSparse_jll]]
deps = ["Artifacts", "Libdl", "Pkg", "libblastrampoline_jll"]
uuid = "bea87d4a-7f5b-5778-9afe-8cc45184846c"
version = "5.10.1+6"

[[TOML]]
deps = ["Dates"]
uuid = "fa267f1f-6049-4f14-aa54-33bafae1ed76"
version = "1.0.3"

[[Tar]]
deps = ["ArgTools", "SHA"]
uuid = "a4e569a6-e804-4fa4-b0f3-eef7a1d5b13e"
version = "1.10.0"

[[Test]]
deps = ["InteractiveUtils", "Logging", "Random", "Serialization"]
uuid = "8dfed614-e22c-5e08-85e1-65c5234f0b40"

[[Tricks]]
git-tree-sha1 = "aadb748be58b492045b4f56166b5188aa63ce549"
uuid = "410a4b4d-49e4-4fbc-ab6d-cb71b17b3775"
version = "0.1.7"

[[URIs]]
git-tree-sha1 = "b7a5e99f24892b6824a954199a45e9ffcc1c70f0"
uuid = "5c2747f8-b7ea-4ff2-ba2e-563bfd36b1d4"
version = "1.5.0"

[[UUIDs]]
deps = ["Random", "SHA"]
uuid = "cf7118a7-6976-5b1a-9a39-7adc72f591a4"

[[Unicode]]
uuid = "4ec0a83e-493e-50e2-b9ac-8f72acf5a8f5"

[[Zlib_jll]]
deps = ["Libdl"]
uuid = "83775a58-1f1d-513f-b197-d71354ab007a"
version = "1.2.13+0"

[[libblastrampoline_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850b90-86db-534c-a0d3-1478176c7d93"
version = "5.8.0+0"

[[nghttp2_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850ede-7688-5339-a07c-302acd2aaf8d"
version = "1.48.0+0"

[[p7zip_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "3f19e933-33d8-53b3-aaab-bd5110c3b7a0"
version = "17.4.0+0"
"""

# ╔═╡ Cell order:
# ╟─0b431bf7-1f57-40c4-ad0c-012cbdbf9528
# ╟─959f2c12-287c-4648-a585-0c11d0db812d
# ╟─a21b553b-eecb-4105-a0ed-d936e500788b
# ╟─afe9b7c1-d031-4e1f-bd5b-5aeed30d7048
# ╟─080d3a94-161e-4482-9cf4-b82ffb98d0ed
# ╟─e42d4ec9-a51e-4f29-9741-d55cc8e09f98
# ╟─b6b281af-64a1-44b4-a9b6-ee0ba17f5c0b
# ╟─43283bfe-6736-447c-9519-633cf97e6473
# ╟─6f1964d8-0d7b-4a32-a0a6-eb53c37f76c7
# ╟─0de09109-9182-4679-9e5d-46bb0cf8880e
# ╟─48fb5bae-9227-49e9-aacd-006e8cb6d74f
# ╟─70d0decb-de58-4b1a-b31c-2230a9447a9a
# ╟─1dfb44d6-f77c-4305-97cd-2d71bdd6ef14
# ╟─2e9f3b0d-d4ff-496b-9eb6-633deb4be4e6
# ╟─c42bf975-9c1a-4b9d-a85d-333eacc28d6e
# ╟─9e9b227c-f74c-4734-af5b-99d087401155
# ╟─21494e02-872f-48a1-ba01-3ac6c35c79a5
# ╟─12fabb9c-5302-42d2-bf18-90d8f4e71fb1
# ╟─960357ef-3a9c-4397-b9cf-351925ee64e2
# ╟─a07ab5af-23ca-4ecd-9304-3a1f14fe56bc
# ╟─ca249c00-db7e-416e-b511-644b4ef0de81
# ╟─4a3a7167-41f6-4b66-a833-4e62f1761446
# ╟─38bbdb0c-9ec2-46f0-985a-cb8b1929d515
# ╟─e257f61c-3eae-4f60-a7e6-c57d6000a435
# ╟─06594327-f428-4a79-b338-4bbb28edc326
# ╟─e124daaf-b878-442f-99f2-776b6995dc24
# ╠═0df5450d-9241-47f4-aeb4-099855a5ce1f
# ╠═ce934a3e-c772-4645-ba48-45aa30d02ed5
# ╠═22ca5cf2-4f80-4048-bcbb-ed5ebbe1e8c2
# ╟─bde2fd7d-0a9e-4d0c-92be-d2151c411b34
# ╟─2e128c72-c6b0-4487-ab48-3ceb6665f6ff
# ╟─6d494233-cdd9-4fb1-b824-0d3c0fe83847
# ╟─5f583a12-3d83-4e91-8f8e-097765f76f58
# ╟─1f31759c-47ff-4b2e-902e-bba94051940c
# ╟─e6601dca-2f0d-4b90-a9e9-d627e0bdee81
# ╟─d668c412-5cdb-4390-9a0b-c3ee48c0dd2b
# ╟─14f49798-4eec-4e79-b263-5d63571154ab
# ╟─6ce78fcf-fe79-47a3-a93e-830c32dd500c
# ╟─0ae41bea-bb90-4417-a494-1ff6312ff090
# ╟─64f0bab8-6520-4745-bfc5-1a4f51083252
# ╟─d34d03ed-48f3-4119-95a2-52fae45d1efc
# ╟─b0cfa2e7-7421-48d5-99fa-fbbf8b104238
# ╟─8759b216-cc38-42ed-b85c-04d508579c54
# ╠═1c640715-9bef-4935-9dce-f94ff2a3740b
# ╠═ff33e1c9-0189-4ae9-a5cb-7e55b60b5000
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
