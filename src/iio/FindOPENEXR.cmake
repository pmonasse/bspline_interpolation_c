#
# Try to find OpenEXR's libraries, and include path.
# Once done this will define:
#
# OPENEXR_FOUND = OpenEXR found. 
# OPENEXR_INCLUDE_PATHS = OpenEXR include directories.
# OPENEXR_LIBRARIES = libraries that are needed to use OpenEXR.
# 

find_package(ZLIB)
if(ZLIB_FOUND)
   set(LIBRARY_PATHS 
      /usr/lib
      /usr/local/lib
      /sw/lib
      /opt/local/lib
      $ENV{PROGRAM_FILES}/OpenEXR/lib/static)

   find_path(OPENEXR_INCLUDE_PATH ImfRgbaFile.h
      PATH_SUFFIXES OpenEXR
      /usr/include
      /usr/local/include
      /sw/include
      /opt/local/include)

   find_library(OPENEXR_HALF_LIBRARY 
      NAMES Half
      PATHS ${LIBRARY_PATHS})

   find_library(OPENEXR_IEX_LIBRARY 
      NAMES Iex
      PATHS ${LIBRARY_PATHS})

   find_library(OPENEXR_IMATH_LIBRARY
      NAMES Imath
      PATHS ${LIBRARY_PATHS})

   find_library(OPENEXR_ILMIMF_LIBRARY
      NAMES IlmImf
      PATHS ${LIBRARY_PATHS})

   find_library(OPENEXR_ILMTHREAD_LIBRARY
      NAMES IlmThread
      PATHS ${LIBRARY_PATHS})
endif()

# message(STATUS ${OPENEXR_IMATH_LIBRARY} ${OPENEXR_ILMIMF_LIBRARY}
#                ${OPENEXR_IEX_LIBRARY} ${OPENEXR_HALF_LIBRARY}
#                ${OPENEXR_ILMTHREAD_LIBRARY})

if(OPENEXR_INCLUDE_PATH AND OPENEXR_IMATH_LIBRARY AND OPENEXR_ILMIMF_LIBRARY AND
   OPENEXR_IEX_LIBRARY AND OPENEXR_HALF_LIBRARY)
   set(OPENEXR_FOUND PARENT_SCOPE TRUE)
   set(OPENEXR_INCLUDE_PATHS ${OPENEXR_INCLUDE_PATH}
       CACHE STRING "The include paths needed to use OpenEXR")
   set(OPENEXR_LIBRARIES ${OPENEXR_IMATH_LIBRARY} ${OPENEXR_ILMIMF_LIBRARY}
                         ${OPENEXR_IEX_LIBRARY} ${OPENEXR_HALF_LIBRARY}
                         ${OPENEXR_ILMTHREAD_LIBRARY} ZLIB::ZLIB}
       CACHE STRING "The libraries needed to use OpenEXR")
   mark_as_advanced(OPENEXR_INCLUDE_PATHS OPENEXR_LIBRARIES
                    OPENEXR_ILMIMF_LIBRARY OPENEXR_IMATH_LIBRARY
                    OPENEXR_IEX_LIBRARY OPENEXR_HALF_LIBRARY)
   add_library(OPENEXR::OPENEXR INTERFACE IMPORTED)
   set_target_properties(OPENEXR::OPENEXR PROPERTIES
     INTERFACE_INCLUDE_DIRECTORIES "${OPENEXR_INCLUDE_PATHS}"
     INTERFACE_LINK_LIBRARIES "${OPENEXR_LIBRARIES}")
endif()

if(OPENEXR_FOUND)
   if(NOT OPENEXR_FIND_QUIETLY)
      message(STATUS "Found OpenEXR: ${OPENEXR_ILMIMF_LIBRARY}")
   endif()
else()
   if(OPENEXR_FIND_REQUIRED)
      message(FATAL_ERROR "Could not find OpenEXR library")
   endif()
endif()
