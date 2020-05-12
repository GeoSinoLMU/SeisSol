#  GemmTools - BLAS-like Library Instantiation Software Framework
#  email: ravil.dorozhinskii@tum.de 
#
#  Input:
#  GEMM_TOOLS_LIST                - a list of targeted BLAS implementations
#                                   which support GEneral Matrix Matrix multiplications
#
#  Output:
#  GemmTools_FOUND                - system has found GemmTools
#  GemmTools_INCLUDE_DIRS         - include directories for GemmTools
#  GemmTools_LIBRARIES            - libraries for GemmTools
#  GemmTools_COMPILER_DEFINITIONS - compiler definitions for GemmTools 
#
#  Example usage:
#
#  set(GEMM_TOOLS_LIST "LIBXSMM,PSpaMM")
#
#  find_package(GEMM_TOOLS_LIST)
#  if(GEMM_TOOLS_FOUND)
#    if(GEMM_TOOLS_INCLUDE_DIRS)
#      target_include_directories(TARGET PUBLIC ${GEMM_TOOLS_INCLUDE_DIRS})
#    endif()
#    if(GEMM_TOOLS_LIBRARIES)
#      target_link_libraries(TARGET PUBLIC ${GEMM_TOOLS_LIBRARIES})
#    endif()
#    if(GEMM_TOOLS_COMPILER_DEFINITIONS)  
#      target_compile_definitions(TARGET PUBLIC ${GEMM_TOOLS_COMPILER_DEFINITIONS})
#    endif()
#  endif()

string(REPLACE "," ";" _GEMM_TOOLS_LIST ${GEMM_TOOLS_LIST})

foreach(component ${_GEMM_TOOLS_LIST})
    if ("${component}" STREQUAL "LIBXSMM")
        find_package(Libxsmm_executable REQUIRED)

    elseif ("${component}" STREQUAL "PSpaMM")
        find_package(PSpaMM REQUIRED)

    elseif ("${component}" STREQUAL "MKL")
        find_package(MKL REQUIRED)

    elseif ("${component}" STREQUAL "OpenBLAS")
        find_package(OpenBLAS REQUIRED)

    elseif ("${component}" STREQUAL "BLIS")
        find_package(BLIS REQUIRED)

    elseif ("${component}" STREQUAL "GemmForge")
        if (NOT DEFINED DEVICE_BACKEND)
            message(FATAL_ERROR "GemmForge option was chosen but DEVICE_BACKEND wasn't. \
                    Please, refer to the documentation")
        endif()

        add_subdirectory(submodules/Device)
        set(GemmTools_INCLUDE_DIRS ${GemmTools_INCLUDE_DIRS} submodules/Device)
        set(GemmTools_COMPILER_DEFINITIONS ${GemmTools_COMPILER_DEFINITIONS} ACL_DEVICE)
        set(GemmTools_LIBRARIES ${GemmTools_LIBRARIES} device)

    else()
        message(FATAL_ERROR "Gemm Tools do not have a requested component, i.e. ${component}. \
                Please, refer to the documentation")
    endif()

endforeach()

list(APPEND GemmTools_INCLUDE_DIRS ${MKL_INCLUDE_DIRS} ${OpenBLAS_INCLUDE_DIRS} ${BLIS_INCLUDE_DIRS})
list(APPEND GemmTools_LIBRARIES ${MKL_LIBRARIES} ${OpenBLAS_LIBRARIES} ${BLIS_LIBRARIES})
list(APPEND GemmTools_COMPILER_DEFINITIONS ${MKL_COMPILER_DEFINITIONS})