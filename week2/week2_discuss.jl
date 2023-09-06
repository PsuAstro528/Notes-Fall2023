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
	using Unitful, UnitfulAstro
	using StaticArrays, FillArrays, LazyArrays, StructArrays, ElasticArrays
	using BenchmarkTools
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
# Week 2 Discussion Topics
- Priorities for Scientific Computing
- Unit Testing
- Documentation
- Generic Code
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

# ╔═╡ 4ea1e5d1-36f8-41b8-88ec-23dc933b12c8
md"### Do you agree?"

# ╔═╡ 01ebcac9-daed-4dba-90a7-4ee02dc4221d
md"""
# Testing
"""

# ╔═╡ 57af4c4c-21ac-43a9-8d17-00f8fdb903f8
blockquote(md"""
When should we use "unit tests", "integration tests", or "regression tests"?
""")

# ╔═╡ 62b09b80-4984-4d49-82bb-6fea97272966
md"""
- Unit tests: Nearly always 
- Integration tests:  At a minimum, when you combine two codes/libraries that weren't intended to be combined.
- Regression tests:  When you have an accurate answer to compare to (and it's not computationally impractical)
"""

# ╔═╡ 9cdcafc0-520c-48e6-9b14-3cedbb532d49
md"""
# Beyond Unit Testing
## What if functions aren't being connected correctly?
### Regression testing 
   Comparing results of two methods
   - Great if you have two methods for doing the same calculation
   - Can be complicated if we expect some small differences.  
### End-to-end testing 
  (E.g., analyzing simulated data)
  - Great when possible
  - Can be time consuming 
  - Harder to use effectively when we're making changes that should affect results (a little?).
"""

# ╔═╡ 5f245e5e-3df1-4d1c-8bf9-127aa1bb0587
md"""
## What if some code isn't being tested?

- Coverage checking
```shell
julia --project=DIR --code-coverage=user my_program.jl
```

- CI services like [Coveralls.io](https://coveralls.io/) or [Codecov.io](https://Codecov.io)
- [Coverage.jl](https://github.com/JuliaCI/Coverage.jl) to make it easy

"""

# ╔═╡ af90a2ec-c6cf-4603-a4ee-b22ea1ce85e9
md"""Questions for the class:
- How does one write tests for scientific software when the expected answer is unknown?
- What would unit tests miss?

"""

# ╔═╡ 65f1571b-1de2-475a-ac15-51961b57a440
md"""
# Documentation
"""

# ╔═╡ 7b51032e-ec09-4d08-94b8-f359c7093520
md"""
## Conditions
"""

# ╔═╡ 0663361f-85d4-46e5-b306-7a4efbeb5888
blockquote(md"""
How do you decide how many conditions to introduce into coding without, (1) it not being general enough to use for another project, (2) without going overboard?
""")

# ╔═╡ d09e35c4-3ad1-41a0-b00b-048d2ba9cfd8
md"""
What are you assuming when you write the function?  

It's usually a good idea to document that. 
"""

# ╔═╡ 4d552810-41ca-4db7-b3a2-67426d542b7b
md"""
## How much to "document" code?
"""


# ╔═╡ 33a78999-2e97-42ae-b563-6ec492e48bb4
blockquote(md"""I don't want to spend time solving a problem that isn't even a problem.  Would it make more sense to just focus on commenting and "proper documentation"?  """)


# ╔═╡ 0d6f4e52-7d0d-49fa-98f9-bbdf04fc8643
md"""
- Including a condition both documents and enforces that the assumptions are met.
- Interfaces between functions are known pain points where bugs are more likely to appear, so it makes sense to be extra careful around them.  This is particularly important when conneting functions that were written for different purposes, by different people, and/or at different times, since each of those makes it less likely that the assumptions will be identical. 
"""

# ╔═╡ 9e9d5b7a-4768-47ba-985b-795fec6315b4
"""
   `my_function_to_add_two_numbers(a,b)`

Inputs:
- `a`:  Any type
- `b`:  Any type
Outputs:
- results of + function applied to arguements a and b

# Examples

```jldoctest
julia> my_function_to_add_two_numbers(1,2)
# output
3
```
"""
function my_function_to_add_two_numbers(a,b)
	a+b # add a and b
end

# ╔═╡ 0843af3e-23b5-4d00-b2b5-4e514d01a842
md"*versus*"

# ╔═╡ d08ba78a-a5bd-4ce1-bd70-879a3f9fa044
"Customized add two numbers"
function my_add(a,b)
	a+b 
end

# ╔═╡ ae5589ab-eb85-4240-9cd5-c1ed2663106d
md"""
## Generic vs problem-specific code
How should we balance writing code that is general purpose (i.e. flexible) vs. writing code that is problem specific and then adapting it later for new problems
?

It is not always clear (or possible to know) what we need our programs to do next.
"""

# ╔═╡ 17808a9d-e29a-427f-819e-aaecee522c59
md"""
###  Finding a Balance
Inevitably, I find myself having to re-write code on many occasions in order to 
accommodate new analyses.

If I try to write all-purpose functions from the get-go, I get caught up in trying to figure out what I might need my code to do in the future!
"""

# ╔═╡ 74a92bc8-f145-4ae4-a42c-017ff22f5b37
md"""
# Opportunities for Generic Code
Almost all the code I write is designed to accomplish a specific task.
"""

# ╔═╡ 6643d9fb-6c9e-440b-9658-f7237cc67743
blockquote(md"""
What are some ways to make your program more flexible when you're only writing it for one specific purpose at the time?
""")

# ╔═╡ b6c96f10-6587-47bc-87fb-a720cdc4ac4d
hint(md"""
#### Common ways to generlize code:
- Type of numbers
- Element type of collections
- Dimensionality of arrays
- Generic collections
""")

# ╔═╡ 6b6dae67-43de-461a-bb69-94e4950cd5e2
md"## Numbers as Function Arguements"

# ╔═╡ c6944314-4a09-49fe-94ce-6da00974e216
function geometric_mean_scalar_specific(a::Float64, b::Float64)
	sqrt(a*b)
end

# ╔═╡ 6b6ec0f0-510d-46ea-b6f6-f793c2c39823
md"__versus__"

# ╔═╡ 106a380e-6eef-4a14-969f-97abe5cf5023
function geometric_mean_scalar_generic(a::Real, b::Real)
	sqrt(a*b)
end

# ╔═╡ 582581cc-5155-4903-af2a-a03314cae096
md"## Collections as Function Arguements"

# ╔═╡ 8092a7ea-8845-420c-90d7-4dcd1adb6513
function specific(a::Vector{Float64}, b::Vector{Float64})
	sqrt.(a.*b)
end

# ╔═╡ dc434a7b-4479-4825-8647-9fce917be1ee
md"#### How could we make this more generic?"

# ╔═╡ 7a10b691-5208-4084-a9e1-531487cb4f0f
md"## Generalizing collection element type"

# ╔═╡ 00851d59-30fe-4957-afd4-8f317f3baf7f
@test_broken specific([1,2,3],[4,5,6])

# ╔═╡ 35d941d4-bf6d-4258-8eca-56b5b23ee00c
function less_specific(a::Vector{T}, b::Vector{T}) where { T<: Real }
	sqrt.(a.*b)
end

# ╔═╡ a614df3d-ba22-432f-8e35-0c6988565d82
@test_nowarn less_specific([1,2,3],[4,5,6])

# ╔═╡ 11b2b539-33eb-406c-b20b-a6aacb51e40a
md"### Allow different element types"

# ╔═╡ b17f5c2f-beff-45c5-98e8-abf2035581af
@test_broken less_specific([1.0,2.0,3.0],[4,5,6])

# ╔═╡ cc5c9c0b-df33-4f52-ac18-e23a965b53a2
function even_less_specific(a::Vector{T1}, b::Vector{T2}) where { T1<: Real, T2<: Real }
	sqrt.(a.*b)
end

# ╔═╡ d162188e-3bff-4698-8d64-96fdb0fb157d
@test_nowarn even_less_specific([1.0,2.0,3.0],[4,5,6])

# ╔═╡ 2551edba-5892-42de-81d9-c985addfa3db
protip(md"""
It's common for Julia developers to drop the explicit `where` statement by using the following syntax that is equivalent to `even_less_specific`.
```julia
function shorthand_of_even_less_specific(a::Vector{<:Real}, b::Vector{<:Real}) 
	sqrt.(a.*b)
end
```
""","Want to see a common shorthand?")

# ╔═╡ 87caa940-4183-4aff-879e-65096c851391
md"### Generalize Dimensionality of Arrays"

# ╔═╡ 9b9bb8cb-b3a9-475a-9c2c-55096a45972c
one_by_three_matrix = [ 1.0 2.0 3.0]

# ╔═╡ b153bbe1-53f6-4d13-b7ff-bd134657edff
@test_broken even_less_specific(one_by_three_matrix,one_by_three_matrix)

# ╔═╡ b1e54329-d979-4b1a-89da-e9dd1d7b0bd0
function pretty_generic(a::Array{T1}, b::Array{T2}) where { T1<:Real, T2<:Real }
	sqrt.(a.*b)
end

# ╔═╡ de530f98-cc35-44a9-ae99-62b60c7850ea
@test_nowarn pretty_generic(one_by_three_matrix,one_by_three_matrix)

# ╔═╡ 5016b36c-5d78-4024-9fce-fe9ba976b887
md"""
## Allow types that "behave like" real numbers 
"""

# ╔═╡ ca66b435-9948-4137-8398-d325dd30ba1b
md"""
### Units
"""

# ╔═╡ 9dcd9dd5-ef6b-486a-a359-ec4a126ebd9e
function generic(a::Array{T1}, b::Array{T2}) where { T1<:Number, T2<:Number }
	sqrt.(a.*b)
end

# ╔═╡ 3360c93e-c246-451d-9e23-8eb6048f8c3e
begin 
	one_kg = 1u"kg"
	one_g = 1u"g"
end

# ╔═╡ 15242b15-898e-435b-acf2-b8a61b079e9b
one_kg.val

# ╔═╡ 46bb29cb-bda9-4224-be94-b531b0ef8eb1
unit(one_kg)

# ╔═╡ ceb0b7d6-29f9-468b-bcb0-7f2f1c1067f8
@test one_kg != one_g

# ╔═╡ 426f28b4-d12a-4ff7-b452-b84ca3af5416
thousand_g = 1000u"g"  

# ╔═╡ 878d767d-6435-4dda-b289-2d7db70308d0
@test one_kg == thousand_g

# ╔═╡ 27c6262b-20fe-4767-9a97-0ee1d186a5be
@test one_kg.val != thousand_g.val

# ╔═╡ 92f56061-025a-4fe4-ae00-743560bdb076
uconvert(u"g",one_kg)

# ╔═╡ a81c5427-91db-429a-860f-fc4b85248f2b
md"""
#### UnitfulAstro.jl
"""

# ╔═╡ 7ccd226c-2b44-4106-857d-f39e68896014
begin
	masses = [ 1u"Msun", 0.8u"Msun", 1.2u"Msun" ] 
	radii = [ 1u"Rsun", 0.8u"Rsun", 1.2u"Rsun" ] 
	sqrt_densities = generic(masses,1.0 ./ radii.^3 )
end

# ╔═╡ bc0420c8-afd4-45c3-accf-493aca325395
md"""
#### Types supporting automatic differentiation
We'll discuss more in a few weeks.
"""

# ╔═╡ e82ae23e-eee2-434f-9e35-40333d8c94c4
md"""
## Allow Collections that "behave like" Arrays
"""

# ╔═╡ d8cfbd63-df7c-49df-b0f7-73cf1f9229af
function even_more_generic(a::AbstractArray{T1,N}, b::AbstractArray{T2,N}) where { T1<:Real, T2<:Real, N }
	sqrt.(a.*b)
end

# ╔═╡ 06a943eb-7133-48c0-8a66-5f28aa0c18f0
begin
	y = rand(2,5)
	x = rand(2,10,5)
	(;y,x)
end

# ╔═╡ c61db014-48a4-4093-8477-673f2600fb48
md"### View of an aray"

# ╔═╡ 1ac0e55e-d118-47cc-8fe8-0e3fb99a3284
view(x,:,1,:)

# ╔═╡ ec462d8d-63a0-4618-8134-8c26936b86e8
even_more_generic( view(x,:,1,:), y)

# ╔═╡ 07fe9bcf-ef89-4549-8be9-ec1cbc9d18dc
md"""
### [StaticArrays.jl](https://github.com/JuliaArrays/StaticArrays.jl)
Reduce cost of allocating small arrays (if size & element type are known at compile time).
"""

# ╔═╡ 77a79bd2-00b4-4de4-a013-813847b22d12
@allocated SA[1.0, 2, 3]

# ╔═╡ f890051a-82d0-47f4-99f8-dc2d01d3e81e
@allocated [1.0, 2, 3]

# ╔═╡ 0a28203f-cf12-41a6-9231-ed9eb3887f3d
@benchmark [1.0, 2, 3]

# ╔═╡ 413aa78c-f4de-4d56-b09c-46a3e4bc06b1
@benchmark SA[1.0, 2, 3]

# ╔═╡ 75a59648-cd4c-4671-ba5a-b267dda2bb59
md"""
### More useful collections that help reduce memory allocations
- [FillArrays.jl](https://github.com/JuliaArrays/FillArrays.jl): For large arrays with repeated values
- [LazyArrays.jl](https://github.com/JuliaArrays/LazyArrays.jl): For lazy evaluation of array operations
- [StructArrays.jl](https://github.com/JuliaArrays/StructArrays.jl): Looks like an array of structs, but implemented as struct of arrays under the hood
- [ElasticArrays.jl](https://github.com/JuliaArrays/ElasticArrays.jl): More efficient if will be changing size (of outermost dimension) frequently
- Several more at [JuliaArrays](https://github.com/JuliaArrays/)
"""

# ╔═╡ 17e21b48-d98a-41f8-b464-f37631ef3880
md"""
#### FillArrays.jl
"""

# ╔═╡ 9af197c9-0395-43c6-a5e6-bcd86a106015
ones(5)

# ╔═╡ b54c9df1-c801-467c-91ff-28bc2deec61b
@allocated ones(10_000)

# ╔═╡ 7f6f6644-b768-4196-8fba-0bacb2fcd65a
@allocated Ones(10_000)

# ╔═╡ 0ad19b3a-1daf-4fa5-a645-7185ce0aeed9
md"""
#### LazyArrays.jl
"""

# ╔═╡ f8f1d71e-a2d2-4694-8b41-d3f36a46386a
let
	z = Zeros(10_000)
	o = Ones(10_000)	
	@benchmark ApplyArray(hcat, $z, $o )
end

# ╔═╡ 9248cedd-3739-4f86-8b4b-8266dfb14068
let
	z = zeros(10_000)
	o = ones(10_000)	
	@benchmark hcat($z,$o)
end

# ╔═╡ 83aa16bc-fade-4842-914e-98277a80651a
md"""
#### Kronecker product
(Or any operation applied to all pairs)
"""

# ╔═╡ 3afc7835-9fb4-4d52-b532-b49c90679dcf
let
	A = [1, 2, 3, 4, 5]'
	B = [100, 200, 300]
	kron(A,B)
end

# ╔═╡ c2a41966-d055-469d-8811-74c2a7e5d5cf
begin
	A = [i for i in 1:100]'
	B = [100*j for j in 1:100]
	@benchmark kron($A,$B)
end

# ╔═╡ ce55375b-30bf-4de2-9b98-16f84384ecff
begin
	@benchmark ApplyArray(kron, $A,$B)
end

# ╔═╡ c47b75eb-12c5-4f93-b5d1-6f382233206d
md"#### ElasticArrays.jl"

# ╔═╡ 2eba0e92-8f38-4326-abb8-dfc67b799ca3
@benchmark begin
	A_std = Array{Float64}(undef, 5, 0)
	for i in 1:1000
	    A_std = hcat(A_std, rand(5) )
	end
end

# ╔═╡ 908caef3-7f25-4bd1-8a36-d8680e1976ef
@benchmark begin
	A_elastic = ElasticArray{Float64}(undef, 5, 0)
	for i in 1:1000
	    append!(A_elastic, rand(5) )
	end
end

# ╔═╡ 890f8813-b516-4431-a51a-ea03b723a4c7
md"""
### StructArrays.jl
"""

# ╔═╡ 859f5ece-ba3d-49d5-a645-dca6cb2203b1
Complex(0,1)

# ╔═╡ 3cd28d62-10ec-44c0-809f-d581121ef5f8
fieldnames(Complex)

# ╔═╡ d8ee4d99-41e6-435e-98c4-a320eaf8aecf
begin
	re_data = rand(4)
	im_data = rand(4)
end;

# ╔═╡ c8e6a8c1-c02d-48a7-bc29-7f77ba863d4e
begin
	array_of_structs = [Complex(re_data[i], im_data[i]) for i in 1:length(re_data) ]
end

# ╔═╡ e129de08-a81f-43e2-96d4-88f86a585b99
typeof(array_of_structs)

# ╔═╡ 519f4699-13e7-469b-9077-96d80f4a9c2a
begin
	struct_of_arrays = StructArray{Complex}((re_data, im_data))
end;

# ╔═╡ c3de13e5-d31d-4e2e-9756-2f08f54ac494
typeof(struct_of_arrays)

# ╔═╡ f3a8ee8a-9a9e-4a79-99d1-7644354a175c
struct_of_arrays[3]

# ╔═╡ ad3bd3c6-4412-425b-9488-3d402f9c151c
@test array_of_structs[3] == struct_of_arrays[3]

# ╔═╡ 4b53181c-1f3c-4ee0-adaf-d96a5253f40e
md"# Wait... Why specify any types?"

# ╔═╡ 7d394fd8-d6d7-46ac-9ed0-37ebeb1a9c30
function very_generic_but_dangerous(a, b)
	sqrt.(a.*b)
end

# ╔═╡ 66e99211-b6d6-4e0e-ad79-aa572fa31a71
view(x,:,1,:)

# ╔═╡ 8eb629ff-be97-4e69-8fb4-9fd83272586d
y

# ╔═╡ 6e1730c9-2f2c-4745-b9bf-effdc58d16ed
very_generic_but_dangerous( view(x,:,1,:), y)

# ╔═╡ 9e6ce544-4d7d-4932-aec6-850585da8e7e
hint(
	md"""
	## What if argument's don't make sense?
	```
	very_generic_but_dangerous(x,"Hello")
	```
	""")

# ╔═╡ 3095d63d-0589-4286-b7ee-e81636d0712d
md"__versus__"

# ╔═╡ 3fcc7d66-edbc-4322-ac1a-8314fd2a87f4
md"Want to see what the error messages would look like? $(@bind want_to_see_error_msg CheckBox())"

# ╔═╡ be3a14da-20cd-4e50-b279-1fe1ad273175
if want_to_see_error_msg
	very_generic_but_dangerous(x,"Hello")
end

# ╔═╡ 01f99268-5ee7-4690-bb5c-757e3457b523
if want_to_see_error_msg
	even_more_generic(x,"Hello")
end

# ╔═╡ 6f6efd10-616c-4342-b2ec-c3793553a789
md"## Even scarier"

# ╔═╡ e11f688f-ba3c-4958-9e63-334e1765e175
if want_to_see_error_msg
	very_generic_but_dangerous(x,y)
end

# ╔═╡ fe733165-5922-44fc-bfa3-aebe2eaba344
md"__versus__"

# ╔═╡ 453f52fa-ce24-4b7d-81c9-ce46361172a4
if want_to_see_error_msg
	even_more_generic(x,y)
end

# ╔═╡ b6b281af-64a1-44b4-a9b6-ee0ba17f5c0b
md"""
# Your Questions
"""

# ╔═╡ 8759b216-cc38-42ed-b85c-04d508579c54
md"# Helper Code"

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
BenchmarkTools = "6e4b80f9-dd63-53aa-95a3-0cdb28fa8baf"
ElasticArrays = "fdbdab4c-e67f-52f5-8c3f-e7b388dad3d4"
FillArrays = "1a297f60-69ca-5386-bcde-b61e274b549b"
LazyArrays = "5078a376-72f3-5289-bfd5-ec5146d43c02"
PlutoTeachingTools = "661c6b06-c737-4d37-b85c-46df65de6f69"
PlutoTest = "cb4044da-4d16-4ffa-a6a3-8cad7f73ebdc"
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
StaticArrays = "90137ffa-7385-5640-81b9-e52037218182"
StructArrays = "09ab397b-f2b6-538f-b94a-2f83cf4a842a"
Unitful = "1986cc42-f94f-5a68-af5c-568840ba703d"
UnitfulAstro = "6112ee07-acf9-5e0f-b108-d242c714bf9f"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.9.2"
manifest_format = "2.0"
project_hash = "6979a96f2a7ac8158860d43142bedb17dc8e2335"

[[deps.AbstractPlutoDingetjes]]
deps = ["Pkg"]
git-tree-sha1 = "91bd53c39b9cbfb5ef4b015e8b582d344532bd0a"
uuid = "6e696c72-6542-2067-7265-42206c756150"
version = "1.2.0"

[[deps.Adapt]]
deps = ["LinearAlgebra", "Requires"]
git-tree-sha1 = "76289dc51920fdc6e0013c872ba9551d54961c24"
uuid = "79e6a3ab-5dfb-504d-930d-738a2a938a0e"
version = "3.6.2"
weakdeps = ["StaticArrays"]

    [deps.Adapt.extensions]
    AdaptStaticArraysExt = "StaticArrays"

[[deps.ArgTools]]
uuid = "0dad84c5-d112-42e6-8d28-ef12dabb789f"
version = "1.1.1"

[[deps.ArrayLayouts]]
deps = ["FillArrays", "LinearAlgebra", "SparseArrays"]
git-tree-sha1 = "6189f7819e6345bcc097331c7db571f2f211364f"
uuid = "4c555306-a7a7-4459-81d9-ec55ddd5c99a"
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

[[deps.Distributed]]
deps = ["Random", "Serialization", "Sockets"]
uuid = "8ba89e20-285c-5b6f-9357-94700520ee1b"

[[deps.Downloads]]
deps = ["ArgTools", "FileWatching", "LibCURL", "NetworkOptions"]
uuid = "f43a241f-c20a-4ad4-852c-f6b1247861c6"
version = "1.6.0"

[[deps.ElasticArrays]]
deps = ["Adapt"]
git-tree-sha1 = "e1c40d78de68e9a2be565f0202693a158ec9ad85"
uuid = "fdbdab4c-e67f-52f5-8c3f-e7b388dad3d4"
version = "1.2.11"

[[deps.FileWatching]]
uuid = "7b1f6079-737a-58dc-b8bc-7a2ca5c1b5ee"

[[deps.FillArrays]]
deps = ["LinearAlgebra", "Random", "SparseArrays", "Statistics"]
git-tree-sha1 = "f372472e8672b1d993e93dada09e23139b509f9e"
uuid = "1a297f60-69ca-5386-bcde-b61e274b549b"
version = "1.5.0"

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

[[deps.GPUArraysCore]]
deps = ["Adapt"]
git-tree-sha1 = "2d6ca471a6c7b536127afccfa7564b5b39227fe0"
uuid = "46192b85-c4d5-4398-a991-12ede77f4527"
version = "0.1.5"

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

[[deps.IteratorInterfaceExtensions]]
git-tree-sha1 = "a3f24677c21f5bbe9d2a714f95dcd58337fb2856"
uuid = "82899510-4779-5014-852e-03e436cf321d"
version = "1.0.0"

[[deps.JSON]]
deps = ["Dates", "Mmap", "Parsers", "Unicode"]
git-tree-sha1 = "31e996f0a15c7b280ba9f76636b3ff9e2ae58c9a"
uuid = "682c06a0-de6a-54ab-a142-c8b1cf79cde6"
version = "0.21.4"

[[deps.JuliaInterpreter]]
deps = ["CodeTracking", "InteractiveUtils", "Random", "UUIDs"]
git-tree-sha1 = "e8ab063deed72e14666f9d8af17bd5f9eab04392"
uuid = "aa1ae85d-cabe-5617-a682-6adf51b2e16a"
version = "0.9.24"

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

[[deps.LazyArrays]]
deps = ["ArrayLayouts", "FillArrays", "LinearAlgebra", "MacroTools", "MatrixFactorizations", "SparseArrays"]
git-tree-sha1 = "c9af92d0be60963babfd762e57376bb1bde01bce"
uuid = "5078a376-72f3-5289-bfd5-ec5146d43c02"
version = "1.5.2"
weakdeps = ["StaticArrays"]

    [deps.LazyArrays.extensions]
    LazyArraysStaticArraysExt = "StaticArrays"

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

[[deps.MatrixFactorizations]]
deps = ["ArrayLayouts", "LinearAlgebra", "Printf", "Random"]
git-tree-sha1 = "951c7f2d07f1cbdb5cf279e5fdbd84158d5895de"
uuid = "a3b82374-2e81-5b9e-98ce-41277c0e4c87"
version = "2.0.1"

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
git-tree-sha1 = "9673d39decc5feece56ef3940e5dafba15ba0f81"
uuid = "aea7be01-6a6a-4083-8856-8a6e6704d82a"
version = "1.1.2"

[[deps.Preferences]]
deps = ["TOML"]
git-tree-sha1 = "7eb1686b4f04b82f96ed7a4ea5890a4f0c7a09f1"
uuid = "21216c6a-2e73-6563-6e65-726566657250"
version = "1.4.0"

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
git-tree-sha1 = "1e597b93700fa4045d7189afa7c004e0584ea548"
uuid = "295af30f-e4ad-537b-8983-00126c2a3abe"
version = "3.5.3"

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

[[deps.StaticArrays]]
deps = ["LinearAlgebra", "Random", "StaticArraysCore"]
git-tree-sha1 = "9cabadf6e7cd2349b6cf49f1915ad2028d65e881"
uuid = "90137ffa-7385-5640-81b9-e52037218182"
version = "1.6.2"
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

[[deps.StructArrays]]
deps = ["Adapt", "DataAPI", "GPUArraysCore", "StaticArraysCore", "Tables"]
git-tree-sha1 = "521a0e828e98bb69042fec1809c1b5a680eb7389"
uuid = "09ab397b-f2b6-538f-b94a-2f83cf4a842a"
version = "0.6.15"

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
deps = ["DataAPI", "DataValueInterfaces", "IteratorInterfaceExtensions", "LinearAlgebra", "OrderedCollections", "TableTraits", "Test"]
git-tree-sha1 = "1544b926975372da01227b382066ab70e574a3ec"
uuid = "bd369af6-aec1-5ad0-b16a-f7cc5008161c"
version = "1.10.1"

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

[[deps.Unitful]]
deps = ["Dates", "LinearAlgebra", "Random"]
git-tree-sha1 = "607c142139151faa591b5e80d8055a15e487095b"
uuid = "1986cc42-f94f-5a68-af5c-568840ba703d"
version = "1.16.3"

    [deps.Unitful.extensions]
    ConstructionBaseUnitfulExt = "ConstructionBase"
    InverseFunctionsUnitfulExt = "InverseFunctions"

    [deps.Unitful.weakdeps]
    ConstructionBase = "187b0558-2788-49d3-abe0-74a17ed4e7c9"
    InverseFunctions = "3587e190-3f89-42d0-90ee-14403ec27112"

[[deps.UnitfulAngles]]
deps = ["Dates", "Unitful"]
git-tree-sha1 = "d6cfdb6ddeb388af1aea38d2b9905fa014d92d98"
uuid = "6fb2a4bd-7999-5318-a3b2-8ad61056cd98"
version = "0.6.2"

[[deps.UnitfulAstro]]
deps = ["Unitful", "UnitfulAngles"]
git-tree-sha1 = "05adf5e3a3bd1038dd50ff6760cddd42380a7260"
uuid = "6112ee07-acf9-5e0f-b108-d242c714bf9f"
version = "1.2.0"

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
# ╟─316b2027-b3a6-45d6-9b65-e26b4ab42e5e
# ╟─d8ce73d3-d4eb-4d2e-b5e6-88afe0920a47
# ╟─4ea1e5d1-36f8-41b8-88ec-23dc933b12c8
# ╟─01ebcac9-daed-4dba-90a7-4ee02dc4221d
# ╟─57af4c4c-21ac-43a9-8d17-00f8fdb903f8
# ╟─62b09b80-4984-4d49-82bb-6fea97272966
# ╟─9cdcafc0-520c-48e6-9b14-3cedbb532d49
# ╟─5f245e5e-3df1-4d1c-8bf9-127aa1bb0587
# ╟─af90a2ec-c6cf-4603-a4ee-b22ea1ce85e9
# ╟─65f1571b-1de2-475a-ac15-51961b57a440
# ╟─7b51032e-ec09-4d08-94b8-f359c7093520
# ╟─0663361f-85d4-46e5-b306-7a4efbeb5888
# ╟─d09e35c4-3ad1-41a0-b00b-048d2ba9cfd8
# ╟─4d552810-41ca-4db7-b3a2-67426d542b7b
# ╟─33a78999-2e97-42ae-b563-6ec492e48bb4
# ╟─0d6f4e52-7d0d-49fa-98f9-bbdf04fc8643
# ╠═9e9d5b7a-4768-47ba-985b-795fec6315b4
# ╟─0843af3e-23b5-4d00-b2b5-4e514d01a842
# ╠═d08ba78a-a5bd-4ce1-bd70-879a3f9fa044
# ╟─ae5589ab-eb85-4240-9cd5-c1ed2663106d
# ╟─17808a9d-e29a-427f-819e-aaecee522c59
# ╟─74a92bc8-f145-4ae4-a42c-017ff22f5b37
# ╟─6643d9fb-6c9e-440b-9658-f7237cc67743
# ╟─b6c96f10-6587-47bc-87fb-a720cdc4ac4d
# ╟─6b6dae67-43de-461a-bb69-94e4950cd5e2
# ╠═c6944314-4a09-49fe-94ce-6da00974e216
# ╟─6b6ec0f0-510d-46ea-b6f6-f793c2c39823
# ╠═106a380e-6eef-4a14-969f-97abe5cf5023
# ╟─582581cc-5155-4903-af2a-a03314cae096
# ╠═8092a7ea-8845-420c-90d7-4dcd1adb6513
# ╟─dc434a7b-4479-4825-8647-9fce917be1ee
# ╟─7a10b691-5208-4084-a9e1-531487cb4f0f
# ╠═00851d59-30fe-4957-afd4-8f317f3baf7f
# ╠═35d941d4-bf6d-4258-8eca-56b5b23ee00c
# ╠═a614df3d-ba22-432f-8e35-0c6988565d82
# ╟─11b2b539-33eb-406c-b20b-a6aacb51e40a
# ╠═b17f5c2f-beff-45c5-98e8-abf2035581af
# ╠═cc5c9c0b-df33-4f52-ac18-e23a965b53a2
# ╠═d162188e-3bff-4698-8d64-96fdb0fb157d
# ╟─2551edba-5892-42de-81d9-c985addfa3db
# ╟─87caa940-4183-4aff-879e-65096c851391
# ╠═9b9bb8cb-b3a9-475a-9c2c-55096a45972c
# ╠═b153bbe1-53f6-4d13-b7ff-bd134657edff
# ╠═de530f98-cc35-44a9-ae99-62b60c7850ea
# ╠═b1e54329-d979-4b1a-89da-e9dd1d7b0bd0
# ╟─5016b36c-5d78-4024-9fce-fe9ba976b887
# ╟─ca66b435-9948-4137-8398-d325dd30ba1b
# ╠═9dcd9dd5-ef6b-486a-a359-ec4a126ebd9e
# ╠═3360c93e-c246-451d-9e23-8eb6048f8c3e
# ╠═15242b15-898e-435b-acf2-b8a61b079e9b
# ╠═46bb29cb-bda9-4224-be94-b531b0ef8eb1
# ╠═ceb0b7d6-29f9-468b-bcb0-7f2f1c1067f8
# ╠═426f28b4-d12a-4ff7-b452-b84ca3af5416
# ╠═878d767d-6435-4dda-b289-2d7db70308d0
# ╠═27c6262b-20fe-4767-9a97-0ee1d186a5be
# ╠═92f56061-025a-4fe4-ae00-743560bdb076
# ╟─a81c5427-91db-429a-860f-fc4b85248f2b
# ╠═7ccd226c-2b44-4106-857d-f39e68896014
# ╟─bc0420c8-afd4-45c3-accf-493aca325395
# ╟─e82ae23e-eee2-434f-9e35-40333d8c94c4
# ╠═d8cfbd63-df7c-49df-b0f7-73cf1f9229af
# ╠═06a943eb-7133-48c0-8a66-5f28aa0c18f0
# ╟─c61db014-48a4-4093-8477-673f2600fb48
# ╠═1ac0e55e-d118-47cc-8fe8-0e3fb99a3284
# ╠═ec462d8d-63a0-4618-8134-8c26936b86e8
# ╟─07fe9bcf-ef89-4549-8be9-ec1cbc9d18dc
# ╠═77a79bd2-00b4-4de4-a013-813847b22d12
# ╠═f890051a-82d0-47f4-99f8-dc2d01d3e81e
# ╠═0a28203f-cf12-41a6-9231-ed9eb3887f3d
# ╠═413aa78c-f4de-4d56-b09c-46a3e4bc06b1
# ╟─75a59648-cd4c-4671-ba5a-b267dda2bb59
# ╟─17e21b48-d98a-41f8-b464-f37631ef3880
# ╠═9af197c9-0395-43c6-a5e6-bcd86a106015
# ╠═b54c9df1-c801-467c-91ff-28bc2deec61b
# ╠═7f6f6644-b768-4196-8fba-0bacb2fcd65a
# ╟─0ad19b3a-1daf-4fa5-a645-7185ce0aeed9
# ╠═f8f1d71e-a2d2-4694-8b41-d3f36a46386a
# ╠═9248cedd-3739-4f86-8b4b-8266dfb14068
# ╟─83aa16bc-fade-4842-914e-98277a80651a
# ╠═3afc7835-9fb4-4d52-b532-b49c90679dcf
# ╠═c2a41966-d055-469d-8811-74c2a7e5d5cf
# ╠═ce55375b-30bf-4de2-9b98-16f84384ecff
# ╟─c47b75eb-12c5-4f93-b5d1-6f382233206d
# ╠═2eba0e92-8f38-4326-abb8-dfc67b799ca3
# ╠═908caef3-7f25-4bd1-8a36-d8680e1976ef
# ╟─890f8813-b516-4431-a51a-ea03b723a4c7
# ╠═859f5ece-ba3d-49d5-a645-dca6cb2203b1
# ╠═3cd28d62-10ec-44c0-809f-d581121ef5f8
# ╠═d8ee4d99-41e6-435e-98c4-a320eaf8aecf
# ╠═c8e6a8c1-c02d-48a7-bc29-7f77ba863d4e
# ╠═e129de08-a81f-43e2-96d4-88f86a585b99
# ╠═519f4699-13e7-469b-9077-96d80f4a9c2a
# ╠═c3de13e5-d31d-4e2e-9756-2f08f54ac494
# ╠═f3a8ee8a-9a9e-4a79-99d1-7644354a175c
# ╠═ad3bd3c6-4412-425b-9488-3d402f9c151c
# ╟─4b53181c-1f3c-4ee0-adaf-d96a5253f40e
# ╠═7d394fd8-d6d7-46ac-9ed0-37ebeb1a9c30
# ╠═66e99211-b6d6-4e0e-ad79-aa572fa31a71
# ╠═8eb629ff-be97-4e69-8fb4-9fd83272586d
# ╠═6e1730c9-2f2c-4745-b9bf-effdc58d16ed
# ╟─9e6ce544-4d7d-4932-aec6-850585da8e7e
# ╠═be3a14da-20cd-4e50-b279-1fe1ad273175
# ╟─3095d63d-0589-4286-b7ee-e81636d0712d
# ╠═01f99268-5ee7-4690-bb5c-757e3457b523
# ╟─3fcc7d66-edbc-4322-ac1a-8314fd2a87f4
# ╟─6f6efd10-616c-4342-b2ec-c3793553a789
# ╠═e11f688f-ba3c-4958-9e63-334e1765e175
# ╟─fe733165-5922-44fc-bfa3-aebe2eaba344
# ╠═453f52fa-ce24-4b7d-81c9-ce46361172a4
# ╟─b6b281af-64a1-44b4-a9b6-ee0ba17f5c0b
# ╟─8759b216-cc38-42ed-b85c-04d508579c54
# ╟─1c640715-9bef-4935-9dce-f94ff2a3740b
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
