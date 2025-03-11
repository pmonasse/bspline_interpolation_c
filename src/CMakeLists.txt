cmake_minimum_required(VERSION 3.13)
project(Splinter LANGUAGES C)

# Enable C99
set(CMAKE_C_STANDARD 99)

option(EXTRAPOLATE "Extrapolate for pixels outside image" OFF)

set(GSL_FIND_QUIETLY TRUE)
find_package(GSL)

# IIO
add_subdirectory(iio)

add_library(Splinter bspline.c bspline.h splinter.c splinter.h)
if(GSL_FOUND)
  target_compile_definitions(Splinter PRIVATE GSL_SUPPORT)
  target_link_libraries(Splinter PRIVATE GSL::gsl)
endif()
target_link_libraries(Splinter PRIVATE m)
if(EXTRAPOLATE)
  target_compile_definitions(Splinter PRIVATE EXTRAPOLATE)
endif()

add_executable(bspline bspline_main.c splinter_transform.c homography_tools.c)
target_link_libraries(bspline PRIVATE IIOLIB Splinter)

add_executable(hom4p hom4p.c homography_tools.c)
target_link_libraries(hom4p PRIVATE m)

if(CMAKE_CXX_COMPILER_ID MATCHES "(GNU)|(CLANG)")
  target_compile_options(Splinter "-Wall -Wextra")
  target_compile_options(bspline "-Wall -Wextra")
  target_compile_options(hom4p "-Wall -Wextra")
endif()

if(GSL_FOUND)
  add_executable (compute_bspline compute_bspline.c bspline.c bspline.h)
  target_compile_definitions(compute_bspline PRIVATE GSL_SUPPORT)
  target_link_libraries(compute_bspline PRIVATE GSL::gsl m)
endif()
