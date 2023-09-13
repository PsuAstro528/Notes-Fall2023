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

# ╔═╡ 624e8936-de28-4e09-9a4e-3ef2f6c7d9b0
begin
	using PlutoUI, PlutoTest, PlutoTeachingTools
	using BenchmarkTools
	using StaticArrays
	using LoopVectorization
end

# ╔═╡ cf5262da-1043-11ec-12fc-9916cc70070c
md"> Astro 528: High-Performance Scientific Computing for Astrophysics (Fall 2023)"

# ╔═╡ 9ec9429d-c1f1-4845-a514-9c88b452071f
ChooseDisplayMode()

# ╔═╡ ae709a34-9244-44ee-a004-381fc9b6cd0c
md"ToC on side $(@bind toc_aside CheckBox(;default=true))"

# ╔═╡ e7d4bc52-ee18-4d0b-8bab-591b688398fe
TableOfContents(aside=toc_aside)

# ╔═╡ b3407f2a-2fe6-49d0-8ba9-ba7c6c15eb65
md"""
# Administrative Announcements
"""

# ╔═╡ 31476473-d619-404c-a1c1-b32c1b8c5930
md"""
## Class project
- Review [project instructions](https://psuastro528.github.io/Fall2023/project/) on website
- Review feedback on project proposal via Issues→Feedback
- Next step is the serial implementation
- Serial code should be ready for peer code review by Oct 2
- Sign up for [project presentation schedule](https://github.com/PsuAstro528/PresentationsSchedule2021)
"""

# ╔═╡ 348ee204-546f-46c5-bf5d-7d4a761002ec
md"""
# Week 4 Q&A
"""

# ╔═╡ 18f521b4-6a5c-45f1-8fe2-cdd7d0f9921e
blockquote(md"""
What would you say is the most common source of inefficiency in scientific programming, particularly at a novice level?

Too many for-loops where they aren't required? Or something of that nature?
""")


# ╔═╡ a61f6282-8fc8-4a2b-b51b-f188d60a4dad
md"""
### Big picture:
- Using intepretted languages
- Using weakly-typed languages
- Poor choice of algorithms
- Poor choice of data types
- Unnecssary memory allocations
- Cache misses
"""

# ╔═╡ e3cb1597-5831-4d1c-9973-f36bd48579ee
md"""
### Are `for` loops inefficient?
- In python, R (or any interpretted language):  **Yes**
- In C/C++, Fortran, Julia (compiled languages):  **No**
"""

# ╔═╡ 9727c06c-c98d-4f0d-ab5b-3db0bb6ea4a8
md"""
### Common Performance Pitfalls for Julia (and other JIT languages)
- Not organization code into small functions
- Type instability
  - Untyped global variables
  - Containers (e.g., arrays) of abstract types
  - `struct`'s with abstract types
- Unnecessary memory allocations
  - Not taking advantage of fusing and broadcasting
  - Making copies instead of using a `view` (`array[1:5,:]` instead of `view(array,1:5,:)`)
  - Many small allocations on heap (instead use StaticArrays.jl)
- Order of memory accesses
- Not adding annotations that allow for compiler optimizations (e.g., `@inbounds`, `@fastmath`, `@simd`, `@turbo`)
- Unnecessary use of strings or string interpolation
- Writing code that could be parallelized in a way that it isn't parallelized
"""

# ╔═╡ 3ba81578-5de1-4d45-9f73-afe3166cba17
md"""
## Local, Global & Module scope variables
"""

# ╔═╡ 489f9187-e426-4ff2-8275-8516a989dd5c
blockquote("How do [global variables] contrast with local variables?")

# ╔═╡ ba5b1bed-0177-4690-b05c-68410aa7c6be
var_with_notebook_scope = 0

# ╔═╡ 8644644e-8b05-49e1-9dc4-c8a481f64df5
@isdefined var_with_notebook_scope

# ╔═╡ c4f5f77b-931a-4998-8840-2c6ebcfd2570
function function_with_a_local_variable(x::Vector{<:Number}) 
	a_local_variable = sum(x)
	return a_local_variable
end

# ╔═╡ b5520ffd-ead3-4f63-9666-c480533e52b4
function_with_a_local_variable([1,2,3])

# ╔═╡ eb563f76-9daa-493e-aad2-3ca5a2023722
@isdefined a_local_variable

# ╔═╡ e33ad18a-8cd5-4d69-b489-066027a7002d
function function_with_a_global_variable(x::Vector{<:Number})
	return sum(x) + var_with_notebook_scope
end

# ╔═╡ 167e73ea-0a32-46b2-9c81-f5bcff173108
function_with_a_global_variable([1,2,3])

# ╔═╡ 3786ba82-caed-4d3d-85e3-a78a04af042e
@code_warntype function_with_a_global_variable([1,2,3])

# ╔═╡ 38a52834-ca9d-49ab-9a96-165157d86d36
@benchmark function_with_a_local_variable([1,2,3])

# ╔═╡ ed7c87f8-d4e3-44e0-81e0-f940fbc6039c
@benchmark function_with_a_global_variable([1,2,3])

# ╔═╡ 0af9ccf4-f240-4017-9acd-85e9e6ba0a69
@code_warntype function_with_a_local_variable([1,2,3])

# ╔═╡ 68af7f37-3d9f-4739-9411-4653b8f0fb68
global typed_global_var_with_notebook_scope::Int64 = 0

# ╔═╡ 3986a85e-307b-410d-b7bf-d25a85394a87
function function_with_a_typed_global_variable(x::Vector{<:Number})
	return sum(x) + typed_global_var_with_notebook_scope
end

# ╔═╡ 31c6b90e-7791-4ad2-bb21-89d6ed96731f
@code_warntype function_with_a_typed_global_variable([1,2,3])

# ╔═╡ 84df56b4-32f6-4bb3-8661-d2b6afd66574
blockquote("Are global variables set within a program and only used for within that program?  Or can they be called by other programs if set up correctly?")


# ╔═╡ d8dc6e0b-4deb-476b-8fac-cbd5c7194fc4
module MyModule
	var_with_module_scope::Int64 = 42
	function get_var_with_module_scope()
		var_with_module_scope 
	end
	function set_var_with_module_scope!(x)
		var_with_module_scope = x
	end

end

# ╔═╡ 0de613ef-e5c2-44eb-9461-a66489ad785f
@isdefined var_with_module_scope

# ╔═╡ 10c2ab33-80e6-4eba-90b0-aabe7ae72222
MyModule.get_var_with_module_scope()

# ╔═╡ d729ea84-4745-4e6b-afc4-8f5e20bc0709
MyModule.set_var_with_module_scope!(100)

# ╔═╡ d60b556c-79d9-443c-a25a-550d94a659ed
MyModule.var_with_module_scope

# ╔═╡ 41bf44a0-642d-491d-930a-c888ceb727c9
md"""
# Stack
"""

# ╔═╡ 2f3a7dc7-9632-4b8f-998a-b6feee1d133f
blockquote("When will stack overflow happen and how often should we worry about it?")

# ╔═╡ 000ceae7-00d7-4f24-8766-f4edf2d77b8f
md"""
### Recursive function
"""

# ╔═╡ 220b7ca3-740b-4a4a-bcf9-a303285a7a0f
recursive_function(x::Integer) = x > 0 ? x + recursive_function(x-1) : 0

# ╔═╡ ed63ce89-8af8-4219-a771-9191b6e5402c
map(recursive_function,1:10)

# ╔═╡ 89b89611-fd87-4a7c-953f-5096a47f92e0
recursive_function(10)

# ╔═╡ ecceec17-449b-459e-9a30-6ee8d8fbbaa1
recursive_function(130_000)

# ╔═╡ ae4f620a-25fc-4a5b-989d-6e8a2f8a12cc
@allocated recursive_function(100)

# ╔═╡ 9dafb2ac-b07d-4f8a-9e38-bb15ad939f36
md"""
### Replace recursion
"""

# ╔═╡ a61f0724-d227-4f3d-ac4c-9e64f99c6dbd
function not_recursive_function(x::Integer)
	ifelse(x>0,sum(1:x),0)
end

# ╔═╡ 9ccc8e56-6d4c-4b2c-abf1-e496a3fa8ab2
not_recursive_function(130_000)

# ╔═╡ 50ece63b-9d4c-49e3-b357-e862b55df042
@benchmark not_recursive_function(1_000)

# ╔═╡ 8d137b50-546b-4b5f-969b-08b26914146d
@benchmark recursive_function(1_000)

# ╔═╡ a0550e3b-fa4e-47b9-a191-60470309eb89
md"""
### OS sets stack size
"""

# ╔═╡ 2b273744-23bf-495e-8d6e-f386841afb58
md"""
Check your OS's default stack size
```shell
ulimit -s
```
> 8192
"""

# ╔═╡ 30f92fa3-bff3-4321-bcf9-ebfb1563b276
md"""
You can change the stack size (at least on Linux, and any POSIX-compliant system)
```shell
ulimit -s 16384
```
"""

# ╔═╡ 13ab1952-c316-4922-b369-c15d1eb6d67c
blockquote(md"""
Is it possible to have multiple stacks in a CPU or is there only one large stack that is able to run parallel programs?
""")

# ╔═╡ e55a6e31-fe85-441b-90b5-143b4d2007fe
md"""
Each process and each thread gets their own stack.

They share the heap.
"""

# ╔═╡ 9e0fa08a-b49c-4a95-a3ad-3d984564be1b
md"# Compilation"

# ╔═╡ 4a2f1e40-3a63-496e-9df3-809a5c0fffa5
blockquote("What is a compiled language?")

# ╔═╡ 5561903b-c1ca-4363-88aa-a0c13556e7a9
md"""
### Stages of Compilation
- Preprocessing/parsing of human-written code
- *Lowered*/Intermediate form (for weakly or dynamically typed languages)
- *Typed code* (for strongly or dynamically typed typed languages)
- LLVM Compiler's Intermediate Representation (*LLVM IR*) (similar to "byte code")
   - Text form (for a small fraction of humans to read)
   - Binary forms (for compiler, library)
- Native code (for CPU)
- CPU rewrites code on the fly!
"""

# ╔═╡ e7af7b81-6257-4c57-9e13-e429913c969c
md"### Preprocessing/parsing"

# ╔═╡ 19972597-b09f-4cd4-a2e8-c25fcf249453
calc_radius1(x,y) = sqrt(x*x + y*y)

# ╔═╡ bebdd9d1-8781-4f73-af63-53450b2766c7
 Meta.parse("calc_radius1(x,y) = sqrt(x*x + y*y)")

# ╔═╡ cc5ed1c2-4c4f-464f-86bf-49e88eb45465
@code_lowered calc_radius1(1,2)

# ╔═╡ 2a230653-f62f-4faa-a560-b4df7ec42674
calc_radius2(x,y) = sqrt(x^2 + y^2)

# ╔═╡ a2d55fe3-b42b-4794-a51c-1651945e5352
@code_lowered calc_radius2(1,2)

# ╔═╡ 4c8642fe-7dfa-42d8-bbe3-1ca3955437d8
md"""
### Typed Code
**(includes optimizations making use of static analysis, i.e., types & constants)**
"""

# ╔═╡ e89f024b-87b9-4150-a3cc-67d17d105059
@code_typed calc_radius1(1,2)

# ╔═╡ fc2536d1-9a0e-4232-b9b7-31eb94e08f42
@code_typed calc_radius2(1,2)

# ╔═╡ 2fc9e8d4-4b25-4399-a6e2-fc64bf91d740


# ╔═╡ d524bc5b-0cd6-466a-a870-8578f5b785bb
md"Typed code depends on the types of function arguements"

# ╔═╡ 28a48874-4292-471a-a897-d54dfdbeb376
@code_typed calc_radius2(1.0,2.0)

# ╔═╡ 57a3c59e-4187-4fef-bb80-db9b151e50c9
calc_radius_sq(x,y) = (x*x + y*y)

# ╔═╡ cae8c806-a5e7-452e-b1ac-6a09c946926b
let
	xs = randn(5)
	ys = randn(5)
	@code_lowered calc_radius1.(xs,ys)
end

# ╔═╡ 72730f41-f525-4110-8b40-23ead8b92f99
md"### Compiling to LLVM's Intermediate Representation"

# ╔═╡ fac02425-e41c-4918-b04a-cae64063c140
with_terminal() do
	@code_llvm calc_radius1(1,2)
end

# ╔═╡ c18274fa-e6d7-4722-b816-3a8b608b9dd7
md"### Compiling to assmebly or native machine code"

# ╔═╡ 40849999-1b64-4f91-9039-0983b532b30b
blockquote(md"""Is the "machine language" mentioned in the book like Assembly? """)


# ╔═╡ 3bf5a88e-1c1a-4c82-be3e-24370f897da5
with_terminal() do
	@code_native calc_radius1(1,2)
end

# ╔═╡ 11a7fdff-a366-405b-b53b-bf39ca570ee6
md"""
# Start here on Wednesday
"""

# ╔═╡ 1b474b62-4ab1-4ce3-b532-b614c6163206
md"""
## Noteworthy bugs
"""

# ╔═╡ a45b7e2a-8f5b-4c0b-a814-1c214ac8bdd1
md"""
### Test scripts

Julia's test system triggers
```julia
julia --project=@. -e ' import Pkg; Pkg.test() 
```
That's nice, but doesn't you don't want to run all the tests.  So I had suggested:
- `julia --project=test runtests.jl` or
- `julia --project=test test1.jl`
so that you could test one exercise at a time or all at once.  And that's how I tested them.  
But it turns out the current paths is slightly different than if you had run automated testing.
For future labs, I'll setup tests with
- `julia --project -e 'cd("test"); include("runtests.jl")'` or 
- `julia --project -e 'cd("test"); include("test1.jl")'`
"""

# ╔═╡ 18b386eb-5185-4bd6-89da-39fb54a0f068
md"""
## `@inbounds`

In Lab 3, I demonstrated a small scale optimization for inner loops:
```julia
x = rand(n)
for i in 1:n
   @inbounds x[i] *= 2
end
```
This is *very dangerous* if you try to access an element outside the array bounds.
This prevents you from getting useful error messages.  Instead the operating system may kill your job whenever it accesses memory that it doesn't have permission to access.  In this case, the operating system kept killing the julia kernel for the student's notebook, making it hard to debug.

"""

# ╔═╡ 0126154f-430e-4393-88a4-beb70f73cae7
md"""
You can turn bounds checking on/off globally (overwriting `@inbounds` markings) by starting julia with `julia --check-bounds=yes` or `julia --check-bounds=no`.  This can be useful for testing how much adding inbounds could help and checking whether an error might be due to a spurious `@inbounds`
"""

# ╔═╡ 9e00b045-2f36-496c-82cd-d1053e0c49dd
md"""
## More Q&A from week 4
"""

# ╔═╡ 7bdb6187-fff8-4fb6-a094-7fca0bb4f565
blockquote(md"""How does the computer decide what is "local" in its memory? ...
when does the local memory become so big that it is no longer more efficient than just accessing the "hard" memory?""")

# ╔═╡ b11dc85d-97c5-4976-a9be-6f75b022b5e9
md"""
## Compiler optimizations
"""

# ╔═╡ d016269b-d00f-48f0-8178-3000272bc0ee
md"""
```shell
julia -O my_prog.jl
```
"""

# ╔═╡ 2be369c7-fd0b-4157-aa14-edcfdba91e9f
md"#### Other optimization flags

Julia
- `-O`, `-O3`, or `--optimize=3`
- `--check-bounds={yes|no|auto}`

Gcc
- `-O3`
- `-ffast-math`
"

# ╔═╡ 19b61f71-c642-4edb-ad93-c680e5938f17
blockquote("Does the Julia compiler optimize code specifically for the computer architecture of the machine on which it is compiled or optimize generally for common computer architectures?")

# ╔═╡ 4f03f52c-086a-4ce6-94b8-ea9251d00eb0
md"""
Julia
- `-C, --cpu-target <target>`
- `julia -C help` shows long list of avaliable CPUs and CPU features

Gcc
- `-mtune=generic` vs `-mtune=native`
- `-march=native`
"""

# ╔═╡ 0c7b622d-f1c8-435a-8eb7-e466c9ff844a
md"## Looking at typed code for arrays"

# ╔═╡ 4edc3127-7c93-4608-9a01-d965587110c7
md"Output below is from running 
`@code_typed calc_radius1.(xs,ys) on arrays`
"

# ╔═╡ 50cacc64-7410-404a-9218-7f09b1ed54e9
let
	xs = randn(5)
	ys = randn(5)
	@code_typed calc_radius1.(xs,ys)
end 

# ╔═╡ 1fc5e11b-bdf1-4903-b2b4-273a8f14c1e7
md"Output below is from running 
`@code_typedcalc_radius1.(xs,ys) on StaticArrays`
"

# ╔═╡ b811912d-6b7d-4be5-adcf-d72ff60630b4
let
	xs = @SVector randn(5)
	ys = @SVector randn(5)
	@code_typed calc_radius1.(xs,ys)
end

# ╔═╡ b89ff596-1e3f-47f7-a7a0-e16d5b8cf79a
md"""
### @fastmath
If you know you that you:
- Can skip error checking, and
- Can tolerate rearrange expressions (so they are algebraicly equivalent)
"""

# ╔═╡ c9711717-cfe2-4f48-9229-7d6cf981fb8b
calc_radius3(x,y) = @fastmath sqrt(x*x + y*y)

# ╔═╡ 887dbb87-2003-4881-b681-85b55a450333
let
	xs = @SVector randn(5)
	ys = @SVector randn(5)
	@code_typed calc_radius3.(xs,ys)
end

# ╔═╡ e231a5be-5712-41dc-962d-b8b074ffd5ce
md"""
## Compiled vs Interpretted
"""

# ╔═╡ fb036f71-77b7-4252-b6fa-c42d68065740
blockquote(md"""What is the difference between interpreted languages (like Python), and languages that compile at runtime (like Julia)?""")

# ╔═╡ 55af5782-48ee-4bc9-8797-1c2a946f1fc3
blockquote("I believe Julia is a compiled language, but I also heard it has the flexibility like interpreted languages such as Python. Most importantly, it can be easily used on interactive IDEs like jupyter notebook. How can Julia do these?")

# ╔═╡ a6a2d9f6-2df8-4423-88cc-c7b95f396dd8
md"""
**Just-In-Time (JIT) Compilation**
"""

# ╔═╡ 76219861-7316-4c46-a329-5d8b2f955c57
blockquote("Is the Pluto notebook being compiled everytime we rerun a cell?")

# ╔═╡ 7c390a94-f43f-46a6-86a2-97934079d216
md"""
- In Julia (regardless of whether in Pluto, Jupyter, VSCode, REPL), functions (with a unique set of arguement types) only need to be compiled once. 
- Pluto builds a graph of cells based on which cells depend on the results from which other cells.  Pluto triggers reexecution of any cells that depend on your current cell.
"""

# ╔═╡ f0acd13a-ee15-4279-9a75-f88da232599c
blockquote(md"""What is an example of a situation where a dynamically linked library is preferred over a static library?""")
#I can't understand in what situation the improved memory allocation of a shared library is efficient-enough to be worth the risks that are associated with static and global variables that are pointed out by our reading.

# ╔═╡ 086839e8-647a-4962-b551-0ed343b836a2
md"""
- Avoid unnecessary recompilation time
- Reduce storage requirements
"""

# ╔═╡ 025b4c83-bf63-42b3-97d1-e77c9ea8142e
md"""
## Vectorization
*Vectorization* is used in two fundamentally different ways:
- Computing hardware
- Programming pattern
"""

# ╔═╡ 70787815-e59c-401b-9113-220caca042ef
md"""
## Hardware Vectorization

CPUs
- SIMD
- SSE, SSE2, AVX, AVX512

GPUs
- Streamming Multiprocessor (SM)
"""

# ╔═╡ 78623d03-57d2-47c1-acd1-c134c8061fa1
"Multiply matrix A and vector b by hand using rows for inner loop"
function multiply_matrix_vector_no_simd!(out::AbstractVector{T3}, A::AbstractMatrix{T1}, b::AbstractVector{T2})  where {T1<:Number, T2<:Number, T3<:Number}
    @assert size(A,2) == size(b,1)
	@assert size(A,1) == size(out,1)
	for j in 1:size(A,2)
        for i in 1:size(A,1)           
            @inbounds out[i] += A[i,j]*b[j]  # Don't check that indicies are valid
        end
    end
    return out
end

# ╔═╡ ca1f9ddc-2667-4656-9fbc-fd84c10c2b09
"Multiply matrix A and vector b by hand using rows for inner loop"
function multiply_matrix_vector_simd!(out::AbstractVector{T3}, A::AbstractMatrix{T1}, b::AbstractVector{T2})  where {T1<:Number, T2<:Number, T3<:Number}
    @assert size(A,2) == size(b,1)
	@assert size(A,1) == size(out,1)
	@simd for j in 1:size(A,2)               # Use SIMD
		for i in 1:size(A,1)        
            @inbounds out[i] += A[i,j]*b[j]  # Don't check that indicies are valid
        end
    end
    return out
end

# ╔═╡ b66a9bd3-a273-40ff-8ccd-6675e4325b37
begin
	num_rows_A = 16
	num_cols_A = 1024
	A = rand(num_rows_A,num_cols_A)
	b = rand(num_cols_A)
	out = zeros(num_rows_A)
end;

# ╔═╡ bd8e5783-7ca2-4a60-9676-d3136f2b4b91
@test multiply_matrix_vector_no_simd!(out,A,b) == multiply_matrix_vector_simd!(out,A,b)

# ╔═╡ 1748a050-534d-4dcc-ab89-94428d36a4b9
@benchmark multiply_matrix_vector_no_simd!($out,$A,$b)

# ╔═╡ a435bc35-9ee0-4952-8874-2bc13a566a60
@benchmark multiply_matrix_vector_simd!($out,$A,$b)

# ╔═╡ cc74e541-ecc0-46d0-bbb5-b51df1b54596
begin
	A32 = rand(Float32,num_rows_A,num_cols_A)
	b32 = rand(Float32,num_cols_A)
	out32 = rand(Float32,num_rows_A)
end;

# ╔═╡ 1dd9cd49-e7f5-4cc4-8476-5a6108232f09
@benchmark multiply_matrix_vector_no_simd!($out32,$A32,$b32)

# ╔═╡ 8b41a34d-fd2c-4e59-99da-c08bc91f6758
@benchmark multiply_matrix_vector_simd!($out32,$A32,$b32)

# ╔═╡ e899b211-35e6-4602-a6ee-6c973d13f188
md"""
## Vectorization, the Programming Pattern
"""

# ╔═╡ a5249354-fbc8-4081-adea-f00b312116c6
md"Explicit loops are efficient when written in compiled languages, but not interpretted languages."

# ╔═╡ 3f4131f9-6aad-4002-879d-0164a8275cc3
begin
	N = 10000
	x = randn(N)
	y = randn(N)
	result = zeros(N)
end;

# ╔═╡ 5b13fd2a-0833-42ce-b86a-bdc6ff9929d7
md"### Option 1: Explicit `for` loop"

# ╔═╡ 22c3aa63-e563-4717-834d-9337588119fd
md"""
Explicit loops are:
-  Efficient (for computer) in compiled languages, 
-  Very inefficient (for the computer) in interpreted languages
-  More or less conveneient for the programmer, depending on the algorithm.
"""

# ╔═╡ b177883a-01a3-419c-9db2-48af96695b7b
function calc_radius_loop(x::Vector, y::Vector)
	@assert length(x) == length(y)
	r = zeros(promote_type(eltype(x),eltype(y)),length(x))
	for i in 1:length(r)
  		@inbounds r[i] = calc_radius1(x[i],y[i])
	end
	r
end

# ╔═╡ 3bb2bd91-e60c-459f-8f62-d9a0b981c122
@benchmark result4 = calc_radius_loop($x,$y)

# ╔═╡ cd57f4d1-022b-476e-98d1-e2205c2f3b61
md"### Option 2: Vector notation"

# ╔═╡ c4fcb2bf-3003-4bff-81f7-a477aea43ab4
md"""
Vector notation is:
-  Less efficient (for computer) than loops in compiled languages, 
-  Less inefficient (for the computer) than loops in interpreted languages,
-  More or less conveneient for the programmer, depending on the algorithm.
"""

# ╔═╡ 011550a0-2230-4011-b44b-aea9c83c60ef
calc_radius_vector_notation(x::Vector, y::Vector) = sqrt.(x.^2 + y.^2)

# ╔═╡ 36d3b297-405d-42d1-adfd-3ec7b6c68341
@benchmark result2 = calc_radius_vector_notation($x,$y)

# ╔═╡ 6ecb90f5-9756-498a-a4ca-712c15e949f8
md"### Option 3: Vector notation w/ broadcasting & fusing"

# ╔═╡ 25b58a40-7aff-46c3-89f3-ce98717c0af5
md"""
Vector notation w/ broadcasting & fusing is:
-  Efficient (for computer) than loops in compiled languages, 
-  Rarely (never?) avaliable in interpreted languages,
"""

# ╔═╡ ee2f43ac-7b4a-41e3-a3c6-740f5eb39ec6
calc_radius_broadcasted(x::Vector, y::Vector) = sqrt.(x.^2 .+ y.^2)

# ╔═╡ def9cd97-57f3-4397-9b46-be3e11f3f76f
begin
	result3 = calc_radius_broadcasted(x,y)
	@benchmark $result3 .= calc_radius_broadcasted($x,$y)
end

# ╔═╡ 7711518b-3653-4284-b664-6b84d364bdba
md"### Option 4: Explicit `for` loop, memory pre-allocated"

# ╔═╡ d10f3b61-e58d-4a46-81e5-a06bbdace00c
md"""
Explicit for lops that use pre-allocated  memory are:
-  Very efficient (for computer) in compiled languages, 
-  Very inefficient (for the computer) in interpreted languages,
"""

# ╔═╡ 1ac5a43d-a5a2-4e9f-a132-973c0c62bcec
function calc_radius_loop!(r::Vector, x::Vector, y::Vector)
	@assert length(x) == length(y) == length(r)
	for i in 1:length(r)
  		@inbounds r[i] = calc_radius1(x[i],y[i])
	end
	r
end

# ╔═╡ 65075d3e-7e75-4c96-ae66-730a6da3a2eb
@benchmark calc_radius_loop!($result,$x,$y)

# ╔═╡ 5f060719-e7bc-4b3b-890a-ccd264029732
md"""
### Option 5: Explicit `for` loop, pre-allocated & `@turbo`
"""

# ╔═╡ 3d397d17-2aa7-4281-a4d6-16a1764710b3
function calc_radius_loop_turbo!(r::Vector, x::Vector, y::Vector)
	#@assert length(x) == length(y) == length(r)
	@turbo for i in 1:length(r)
  		r[i] = calc_radius1(x[i],y[i])
	end
	r
end

# ╔═╡ d407364c-230a-45a6-bdc5-bf9bb385cdff
@benchmark calc_radius_loop_turbo!($result,$x,$y)

# ╔═╡ abee77fd-e2a2-403b-ab43-b4ea6741ba4c
md"# Memory types & allocation"

# ╔═╡ f3692ac6-78a9-4afd-b412-b279769b4be8
blockquote(md"""Can you explain concept of a von Neumann bottleneck, where "the speed of the memory interface poses a limitation on compute performance"?""")

# ╔═╡ d4dbfc77-7dad-4e7b-83f4-c35a61a0d4a2
md"""
**Q:**
Can you go over again the difference between a stack, register, and cache?
"""

# ╔═╡ e46c0510-f604-4025-bef5-9029e3747447
md"""
### Latency Heirarchy for *Physical* Types of Memory
- Registers
- Cache L1
- Cache L2
- Cache L3
- RAM
- Local disk storage
- Disk storage on local network
- Disk storage on internew
- Tape storage
"""

# ╔═╡ ed0bc201-03c0-448b-bfeb-9f43d7e9ad7a
md"
[Interactive Memory Latency vs Year](https://colin-scott.github.io/personal_website/research/interactive_latency.html)"

# ╔═╡ f4ad0d7b-871c-4ca8-9158-a8b8086282ea
md"""
**Q:** Is this [memory allocation] done automatically in Python? How about in Julia?
"""

# ╔═╡ 3b8f0812-9700-45c4-b1ce-d8cdfe09c38b
let
	a = rand(3)
	b = zeros(3)
	c = a+b
end

# ╔═╡ e4288536-20d8-487f-9d6b-09ab36011f86
a = Vector{Float64}(undef,5)

# ╔═╡ 5a5bf05d-f1bc-4beb-a740-402626850127
@benchmark allocate_and_init = zeros(64*1024)

# ╔═╡ c351f3b2-a93d-4718-ad0f-d76f9295a375
@benchmark allocate_only = Vector{Float64}(undef,64*1024)

# ╔═╡ b590c1f4-406f-43fe-b2be-f580e7f1e9e6
let
	init_only = Vector{Float64}(undef,64*1024)
	@benchmark fill!($init_only, 0)
end

# ╔═╡ f0111b2d-7a7c-4029-8fd0-7c0785b5b038
md"""
### *Logical* types of memory 
##### I.e., Where do your variables go (at compiler/OS level)?

- Stack (scalars, small structures or collections with known size)
- Heap (large collections, structures/collections with unknown size)
"""

# ╔═╡ 2010bde7-4d8c-4ff4-b4f5-c2fab35cd9bc
md"""
# Potporri Questions
"""

# ╔═╡ 0cbc7b82-05d8-44b4-8a72-466914f3167a
blockquote("""
How does someone get started on writing a pipeline? 
Is it strictly hardware?
""")

# ╔═╡ 755b1e25-a8d3-409b-bbe5-a6020b410144
md"""
# Old Questions
"""

# ╔═╡ 335a3e0f-111d-43b9-a2bd-40f708e5da88
md"# Hardware Questions"

# ╔═╡ d0af9442-ba1a-4f0f-8307-db2999e38d67
md"""
**Q:** "Do [non-Intel] CPUs use a different philosophy from Intel CPUs?"
"""

# ╔═╡ ccccafa4-5d0f-4881-abd9-3addc0f58ff1
md"""
**Q:** "Can you explain virtual machines more, and how they speed up efficiency?"
"""

# ╔═╡ 034b35a8-2c51-4bfd-836c-3db9b545f1af
md"## Programming questions"

# ╔═╡ 2e5ef276-fd58-431a-815c-570b49dbe621
md"""**Q:**  
"How careful do we need to be about memory allocation in Julia? 
"""

# ╔═╡ 81aaf7f7-4d09-4cec-9663-0b89eb69ec0c
md"""**Q:**  
Do we need to worry about things like pointers and resetting variables after we are finished with them?"
"""

# ╔═╡ 10d29ef4-9e76-43dc-9007-9c6605cdd02c
md"**Q:** What makes a variable **global**?"

# ╔═╡ 091ed432-d189-4a78-b1f4-8c7128af9438
md"""
**Q:**  
Can you explain what a routine is in the context of a library? Do all programming languages make use of libraries?
"""

# ╔═╡ c6b92d7a-7c3e-4b26-8c3a-b0160c5bcc36
md"## Garbage Collection (from the *heap*)"

# ╔═╡ 3b3d6fdb-5066-48f1-aa64-e28f5ad3c1f1
md"""
Julia's garbage collector is "a non-compacting, generational, mark-and-sweep, tracing collector, which at a high level means the following…

**Mark-Sweep / Tracing**:
- When the garbage collector runs, it starts from a set of “roots” and walks through the object graph, “marking” objects as reachable.
- Any object that isn’t marked as reachable and will then be “swept away” — i.e. its memory is reclaimed—since you know it’s not reachable from the roots and is therefore garbage.

**Generational**:
- It’s common that more recently allocated objects become garbage more quickly—this is known as the “generational hypothesis”.
- Generational collectors have different levels of collection: young collections which run more frequently and full collections which run less frequently.
- If the generational hypothesis is true, this saves time since it’s a waste of time to keep checking if older objects are garbage when they’re probably not." 

**Non-compacting / Non-moving**:
- Other garbage collection techniques can copy or move objects during the collection process.  
- Julia does not use any of these—collection does not move or copy anything, it just reclaims unreachable objects.

If you’re having issues with garbage collection, your primary recourse is to generate less garbage:

- Write non-allocating code wherever possible: simple scalar code can generally avoid allocations.

- Use immutable objects (i.e., `struct` rather than `mutable struct`), which can be stack allocated more easily and stored inline in other structures (as compared to mutable objects which generally need to be heap-allocated and stored indirectly by pointer, all of which causes more memory pressure).

- Use pre-allocated data structures and modify them instead of allocating and returning new objects, especially in loops.

- Can call `GC.gc()` to manually call garbage collector.  But this is mainly useful for benchmarking.

(nearly quote from [Julia Discourse post by Stefan Karpinski](https://discourse.julialang.org/t/details-about-julias-garbage-collector-reference-counting/18021))
"""


# ╔═╡ 8114f59e-1a8e-49c6-baaa-20ed19747d2b
md"""
For lots of small allocations can use `struct's, [Tuple](https://docs.julialang.org/en/v1/manual/types/#Tuple-Types)'s, [NamedTuple](https://docs.julialang.org/en/v1/manual/types/#Named-Tuple-Types)'s or [StaticArrays.jl](https://github.com/JuliaArrays/StaticArrays.jl)
"""

# ╔═╡ 5287e3b8-2309-4c78-91f0-f80e7ae7f209
struct MySmallStruct
	result::Float64
	message::String
end

# ╔═╡ d7fe5753-f02d-4a04-8967-32441149dfe4
mss = MySmallStruct(1.0, "Success")

# ╔═╡ fd53c52d-8acd-4ca5-bcf0-8375d64179cc
t = (1.0, "Success")

# ╔═╡ 6d982d26-1917-4f46-babf-e0ea19886976
t[2]

# ╔═╡ 75661d12-7709-44d0-a5f3-d6c9a5eff952
typeof(t)

# ╔═╡ f632c0ab-ea32-4973-8ec9-79a7f4f4c4ad
nt = (;result = 1.0, message="Success")

# ╔═╡ 15f1d255-0aa9-4837-b76e-1f7b401c93ca
typeof(nt)

# ╔═╡ 4c724a18-e3dc-4cdb-997c-b3687b0d51c5
nt[2]

# ╔═╡ 138806a6-08f9-4b82-9e8c-128baab3da31
nt.message

# ╔═╡ 4772a931-14a6-46c9-8b8c-44b39d213216
begin
	v2 = SVector{3,Float64}(1, 2, 3) # length 3, eltype Float64
	v1 = SVector(1, 2, 3)            # size and type can be inferred
	v3 = @SVector [1, 2, 3]          # macro for converting
	v1.data === (1, 2, 3)    # SVector uses a tuple for internal storage
end;

# ╔═╡ 3f4cac5b-9b2a-4261-a01e-e2d4f692fb90
begin
	m5 = SMatrix{2,2}([1 3 ; 2 4]) 
	m2 = @SMatrix [ 1  3 ;
	                2  4 ]
	m4 = @SMatrix randn(4,4)
end

# ╔═╡ d35aa76c-b4e6-45f8-a4e3-ba37d674db82
md"# Helper Code"

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
BenchmarkTools = "6e4b80f9-dd63-53aa-95a3-0cdb28fa8baf"
LoopVectorization = "bdcacae8-1622-11e9-2a5c-532679323890"
PlutoTeachingTools = "661c6b06-c737-4d37-b85c-46df65de6f69"
PlutoTest = "cb4044da-4d16-4ffa-a6a3-8cad7f73ebdc"
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
StaticArrays = "90137ffa-7385-5640-81b9-e52037218182"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.9.2"
manifest_format = "2.0"
project_hash = "7dcc5cf316807714b811cdc84ea495c84858017e"

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

[[deps.ArrayInterface]]
deps = ["Adapt", "LinearAlgebra", "Requires", "SparseArrays", "SuiteSparse"]
git-tree-sha1 = "f83ec24f76d4c8f525099b2ac475fc098138ec31"
uuid = "4fba245c-0d91-5ea0-9b3e-6abc04ee57a9"
version = "7.4.11"

    [deps.ArrayInterface.extensions]
    ArrayInterfaceBandedMatricesExt = "BandedMatrices"
    ArrayInterfaceBlockBandedMatricesExt = "BlockBandedMatrices"
    ArrayInterfaceCUDAExt = "CUDA"
    ArrayInterfaceGPUArraysCoreExt = "GPUArraysCore"
    ArrayInterfaceStaticArraysCoreExt = "StaticArraysCore"
    ArrayInterfaceTrackerExt = "Tracker"

    [deps.ArrayInterface.weakdeps]
    BandedMatrices = "aae01518-5342-5314-be14-df237901396f"
    BlockBandedMatrices = "ffab5731-97b5-5995-9138-79e8c1846df0"
    CUDA = "052768ef-5323-5732-b1bb-66c8b64840ba"
    GPUArraysCore = "46192b85-c4d5-4398-a991-12ede77f4527"
    StaticArraysCore = "1e83bf80-4336-4d27-bf5d-d5a4f845583c"
    Tracker = "9f7883ad-71c0-57eb-9f7f-b5c9e6d3789c"

[[deps.ArrayInterfaceCore]]
deps = ["LinearAlgebra", "SnoopPrecompile", "SparseArrays", "SuiteSparse"]
git-tree-sha1 = "e5f08b5689b1aad068e01751889f2f615c7db36d"
uuid = "30b0a656-2188-435a-8636-2ec0e6a096e2"
version = "0.1.29"

[[deps.Artifacts]]
uuid = "56f22d72-fd6d-98f1-02f0-08ddc0907c33"

[[deps.Base64]]
uuid = "2a0f44e3-6c83-55bd-87e4-b1978d98bd5f"

[[deps.BenchmarkTools]]
deps = ["JSON", "Logging", "Printf", "Profile", "Statistics", "UUIDs"]
git-tree-sha1 = "d9a9701b899b30332bbcb3e1679c41cce81fb0e8"
uuid = "6e4b80f9-dd63-53aa-95a3-0cdb28fa8baf"
version = "1.3.2"

[[deps.BitTwiddlingConvenienceFunctions]]
deps = ["Static"]
git-tree-sha1 = "0c5f81f47bbbcf4aea7b2959135713459170798b"
uuid = "62783981-4cbd-42fc-bca8-16325de8dc4b"
version = "0.1.5"

[[deps.CPUSummary]]
deps = ["CpuId", "IfElse", "PrecompileTools", "Static"]
git-tree-sha1 = "89e0654ed8c7aebad6d5ad235d6242c2d737a928"
uuid = "2a0fbf3d-bb9c-48f3-b0a9-814d99fd7ab9"
version = "0.2.3"

[[deps.CloseOpenIntervals]]
deps = ["Static", "StaticArrayInterface"]
git-tree-sha1 = "70232f82ffaab9dc52585e0dd043b5e0c6b714f1"
uuid = "fb6a15b2-703c-40df-9091-08a04967cfa9"
version = "0.1.12"

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

[[deps.Compat]]
deps = ["UUIDs"]
git-tree-sha1 = "e460f044ca8b99be31d35fe54fc33a5c33dd8ed7"
uuid = "34da2185-b29b-5c13-b0c7-acf172513d20"
version = "4.9.0"
weakdeps = ["Dates", "LinearAlgebra"]

    [deps.Compat.extensions]
    CompatLinearAlgebraExt = "LinearAlgebra"

[[deps.CompilerSupportLibraries_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "e66e0078-7015-5450-92f7-15fbd957f2ae"
version = "1.0.5+0"

[[deps.CpuId]]
deps = ["Markdown"]
git-tree-sha1 = "fcbb72b032692610bfbdb15018ac16a36cf2e406"
uuid = "adafc99b-e345-5852-983c-f28acb93d879"
version = "0.3.1"

[[deps.Dates]]
deps = ["Printf"]
uuid = "ade2ca70-3891-5945-98fb-dc099432e06a"

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

[[deps.HostCPUFeatures]]
deps = ["BitTwiddlingConvenienceFunctions", "IfElse", "Libdl", "Static"]
git-tree-sha1 = "eb8fed28f4994600e29beef49744639d985a04b2"
uuid = "3e5b6fbb-0976-4d2c-9146-d79de83f2fb0"
version = "0.1.16"

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

[[deps.IfElse]]
git-tree-sha1 = "debdd00ffef04665ccbb3e150747a77560e8fad1"
uuid = "615f187c-cbe4-4ef1-ba3b-2fcf58d6d173"
version = "0.1.1"

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

[[deps.LayoutPointers]]
deps = ["ArrayInterface", "LinearAlgebra", "ManualMemory", "SIMDTypes", "Static", "StaticArrayInterface"]
git-tree-sha1 = "88b8f66b604da079a627b6fb2860d3704a6729a1"
uuid = "10f19ff3-798f-405d-979b-55457f8fc047"
version = "0.1.14"

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

[[deps.LoopVectorization]]
deps = ["ArrayInterface", "ArrayInterfaceCore", "CPUSummary", "CloseOpenIntervals", "DocStringExtensions", "HostCPUFeatures", "IfElse", "LayoutPointers", "LinearAlgebra", "OffsetArrays", "PolyesterWeave", "PrecompileTools", "SIMDTypes", "SLEEFPirates", "Static", "StaticArrayInterface", "ThreadingUtilities", "UnPack", "VectorizationBase"]
git-tree-sha1 = "c88a4afe1703d731b1c4fdf4e3c7e77e3b176ea2"
uuid = "bdcacae8-1622-11e9-2a5c-532679323890"
version = "0.12.165"

    [deps.LoopVectorization.extensions]
    ForwardDiffExt = ["ChainRulesCore", "ForwardDiff"]
    SpecialFunctionsExt = "SpecialFunctions"

    [deps.LoopVectorization.weakdeps]
    ChainRulesCore = "d360d2e6-b24c-11e9-a2a3-2a2ae2dbcce4"
    ForwardDiff = "f6369f11-7733-5829-9624-2563aa707210"
    SpecialFunctions = "276daf66-3868-5448-9aa4-cd146d93841b"

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

[[deps.ManualMemory]]
git-tree-sha1 = "bcaef4fc7a0cfe2cba636d84cda54b5e4e4ca3cd"
uuid = "d125e4d3-2237-4719-b19c-fa641b8a4667"
version = "0.1.8"

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

[[deps.OffsetArrays]]
deps = ["Adapt"]
git-tree-sha1 = "2ac17d29c523ce1cd38e27785a7d23024853a4bb"
uuid = "6fe1bfb0-de20-5000-8ca7-80f57d26f881"
version = "1.12.10"

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

[[deps.PolyesterWeave]]
deps = ["BitTwiddlingConvenienceFunctions", "CPUSummary", "IfElse", "Static", "ThreadingUtilities"]
git-tree-sha1 = "240d7170f5ffdb285f9427b92333c3463bf65bf6"
uuid = "1d0040c9-8b98-4ee7-8388-3f51789ca0ad"
version = "0.2.1"

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

[[deps.SIMDTypes]]
git-tree-sha1 = "330289636fb8107c5f32088d2741e9fd7a061a5c"
uuid = "94e857df-77ce-4151-89e5-788b33177be4"
version = "0.1.0"

[[deps.SLEEFPirates]]
deps = ["IfElse", "Static", "VectorizationBase"]
git-tree-sha1 = "4b8586aece42bee682399c4c4aee95446aa5cd19"
uuid = "476501e8-09a2-5ece-8869-fb82de89a1fa"
version = "0.6.39"

[[deps.Serialization]]
uuid = "9e88b42a-f829-5b0c-bbe9-9e923198166b"

[[deps.SnoopPrecompile]]
deps = ["Preferences"]
git-tree-sha1 = "e760a70afdcd461cf01a575947738d359234665c"
uuid = "66db9d55-30c0-4569-8b51-7e840670fc0c"
version = "1.0.3"

[[deps.Sockets]]
uuid = "6462fe0b-24de-5631-8697-dd941f90decc"

[[deps.SparseArrays]]
deps = ["Libdl", "LinearAlgebra", "Random", "Serialization", "SuiteSparse_jll"]
uuid = "2f01184e-e22b-5df5-ae63-d93ebab69eaf"

[[deps.Static]]
deps = ["IfElse"]
git-tree-sha1 = "f295e0a1da4ca425659c57441bcb59abb035a4bc"
uuid = "aedffcd0-7271-4cad-89d0-dc628f76c6d3"
version = "0.8.8"

[[deps.StaticArrayInterface]]
deps = ["ArrayInterface", "Compat", "IfElse", "LinearAlgebra", "PrecompileTools", "Requires", "SparseArrays", "Static", "SuiteSparse"]
git-tree-sha1 = "03fec6800a986d191f64f5c0996b59ed526eda25"
uuid = "0d7ed370-da01-4f52-bd93-41d350b8b718"
version = "1.4.1"
weakdeps = ["OffsetArrays", "StaticArrays"]

    [deps.StaticArrayInterface.extensions]
    StaticArrayInterfaceOffsetArraysExt = "OffsetArrays"
    StaticArrayInterfaceStaticArraysExt = "StaticArrays"

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

[[deps.SuiteSparse]]
deps = ["Libdl", "LinearAlgebra", "Serialization", "SparseArrays"]
uuid = "4607b0f0-06f3-5cda-b6b1-a6196a1729e9"

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

[[deps.ThreadingUtilities]]
deps = ["ManualMemory"]
git-tree-sha1 = "eda08f7e9818eb53661b3deb74e3159460dfbc27"
uuid = "8290d209-cae3-49c0-8002-c8c24d57dab5"
version = "0.5.2"

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

[[deps.UnPack]]
git-tree-sha1 = "387c1f73762231e86e0c9c5443ce3b4a0a9a0c2b"
uuid = "3a884ed6-31ef-47d7-9d2a-63182c4928ed"
version = "1.0.2"

[[deps.Unicode]]
uuid = "4ec0a83e-493e-50e2-b9ac-8f72acf5a8f5"

[[deps.VectorizationBase]]
deps = ["ArrayInterface", "CPUSummary", "HostCPUFeatures", "IfElse", "LayoutPointers", "Libdl", "LinearAlgebra", "SIMDTypes", "Static", "StaticArrayInterface"]
git-tree-sha1 = "b182207d4af54ac64cbc71797765068fdeff475d"
uuid = "3d5dd08c-fd9d-11e8-17fa-ed2836048c2f"
version = "0.21.64"

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
# ╟─cf5262da-1043-11ec-12fc-9916cc70070c
# ╟─e7d4bc52-ee18-4d0b-8bab-591b688398fe
# ╟─9ec9429d-c1f1-4845-a514-9c88b452071f
# ╟─ae709a34-9244-44ee-a004-381fc9b6cd0c
# ╟─b3407f2a-2fe6-49d0-8ba9-ba7c6c15eb65
# ╟─31476473-d619-404c-a1c1-b32c1b8c5930
# ╟─348ee204-546f-46c5-bf5d-7d4a761002ec
# ╟─18f521b4-6a5c-45f1-8fe2-cdd7d0f9921e
# ╟─a61f6282-8fc8-4a2b-b51b-f188d60a4dad
# ╟─e3cb1597-5831-4d1c-9973-f36bd48579ee
# ╟─9727c06c-c98d-4f0d-ab5b-3db0bb6ea4a8
# ╟─3ba81578-5de1-4d45-9f73-afe3166cba17
# ╟─489f9187-e426-4ff2-8275-8516a989dd5c
# ╠═ba5b1bed-0177-4690-b05c-68410aa7c6be
# ╠═8644644e-8b05-49e1-9dc4-c8a481f64df5
# ╠═c4f5f77b-931a-4998-8840-2c6ebcfd2570
# ╠═b5520ffd-ead3-4f63-9666-c480533e52b4
# ╠═eb563f76-9daa-493e-aad2-3ca5a2023722
# ╠═e33ad18a-8cd5-4d69-b489-066027a7002d
# ╠═167e73ea-0a32-46b2-9c81-f5bcff173108
# ╠═3786ba82-caed-4d3d-85e3-a78a04af042e
# ╠═38a52834-ca9d-49ab-9a96-165157d86d36
# ╠═ed7c87f8-d4e3-44e0-81e0-f940fbc6039c
# ╠═0af9ccf4-f240-4017-9acd-85e9e6ba0a69
# ╠═68af7f37-3d9f-4739-9411-4653b8f0fb68
# ╠═3986a85e-307b-410d-b7bf-d25a85394a87
# ╠═31c6b90e-7791-4ad2-bb21-89d6ed96731f
# ╟─84df56b4-32f6-4bb3-8661-d2b6afd66574
# ╠═d8dc6e0b-4deb-476b-8fac-cbd5c7194fc4
# ╠═0de613ef-e5c2-44eb-9461-a66489ad785f
# ╠═10c2ab33-80e6-4eba-90b0-aabe7ae72222
# ╠═d729ea84-4745-4e6b-afc4-8f5e20bc0709
# ╠═d60b556c-79d9-443c-a25a-550d94a659ed
# ╟─41bf44a0-642d-491d-930a-c888ceb727c9
# ╟─2f3a7dc7-9632-4b8f-998a-b6feee1d133f
# ╟─000ceae7-00d7-4f24-8766-f4edf2d77b8f
# ╠═220b7ca3-740b-4a4a-bcf9-a303285a7a0f
# ╠═ed63ce89-8af8-4219-a771-9191b6e5402c
# ╠═89b89611-fd87-4a7c-953f-5096a47f92e0
# ╠═ecceec17-449b-459e-9a30-6ee8d8fbbaa1
# ╠═ae4f620a-25fc-4a5b-989d-6e8a2f8a12cc
# ╟─9dafb2ac-b07d-4f8a-9e38-bb15ad939f36
# ╠═a61f0724-d227-4f3d-ac4c-9e64f99c6dbd
# ╠═9ccc8e56-6d4c-4b2c-abf1-e496a3fa8ab2
# ╠═50ece63b-9d4c-49e3-b357-e862b55df042
# ╠═8d137b50-546b-4b5f-969b-08b26914146d
# ╟─a0550e3b-fa4e-47b9-a191-60470309eb89
# ╟─2b273744-23bf-495e-8d6e-f386841afb58
# ╟─30f92fa3-bff3-4321-bcf9-ebfb1563b276
# ╟─13ab1952-c316-4922-b369-c15d1eb6d67c
# ╟─e55a6e31-fe85-441b-90b5-143b4d2007fe
# ╟─9e0fa08a-b49c-4a95-a3ad-3d984564be1b
# ╟─4a2f1e40-3a63-496e-9df3-809a5c0fffa5
# ╟─5561903b-c1ca-4363-88aa-a0c13556e7a9
# ╟─e7af7b81-6257-4c57-9e13-e429913c969c
# ╠═19972597-b09f-4cd4-a2e8-c25fcf249453
# ╠═bebdd9d1-8781-4f73-af63-53450b2766c7
# ╠═cc5ed1c2-4c4f-464f-86bf-49e88eb45465
# ╠═2a230653-f62f-4faa-a560-b4df7ec42674
# ╠═a2d55fe3-b42b-4794-a51c-1651945e5352
# ╟─4c8642fe-7dfa-42d8-bbe3-1ca3955437d8
# ╠═e89f024b-87b9-4150-a3cc-67d17d105059
# ╠═fc2536d1-9a0e-4232-b9b7-31eb94e08f42
# ╠═2fc9e8d4-4b25-4399-a6e2-fc64bf91d740
# ╟─d524bc5b-0cd6-466a-a870-8578f5b785bb
# ╠═28a48874-4292-471a-a897-d54dfdbeb376
# ╠═57a3c59e-4187-4fef-bb80-db9b151e50c9
# ╠═cae8c806-a5e7-452e-b1ac-6a09c946926b
# ╟─72730f41-f525-4110-8b40-23ead8b92f99
# ╠═fac02425-e41c-4918-b04a-cae64063c140
# ╟─c18274fa-e6d7-4722-b816-3a8b608b9dd7
# ╟─40849999-1b64-4f91-9039-0983b532b30b
# ╠═3bf5a88e-1c1a-4c82-be3e-24370f897da5
# ╟─11a7fdff-a366-405b-b53b-bf39ca570ee6
# ╟─1b474b62-4ab1-4ce3-b532-b614c6163206
# ╟─a45b7e2a-8f5b-4c0b-a814-1c214ac8bdd1
# ╟─18b386eb-5185-4bd6-89da-39fb54a0f068
# ╟─0126154f-430e-4393-88a4-beb70f73cae7
# ╟─9e00b045-2f36-496c-82cd-d1053e0c49dd
# ╟─7bdb6187-fff8-4fb6-a094-7fca0bb4f565
# ╟─b11dc85d-97c5-4976-a9be-6f75b022b5e9
# ╟─d016269b-d00f-48f0-8178-3000272bc0ee
# ╟─2be369c7-fd0b-4157-aa14-edcfdba91e9f
# ╟─19b61f71-c642-4edb-ad93-c680e5938f17
# ╟─4f03f52c-086a-4ce6-94b8-ea9251d00eb0
# ╟─0c7b622d-f1c8-435a-8eb7-e466c9ff844a
# ╟─4edc3127-7c93-4608-9a01-d965587110c7
# ╠═50cacc64-7410-404a-9218-7f09b1ed54e9
# ╟─1fc5e11b-bdf1-4903-b2b4-273a8f14c1e7
# ╠═b811912d-6b7d-4be5-adcf-d72ff60630b4
# ╟─b89ff596-1e3f-47f7-a7a0-e16d5b8cf79a
# ╠═c9711717-cfe2-4f48-9229-7d6cf981fb8b
# ╠═887dbb87-2003-4881-b681-85b55a450333
# ╟─e231a5be-5712-41dc-962d-b8b074ffd5ce
# ╟─fb036f71-77b7-4252-b6fa-c42d68065740
# ╟─55af5782-48ee-4bc9-8797-1c2a946f1fc3
# ╟─a6a2d9f6-2df8-4423-88cc-c7b95f396dd8
# ╟─76219861-7316-4c46-a329-5d8b2f955c57
# ╟─7c390a94-f43f-46a6-86a2-97934079d216
# ╟─f0acd13a-ee15-4279-9a75-f88da232599c
# ╟─086839e8-647a-4962-b551-0ed343b836a2
# ╟─025b4c83-bf63-42b3-97d1-e77c9ea8142e
# ╟─70787815-e59c-401b-9113-220caca042ef
# ╠═78623d03-57d2-47c1-acd1-c134c8061fa1
# ╠═ca1f9ddc-2667-4656-9fbc-fd84c10c2b09
# ╠═b66a9bd3-a273-40ff-8ccd-6675e4325b37
# ╠═bd8e5783-7ca2-4a60-9676-d3136f2b4b91
# ╠═1748a050-534d-4dcc-ab89-94428d36a4b9
# ╠═a435bc35-9ee0-4952-8874-2bc13a566a60
# ╠═cc74e541-ecc0-46d0-bbb5-b51df1b54596
# ╠═1dd9cd49-e7f5-4cc4-8476-5a6108232f09
# ╠═8b41a34d-fd2c-4e59-99da-c08bc91f6758
# ╟─e899b211-35e6-4602-a6ee-6c973d13f188
# ╟─a5249354-fbc8-4081-adea-f00b312116c6
# ╠═3f4131f9-6aad-4002-879d-0164a8275cc3
# ╟─5b13fd2a-0833-42ce-b86a-bdc6ff9929d7
# ╟─22c3aa63-e563-4717-834d-9337588119fd
# ╠═b177883a-01a3-419c-9db2-48af96695b7b
# ╠═3bb2bd91-e60c-459f-8f62-d9a0b981c122
# ╟─cd57f4d1-022b-476e-98d1-e2205c2f3b61
# ╟─c4fcb2bf-3003-4bff-81f7-a477aea43ab4
# ╠═011550a0-2230-4011-b44b-aea9c83c60ef
# ╠═36d3b297-405d-42d1-adfd-3ec7b6c68341
# ╟─6ecb90f5-9756-498a-a4ca-712c15e949f8
# ╟─25b58a40-7aff-46c3-89f3-ce98717c0af5
# ╠═ee2f43ac-7b4a-41e3-a3c6-740f5eb39ec6
# ╠═def9cd97-57f3-4397-9b46-be3e11f3f76f
# ╟─7711518b-3653-4284-b664-6b84d364bdba
# ╟─d10f3b61-e58d-4a46-81e5-a06bbdace00c
# ╠═1ac5a43d-a5a2-4e9f-a132-973c0c62bcec
# ╠═65075d3e-7e75-4c96-ae66-730a6da3a2eb
# ╟─5f060719-e7bc-4b3b-890a-ccd264029732
# ╠═3d397d17-2aa7-4281-a4d6-16a1764710b3
# ╠═d407364c-230a-45a6-bdc5-bf9bb385cdff
# ╟─abee77fd-e2a2-403b-ab43-b4ea6741ba4c
# ╠═f3692ac6-78a9-4afd-b412-b279769b4be8
# ╠═d4dbfc77-7dad-4e7b-83f4-c35a61a0d4a2
# ╟─e46c0510-f604-4025-bef5-9029e3747447
# ╟─ed0bc201-03c0-448b-bfeb-9f43d7e9ad7a
# ╟─f4ad0d7b-871c-4ca8-9158-a8b8086282ea
# ╠═3b8f0812-9700-45c4-b1ce-d8cdfe09c38b
# ╠═e4288536-20d8-487f-9d6b-09ab36011f86
# ╠═5a5bf05d-f1bc-4beb-a740-402626850127
# ╠═c351f3b2-a93d-4718-ad0f-d76f9295a375
# ╠═b590c1f4-406f-43fe-b2be-f580e7f1e9e6
# ╟─f0111b2d-7a7c-4029-8fd0-7c0785b5b038
# ╟─2010bde7-4d8c-4ff4-b4f5-c2fab35cd9bc
# ╟─0cbc7b82-05d8-44b4-8a72-466914f3167a
# ╟─755b1e25-a8d3-409b-bbe5-a6020b410144
# ╟─335a3e0f-111d-43b9-a2bd-40f708e5da88
# ╟─d0af9442-ba1a-4f0f-8307-db2999e38d67
# ╟─ccccafa4-5d0f-4881-abd9-3addc0f58ff1
# ╟─034b35a8-2c51-4bfd-836c-3db9b545f1af
# ╟─2e5ef276-fd58-431a-815c-570b49dbe621
# ╟─81aaf7f7-4d09-4cec-9663-0b89eb69ec0c
# ╟─10d29ef4-9e76-43dc-9007-9c6605cdd02c
# ╟─091ed432-d189-4a78-b1f4-8c7128af9438
# ╟─c6b92d7a-7c3e-4b26-8c3a-b0160c5bcc36
# ╟─3b3d6fdb-5066-48f1-aa64-e28f5ad3c1f1
# ╟─8114f59e-1a8e-49c6-baaa-20ed19747d2b
# ╠═5287e3b8-2309-4c78-91f0-f80e7ae7f209
# ╠═d7fe5753-f02d-4a04-8967-32441149dfe4
# ╠═fd53c52d-8acd-4ca5-bcf0-8375d64179cc
# ╠═6d982d26-1917-4f46-babf-e0ea19886976
# ╠═75661d12-7709-44d0-a5f3-d6c9a5eff952
# ╠═f632c0ab-ea32-4973-8ec9-79a7f4f4c4ad
# ╠═15f1d255-0aa9-4837-b76e-1f7b401c93ca
# ╠═4c724a18-e3dc-4cdb-997c-b3687b0d51c5
# ╠═138806a6-08f9-4b82-9e8c-128baab3da31
# ╠═4772a931-14a6-46c9-8b8c-44b39d213216
# ╠═3f4cac5b-9b2a-4261-a01e-e2d4f692fb90
# ╟─d35aa76c-b4e6-45f8-a4e3-ba37d674db82
# ╠═624e8936-de28-4e09-9a4e-3ef2f6c7d9b0
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
