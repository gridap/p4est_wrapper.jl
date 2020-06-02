################################################################
# Base fixed datatypes
################################################################
const FILE = Cvoid # File descriptor
const ssize_t = Cssize_t
const MPI_Comm = MPI.MPI_Comm
const MPI_File = MPI.MPI_File
const MPI_Datatype = MPI.MPI_Datatype

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
# Non-wrapped but required data types
# p4est_base.h header not included as it depends on p4est_config.h and sc_config.h.
# This files are automatically generated during configuration. 
################################################################
const p4est_qcoord_t = Cint         # int32_t
const p4est_locidx_t = Cint         # int32_t
const p4est_topidx_t = Cint         # int32_t
const p4est_gloidx_t = Clong        # int64_t

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

#struct piggy1 which_tree::p4est_topidx_t; owner_rank::Cint; end
#struct piggy2 which_tree::p4est_topidx_t; from_tree::p4est_topidx_t; end
#struct piggy3 which_tree::p4est_topidx_t; local_num::p4est_locidx_t; end
# Union{Ptr{Cvoid}, Clong, Cint, p4est_topidx_t, piggy1, piggy2, piggy3}}
primitive type bitdata64 64 end # Biggest data size in union (8 bytes - 64 bits)
const p4est_quadrant_data = bitdata64
const p6est_quadrant_data = bitdata64
const p8est_quadrant_data = bitdata64

#struct full is_ghost::Int8; quad::Ptr{Cvoid}; quadid::p4est_locidx_t; end
#struct hanging is_ghost::NTuple{2,Int8}; quad::NTuple{2,Ptr{Cvoid}}; quadid::NTuple{2,p4est_locidx_t}; end
# Union{Int8, Ptr{Cvoid}, p4est_locidx_t, hanging}
primitive type bitdata208 208 end # Biggest data size in union (26 bytes - 208 bits)
const p4est_iter_face_side_data = bitdata208

#struct full is_ghost::Int8; quad::Ptr{Cvoid}; quadid::p4est_locidx_t; end
#struct hanging is_ghost::NTuple{2,Int8}; quad::NTuple{2,Ptr{Cvoid}}; quadid::NTuple{2,p4est_locidx_t}; end
# Union{full, hanging}
const p8est_iter_edge_side_data = bitdata208


#struct full is_ghost::Int8; quad::Ptr{Cvoid}; quadid::p4est_locidx_t; end
#struct hanging is_ghost::NTuple{4,Int8}; quad::NTuple{4,Ptr{Cvoid}}; quadid::NTuple{4,p4est_locidx_t}; end
# Union{full, hanging}
primitive type bitdata416 416 end # Biggest data size in union (52 bytes - 4016 bits)
const p8est_iter_face_side_data = bitdata416


################################################################
# Array index functions
# Static functions are not part of the API/ABI
################################################################

function sc_array_index(array::Ptr{sc_array_t}, iz::ssize_t)
    sc_array_object = unsafe_wrap(Array, array, 1)[1]
    @assert iz < sc_array_object.elem_count
    return sc_array_object.array + sc_array_object.elem_size * iz
end 
