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

# ╔═╡ 1ce7ef5b-c213-47ba-ac96-9622b62cda61
md"# Questions about Lab"

# ╔═╡ f69f32fc-f759-4567-9c1c-37676eaf713d
md"# Old Questions"

# ╔═╡ 8759b216-cc38-42ed-b85c-04d508579c54
md"# Helper Code"

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
PlutoTeachingTools = "661c6b06-c737-4d37-b85c-46df65de6f69"
PlutoTest = "cb4044da-4d16-4ffa-a6a3-8cad7f73ebdc"
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"

[compat]
PlutoTeachingTools = "~0.1.3"
PlutoTest = "~0.1.0"
PlutoUI = "~0.7.9"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

[[Base64]]
uuid = "2a0f44e3-6c83-55bd-87e4-b1978d98bd5f"

[[Dates]]
deps = ["Printf"]
uuid = "ade2ca70-3891-5945-98fb-dc099432e06a"

[[HypertextLiteral]]
git-tree-sha1 = "1e3ccdc7a6f7b577623028e0095479f4727d8ec1"
uuid = "ac1192a8-f4b3-4bfe-ba22-af5b92cd3ab2"
version = "0.8.0"

[[InteractiveUtils]]
deps = ["Markdown"]
uuid = "b77e0a4c-d291-57a0-90e8-8db25a27a240"

[[JSON]]
deps = ["Dates", "Mmap", "Parsers", "Unicode"]
git-tree-sha1 = "81690084b6198a2e1da36fcfda16eeca9f9f24e4"
uuid = "682c06a0-de6a-54ab-a142-c8b1cf79cde6"
version = "0.21.1"

[[LaTeXStrings]]
git-tree-sha1 = "c7f1c695e06c01b95a67f0cd1d34994f3e7db104"
uuid = "b964fa9f-0449-5b57-a5c2-d3ea65f4040f"
version = "1.2.1"

[[Logging]]
uuid = "56ddb016-857b-54e1-b83d-db4d58db5568"

[[Markdown]]
deps = ["Base64"]
uuid = "d6f4376e-aef5-505a-96c1-9c027394607a"

[[Mmap]]
uuid = "a63ad114-7e13-5084-954f-fe012c677804"

[[Parsers]]
deps = ["Dates"]
git-tree-sha1 = "94bf17e83a0e4b20c8d77f6af8ffe8cc3b386c0a"
uuid = "69de0a69-1ddd-5017-9359-2bf0b02dc9f0"
version = "1.1.1"

[[PlutoTeachingTools]]
deps = ["LaTeXStrings", "Markdown", "PlutoUI", "Random"]
git-tree-sha1 = "265980831960aabe7e1f5ae47c898a8459588ee7"
uuid = "661c6b06-c737-4d37-b85c-46df65de6f69"
version = "0.1.3"

[[PlutoTest]]
deps = ["HypertextLiteral", "InteractiveUtils", "Markdown", "Test"]
git-tree-sha1 = "3479836b31a31c29a7bac1f09d95f9c843ce1ade"
uuid = "cb4044da-4d16-4ffa-a6a3-8cad7f73ebdc"
version = "0.1.0"

[[PlutoUI]]
deps = ["Base64", "Dates", "InteractiveUtils", "JSON", "Logging", "Markdown", "Random", "Reexport", "Suppressor"]
git-tree-sha1 = "44e225d5837e2a2345e69a1d1e01ac2443ff9fcb"
uuid = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
version = "0.7.9"

[[Printf]]
deps = ["Unicode"]
uuid = "de0858da-6303-5e67-8744-51eddeeeb8d7"

[[Random]]
deps = ["SHA", "Serialization"]
uuid = "9a3f8284-a2c9-5f02-9a11-845980a1fd5c"

[[Reexport]]
git-tree-sha1 = "5f6c21241f0f655da3952fd60aa18477cf96c220"
uuid = "189a3867-3050-52da-a836-e630ba90ab69"
version = "1.1.0"

[[SHA]]
uuid = "ea8e919c-243c-51af-8825-aaa63cd721ce"
version = "0.7.0"

[[Serialization]]
uuid = "9e88b42a-f829-5b0c-bbe9-9e923198166b"

[[Suppressor]]
git-tree-sha1 = "a819d77f31f83e5792a76081eee1ea6342ab8787"
uuid = "fd094767-a336-5f1f-9728-57cf17d0bbfb"
version = "0.2.0"

[[Test]]
deps = ["InteractiveUtils", "Logging", "Random", "Serialization"]
uuid = "8dfed614-e22c-5e08-85e1-65c5234f0b40"

[[Unicode]]
uuid = "4ec0a83e-493e-50e2-b9ac-8f72acf5a8f5"
"""

# ╔═╡ Cell order:
# ╟─0b431bf7-1f57-40c4-ad0c-012cbdbf9528
# ╟─959f2c12-287c-4648-a585-0c11d0db812d
# ╟─a21b553b-eecb-4105-a0ed-d936e500788b
# ╟─afe9b7c1-d031-4e1f-bd5b-5aeed30d7048
# ╟─080d3a94-161e-4482-9cf4-b82ffb98d0ed
# ╟─e42d4ec9-a51e-4f29-9741-d55cc8e09f98
# ╟─b6b281af-64a1-44b4-a9b6-ee0ba17f5c0b
# ╟─d668c412-5cdb-4390-9a0b-c3ee48c0dd2b
# ╟─14f49798-4eec-4e79-b263-5d63571154ab
# ╟─6ce78fcf-fe79-47a3-a93e-830c32dd500c
# ╟─0ae41bea-bb90-4417-a494-1ff6312ff090
# ╟─64f0bab8-6520-4745-bfc5-1a4f51083252
# ╟─d34d03ed-48f3-4119-95a2-52fae45d1efc
# ╟─b0cfa2e7-7421-48d5-99fa-fbbf8b104238
# ╟─1ce7ef5b-c213-47ba-ac96-9622b62cda61
# ╟─f69f32fc-f759-4567-9c1c-37676eaf713d
# ╟─8759b216-cc38-42ed-b85c-04d508579c54
# ╠═1c640715-9bef-4935-9dce-f94ff2a3740b
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
