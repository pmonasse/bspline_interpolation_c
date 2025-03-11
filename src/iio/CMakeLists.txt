cmake_minimum_required(VERSION 3.13) #specify the required version of cmake
project(IIO LANGUAGES C)             #give a name to the project/solution

# ADD LOCAL PATH TO SEARCH MODULES
list(APPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_SOURCE_DIR}")

# IIO
#
#
add_library(IIOLIB iio.h iio.c)
set_target_properties(IIOLIB PROPERTIES
  INTERFACE_INCLUDE_DIRECTORIES "${CMAKE_CURRENT_SOURCE_DIR}")
if(CMAKE_CXX_COMPILER_ID MATCHES "(GNU)|(CLANG)")
   target_compile_options(IIOLIB PRIVATE "-Wall -Wextra")
endif()
if(${CMAKE_SYSTEM_NAME} MATCHES "Linux")
   target_compile_definitions(IIOLIB PRIVATE I_CAN_HAS_LINUX)
endif()

# IF AVAILABLE USE OPENEXR
find_package(OPENEXR)
if (OPENEXR_FOUND)
   target_compile_definitions(IIOLIB PRIVATE I_CAN_HAS_LIBEXR)
   target_link_libraries(IIOLIB OPENEXR::OPENEXR)
endif()
# OTHER LIBRARIES
find_package(TIFF)
if(TIFF_FOUND)
   target_compile_definitions(IIOLIB PRIVATE I_CAN_HAS_LIBTIFF)
   target_link_libraries(IIOLIB PRIVATE TIFF::TIFF)
endif()
find_package(JPEG)
if(JPEG_FOUND)
   target_compile_definitions(IIOLIB PRIVATE I_CAN_HAS_LIBJPEG)
   target_link_libraries(IIOLIB PRIVATE JPEG::JPEG)
endif()
FIND_PACKAGE(PNG)
if(PNG_FOUND)
   target_compile_definitions(IIOLIB PRIVATE I_CAN_HAS_LIBPNG)
   target_link_libraries(IIOLIB PRIVATE PNG::PNG)
endif()

#### EXAMPLE PROGRAMS
###
###
###add_executable (iio iio_test.c)
###target_link_libraries(iio IIOLIB)
###
###add_executable (iion iio_test_named.c)
###target_link_libraries(iion IIOLIB)
