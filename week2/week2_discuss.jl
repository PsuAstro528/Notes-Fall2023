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
- Flexibility & Generic Code
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

# ╔═╡ ff97e43d-cee0-4b7c-9040-74db8e51dfa4
md"""
# Unit Testing
- How does one write tests for scientific software when the expected answer is unknown?
- What would unit tests miss?

"""

# ╔═╡ ae5589ab-eb85-4240-9cd5-c1ed2663106d
md"""
## Finding a Balance
How should we balance writing code that is general purpose (i.e. flexible) vs. writing code that is problem specific and then adapting it later for new problems
?

It is not always clear (or possible to know) what we need our programs to do next.
"""

# ╔═╡ 17808a9d-e29a-427f-819e-aaecee522c59
md"""
## Generic vs Problem-specific Code

Inevitably, I find myself having to re-write code on many occasions in order to 
accommodate new analyses.

If I try to write all-purpose functions from the get-go, I get caught up in trying to figure out what I might need my code to do in the future!
"""

# ╔═╡ 33a78999-2e97-42ae-b563-6ec492e48bb4
md"""
# How much and when to __document__ code?
- Would it make more sense to just focus on commenting and proper documentation?
- I don't want to spend time solving a problem that isn't even a problem.

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

# ╔═╡ 1d93fa40-a7b5-4afc-93f6-9a5a5c0d6764
md"""
# Opportunities for Generic Code
Almost all the code I write is designed to accomplish a specific task.

What are some ways to make your program more flexible when you're only writing it for one specific purpose at the time?
"""

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
md"# Why specify any types?"

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

[compat]
BenchmarkTools = "~1.3.2"
ElasticArrays = "~1.2.11"
FillArrays = "~1.6.1"
LazyArrays = "~1.6.1"
PlutoTeachingTools = "~0.1.3"
PlutoTest = "~0.1.0"
PlutoUI = "~0.7.9"
StaticArrays = "~1.6.2"
StructArrays = "~0.6.15"
Unitful = "~1.17.0"
UnitfulAstro = "~1.2.0"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

[[Adapt]]
deps = ["LinearAlgebra", "Requires"]
git-tree-sha1 = "76289dc51920fdc6e0013c872ba9551d54961c24"
uuid = "79e6a3ab-5dfb-504d-930d-738a2a938a0e"
version = "3.6.2"
weakdeps = ["StaticArrays"]

    [Adapt.extensions]
    AdaptStaticArraysExt = "StaticArrays"

[[ArgTools]]
uuid = "0dad84c5-d112-42e6-8d28-ef12dabb789f"
version = "1.1.1"

[[ArrayLayouts]]
deps = ["FillArrays", "LinearAlgebra", "SparseArrays"]
git-tree-sha1 = "609e6019f91369149556628d90345a1316f8dbd3"
uuid = "4c555306-a7a7-4459-81d9-ec55ddd5c99a"
version = "1.2.1"

[[Artifacts]]
uuid = "56f22d72-fd6d-98f1-02f0-08ddc0907c33"

[[Base64]]
uuid = "2a0f44e3-6c83-55bd-87e4-b1978d98bd5f"

[[BenchmarkTools]]
deps = ["JSON", "Logging", "Printf", "Profile", "Statistics", "UUIDs"]
git-tree-sha1 = "d9a9701b899b30332bbcb3e1679c41cce81fb0e8"
uuid = "6e4b80f9-dd63-53aa-95a3-0cdb28fa8baf"
version = "1.3.2"

[[CompilerSupportLibraries_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "e66e0078-7015-5450-92f7-15fbd957f2ae"
version = "1.0.2+0"

[[DataAPI]]
git-tree-sha1 = "8da84edb865b0b5b0100c0666a9bc9a0b71c553c"
uuid = "9a962f9c-6df0-11e9-0e5d-c546b8b5ee8a"
version = "1.15.0"

[[DataValueInterfaces]]
git-tree-sha1 = "bfc1187b79289637fa0ef6d4436ebdfe6905cbd6"
uuid = "e2d170a0-9d28-54be-80f0-106bbe20a464"
version = "1.0.0"

[[Dates]]
deps = ["Printf"]
uuid = "ade2ca70-3891-5945-98fb-dc099432e06a"

[[Downloads]]
deps = ["ArgTools", "FileWatching", "LibCURL", "NetworkOptions"]
uuid = "f43a241f-c20a-4ad4-852c-f6b1247861c6"
version = "1.6.0"

[[ElasticArrays]]
deps = ["Adapt"]
git-tree-sha1 = "e1c40d78de68e9a2be565f0202693a158ec9ad85"
uuid = "fdbdab4c-e67f-52f5-8c3f-e7b388dad3d4"
version = "1.2.11"

[[FileWatching]]
uuid = "7b1f6079-737a-58dc-b8bc-7a2ca5c1b5ee"

[[FillArrays]]
deps = ["LinearAlgebra", "Random"]
git-tree-sha1 = "a20eaa3ad64254c61eeb5f230d9306e937405434"
uuid = "1a297f60-69ca-5386-bcde-b61e274b549b"
version = "1.6.1"
weakdeps = ["SparseArrays", "Statistics"]

    [FillArrays.extensions]
    FillArraysSparseArraysExt = "SparseArrays"
    FillArraysStatisticsExt = "Statistics"

[[GPUArraysCore]]
deps = ["Adapt"]
git-tree-sha1 = "2d6ca471a6c7b536127afccfa7564b5b39227fe0"
uuid = "46192b85-c4d5-4398-a991-12ede77f4527"
version = "0.1.5"

[[HypertextLiteral]]
git-tree-sha1 = "1e3ccdc7a6f7b577623028e0095479f4727d8ec1"
uuid = "ac1192a8-f4b3-4bfe-ba22-af5b92cd3ab2"
version = "0.8.0"

[[InteractiveUtils]]
deps = ["Markdown"]
uuid = "b77e0a4c-d291-57a0-90e8-8db25a27a240"

[[IteratorInterfaceExtensions]]
git-tree-sha1 = "a3f24677c21f5bbe9d2a714f95dcd58337fb2856"
uuid = "82899510-4779-5014-852e-03e436cf321d"
version = "1.0.0"

[[JSON]]
deps = ["Dates", "Mmap", "Parsers", "Unicode"]
git-tree-sha1 = "81690084b6198a2e1da36fcfda16eeca9f9f24e4"
uuid = "682c06a0-de6a-54ab-a142-c8b1cf79cde6"
version = "0.21.1"

[[LaTeXStrings]]
git-tree-sha1 = "c7f1c695e06c01b95a67f0cd1d34994f3e7db104"
uuid = "b964fa9f-0449-5b57-a5c2-d3ea65f4040f"
version = "1.2.1"

[[LazyArrays]]
deps = ["ArrayLayouts", "FillArrays", "LinearAlgebra", "MacroTools", "MatrixFactorizations", "SparseArrays"]
git-tree-sha1 = "45700994c91a14c40b8e4f2e3ce7fc9716b0c7c8"
uuid = "5078a376-72f3-5289-bfd5-ec5146d43c02"
version = "1.6.1"
weakdeps = ["StaticArrays"]

    [LazyArrays.extensions]
    LazyArraysStaticArraysExt = "StaticArrays"

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

[[MacroTools]]
deps = ["Markdown", "Random"]
git-tree-sha1 = "9ee1618cbf5240e6d4e0371d6f24065083f60c48"
uuid = "1914dd2f-81c6-5fcd-8719-6d5c9610ff09"
version = "0.5.11"

[[Markdown]]
deps = ["Base64"]
uuid = "d6f4376e-aef5-505a-96c1-9c027394607a"

[[MatrixFactorizations]]
deps = ["ArrayLayouts", "LinearAlgebra", "Printf", "Random"]
git-tree-sha1 = "78f6e33434939b0ac9ba1df81e6d005ee85a7396"
uuid = "a3b82374-2e81-5b9e-98ce-41277c0e4c87"
version = "2.1.0"

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
deps = ["Dates"]
git-tree-sha1 = "94bf17e83a0e4b20c8d77f6af8ffe8cc3b386c0a"
uuid = "69de0a69-1ddd-5017-9359-2bf0b02dc9f0"
version = "1.1.1"

[[Pkg]]
deps = ["Artifacts", "Dates", "Downloads", "FileWatching", "LibGit2", "Libdl", "Logging", "Markdown", "Printf", "REPL", "Random", "SHA", "Serialization", "TOML", "Tar", "UUIDs", "p7zip_jll"]
uuid = "44cfe95a-1eb2-52ea-b672-e2afdf69b78f"
version = "1.9.0"

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

[[Profile]]
deps = ["Printf"]
uuid = "9abbd945-dff8-562f-b5e8-e1ebf5ef1b79"

[[REPL]]
deps = ["InteractiveUtils", "Markdown", "Sockets", "Unicode"]
uuid = "3fa0cd96-eef1-5676-8a61-b3b8758bbffb"

[[Random]]
deps = ["SHA", "Serialization"]
uuid = "9a3f8284-a2c9-5f02-9a11-845980a1fd5c"

[[Reexport]]
git-tree-sha1 = "5f6c21241f0f655da3952fd60aa18477cf96c220"
uuid = "189a3867-3050-52da-a836-e630ba90ab69"
version = "1.1.0"

[[Requires]]
deps = ["UUIDs"]
git-tree-sha1 = "838a3a4188e2ded87a4f9f184b4b0d78a1e91cb7"
uuid = "ae029012-a4dd-5104-9daa-d747884805df"
version = "1.3.0"

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

[[StaticArrays]]
deps = ["LinearAlgebra", "Random", "StaticArraysCore"]
git-tree-sha1 = "9cabadf6e7cd2349b6cf49f1915ad2028d65e881"
uuid = "90137ffa-7385-5640-81b9-e52037218182"
version = "1.6.2"
weakdeps = ["Statistics"]

    [StaticArrays.extensions]
    StaticArraysStatisticsExt = "Statistics"

[[StaticArraysCore]]
git-tree-sha1 = "36b3d696ce6366023a0ea192b4cd442268995a0d"
uuid = "1e83bf80-4336-4d27-bf5d-d5a4f845583c"
version = "1.4.2"

[[Statistics]]
deps = ["LinearAlgebra", "SparseArrays"]
uuid = "10745b16-79ce-11e8-11f9-7d13ad32a3b2"
version = "1.9.0"

[[StructArrays]]
deps = ["Adapt", "DataAPI", "GPUArraysCore", "StaticArraysCore", "Tables"]
git-tree-sha1 = "521a0e828e98bb69042fec1809c1b5a680eb7389"
uuid = "09ab397b-f2b6-538f-b94a-2f83cf4a842a"
version = "0.6.15"

[[SuiteSparse_jll]]
deps = ["Artifacts", "Libdl", "Pkg", "libblastrampoline_jll"]
uuid = "bea87d4a-7f5b-5778-9afe-8cc45184846c"
version = "5.10.1+6"

[[Suppressor]]
git-tree-sha1 = "a819d77f31f83e5792a76081eee1ea6342ab8787"
uuid = "fd094767-a336-5f1f-9728-57cf17d0bbfb"
version = "0.2.0"

[[TOML]]
deps = ["Dates"]
uuid = "fa267f1f-6049-4f14-aa54-33bafae1ed76"
version = "1.0.3"

[[TableTraits]]
deps = ["IteratorInterfaceExtensions"]
git-tree-sha1 = "c06b2f539df1c6efa794486abfb6ed2022561a39"
uuid = "3783bdb8-4a98-5b6b-af9a-565f29a5fe9c"
version = "1.0.1"

[[Tables]]
deps = ["DataAPI", "DataValueInterfaces", "IteratorInterfaceExtensions", "LinearAlgebra", "OrderedCollections", "TableTraits", "Test"]
git-tree-sha1 = "1544b926975372da01227b382066ab70e574a3ec"
uuid = "bd369af6-aec1-5ad0-b16a-f7cc5008161c"
version = "1.10.1"

[[Tar]]
deps = ["ArgTools", "SHA"]
uuid = "a4e569a6-e804-4fa4-b0f3-eef7a1d5b13e"
version = "1.10.0"

[[Test]]
deps = ["InteractiveUtils", "Logging", "Random", "Serialization"]
uuid = "8dfed614-e22c-5e08-85e1-65c5234f0b40"

[[UUIDs]]
deps = ["Random", "SHA"]
uuid = "cf7118a7-6976-5b1a-9a39-7adc72f591a4"

[[Unicode]]
uuid = "4ec0a83e-493e-50e2-b9ac-8f72acf5a8f5"

[[Unitful]]
deps = ["Dates", "LinearAlgebra", "Random"]
git-tree-sha1 = "a72d22c7e13fe2de562feda8645aa134712a87ee"
uuid = "1986cc42-f94f-5a68-af5c-568840ba703d"
version = "1.17.0"

    [Unitful.extensions]
    ConstructionBaseUnitfulExt = "ConstructionBase"
    InverseFunctionsUnitfulExt = "InverseFunctions"

    [Unitful.weakdeps]
    ConstructionBase = "187b0558-2788-49d3-abe0-74a17ed4e7c9"
    InverseFunctions = "3587e190-3f89-42d0-90ee-14403ec27112"

[[UnitfulAngles]]
deps = ["Dates", "Unitful"]
git-tree-sha1 = "d6cfdb6ddeb388af1aea38d2b9905fa014d92d98"
uuid = "6fb2a4bd-7999-5318-a3b2-8ad61056cd98"
version = "0.6.2"

[[UnitfulAstro]]
deps = ["Unitful", "UnitfulAngles"]
git-tree-sha1 = "05adf5e3a3bd1038dd50ff6760cddd42380a7260"
uuid = "6112ee07-acf9-5e0f-b108-d242c714bf9f"
version = "1.2.0"

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
# ╟─080d3a94-161e-4482-9cf4-b82ffb98d0ed
# ╟─a21b553b-eecb-4105-a0ed-d936e500788b
# ╟─afe9b7c1-d031-4e1f-bd5b-5aeed30d7048
# ╟─959f2c12-287c-4648-a585-0c11d0db812d
# ╟─316b2027-b3a6-45d6-9b65-e26b4ab42e5e
# ╟─d8ce73d3-d4eb-4d2e-b5e6-88afe0920a47
# ╟─4ea1e5d1-36f8-41b8-88ec-23dc933b12c8
# ╟─ff97e43d-cee0-4b7c-9040-74db8e51dfa4
# ╟─ae5589ab-eb85-4240-9cd5-c1ed2663106d
# ╟─17808a9d-e29a-427f-819e-aaecee522c59
# ╟─33a78999-2e97-42ae-b563-6ec492e48bb4
# ╠═9e9d5b7a-4768-47ba-985b-795fec6315b4
# ╟─0843af3e-23b5-4d00-b2b5-4e514d01a842
# ╠═d08ba78a-a5bd-4ce1-bd70-879a3f9fa044
# ╟─1d93fa40-a7b5-4afc-93f6-9a5a5c0d6764
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
# ╟─9cdcafc0-520c-48e6-9b14-3cedbb532d49
# ╟─5f245e5e-3df1-4d1c-8bf9-127aa1bb0587
# ╟─b6b281af-64a1-44b4-a9b6-ee0ba17f5c0b
# ╟─8759b216-cc38-42ed-b85c-04d508579c54
# ╟─1c640715-9bef-4935-9dce-f94ff2a3740b
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
