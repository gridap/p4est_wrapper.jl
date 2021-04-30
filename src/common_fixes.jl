################################################################
# Base fixed datatypes
################################################################
const FILE         = Cvoid # File descriptor
if P4EST_ENABLE_MPI
    const MPI_Comm = MPI.MPI_Comm
else
    const MPI_Comm = Cint
end
const MPI_Datatype = MPI.MPI_Datatype
const MPI_File     = MPI.MPI_File
const sc_MPI_Comm  = MPI_Comm
const ssize_t      = Cssize_t

################################################################
# Non-wrapped but required data types
# p4est_base.h header not included as it depends on p4est_config.h and sc_config.h.
# This files are automatically generated during configuration. 
################################################################
const p4est_qcoord_t = Cint         # int32_t
const p4est_locidx_t = Cint         # int32_t
const p4est_topidx_t = Cint         # int32_t
const p4est_gloidx_t = Clong        # int64_t

################################################################
# fix sc_array struct. 
# Wrong element_size and elem_cont datatypes (Cint -> Cssize_t)
################################################################
struct sc_array
    elem_size::Csize_t
    elem_count::Csize_t
    byte_alloc::ssize_t
    array::Ptr{Cchar}
end

const sc_array_t = sc_array

################################################################
# C-Unions: Non supported 
#
# A union is a special data type available in C.
# C-Unions allows to store different data types in the same memory location. 
# The memory occupied by a C-Union will be equal to the largest member of the union.
#
# From the Julia point of view, we treat C-Unions as fixed size plain memory regions.
# These memory regions can be later reinterpreted as any of the original members of the C-Union.
################################################################

function _pointer_to_c_memory(obj::S) where {S}
    Base.unsafe_convert(Ptr{Cvoid}, [obj])
end

function _unsafe_reinterpret(::Type{T}, obj::S) where {T,S}
# Use unsafe_wrap to avoid copy from unsafe_load 
# unsafe_load(Ptr{T}(Base.unsafe_convert(Ptr{Cvoid}, Ref{S}(obj))))
    unsafe_wrap(Array, Ptr{T}(_pointer_to_c_memory(obj)), 1)[]
end

    ############################################
    # Primitive type: quadrant_data 
    # represents the following p4est C-Unions:
    #   - p4est_quadrant_data
    #   - p6est_quadrant_data
    #   - p8est_quadrant_data
    ############################################
struct piggy1 which_tree::p4est_topidx_t; owner_rank::Cint; end
struct piggy2 which_tree::p4est_topidx_t; from_tree::p4est_topidx_t; end
struct piggy3 which_tree::p4est_topidx_t; local_num::p4est_locidx_t; end

quadrant_data_union = Union{Ptr{Cvoid}, Clong, Cint, p4est_topidx_t, piggy1, piggy2, piggy3}
quadrant_data_properties = (:user_data, :user_long, :user_int, :which_tree, :piggy1, :piggy2, :piggy3)
primitive type quadrant_data 8*sizeof(quadrant_data_union) end # Biggest data size in union (8 bytes - 64 bits)

function Base.getproperty(x::quadrant_data, name::Symbol)
    if name == :user_data
        _unsafe_reinterpret(Ptr{Cvoid}, x)
    elseif name == :user_long
        _unsafe_reinterpret(Clong, x)
    elseif name == :user_int || name == :which_tree
        _unsafe_reinterpret(Cint, x)
    elseif name == :piggy1
        _unsafe_reinterpret(piggy1, x)
    elseif name == :piggy2
        _unsafe_reinterpret(piggy2, x)
    elseif name == :piggy3
        _unsafe_reinterpret(piggy3, x)
    else
        getfield(x, name)
    end
end

Base.propertynames(x::quadrant_data) = (quadrant_data_properties..., fieldnames(DataType)...)

const p4est_quadrant_data = quadrant_data
const p6est_quadrant_data = quadrant_data
const p8est_quadrant_data = quadrant_data

    ############################################
    # Primitive type: iter_side_data_2 
    # represents the following p4est C-Unions:
    #   - p4est_iter_face_side_data
    #   - p8est_iter_edge_side_data
    ############################################

struct full is_ghost::Int8; quad::Ptr{Cvoid}; quadid::p4est_locidx_t; end
struct hanging{S} is_ghost::NTuple{S,Int8}; quad::NTuple{S,Ptr{Cvoid}}; quadid::NTuple{S,p4est_locidx_t}; end
iter_side_data_properties = (:full, :hanging)

# Biggest data size in union (24 bytes - 192 bits)
iter_side_data_2_union = Union{full, hanging{2}}
primitive type iter_side_data_2 8*sizeof(iter_side_data_2_union) end

function Base.getproperty(x::iter_side_data_2, name::Symbol)
    if name == :full
        _unsafe_reinterpret(full, x)
    elseif name == :hanging
        _unsafe_reinterpret(hanging{2}, x)
    else
        getfield(x, name)
    end
end

Base.propertynames(x::iter_side_data_2) = (iter_side_data_properties..., fieldnames(DataType)...)

const p4est_iter_face_side_data = iter_side_data_2
const p8est_iter_edge_side_data = iter_side_data_2

    ############################################
    # Primitive type: iter_side_data_4 
    # represents the following p4est C-Unions:
    #   - p8est_iter_face_side_data
    ############################################

# Biggest data size in union (32 bytes - 256 bits) 
iter_side_data_4_union = Union{full, hanging{4}}
primitive type iter_side_data_4 8*sizeof(iter_side_data_4_union) end 

function Base.getproperty(x::iter_side_data_4, name::Symbol)
    if name == :full
        _unsafe_reinterpret(full, x)
    elseif name == :hanging
        _unsafe_reinterpret(hanging{4}, x)
    else
        getfield(x, name)
    end
end

Base.propertynames(x::iter_side_data_4) = (iter_side_data_properties..., fieldnames(DataType)...)

const p8est_iter_face_side_data = iter_side_data_4

