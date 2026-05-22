cmake_minimum_required(VERSION 3.10)

if(POLICY CMP0141)
  cmake_policy(SET CMP0141 NEW)
  set(CMAKE_MSVC_DEBUG_INFORMATION_FORMAT "$<IF:$<AND:$<C_COMPILER_ID:MSVC>,$<CXX_COMPILER_ID:MSVC>>,$<$<CONFIG:Debug,RelWithDebInfo>:EditAndContinue>,$<$<CONFIG:Debug,RelWithDebInfo>:ProgramDatabase>>")
endif()

project("ziovpo-pract2" LANGUAGES C CXX)

add_executable(ziovpo-pract2 WIN32
  ziovpo-practs.cpp
  ziovpo-common.h
  ziovpo-common.cpp
  service-control_c.c
)
target_compile_definitions(ziovpo-pract2 PRIVATE UNICODE _UNICODE)
target_link_libraries(ziovpo-pract2 PRIVATE user32 shell32 advapi32 rpcrt4)
set_target_properties(ziovpo-pract2 PROPERTIES CXX_STANDARD 20)

add_executable(ziovpo-pract2-service
  ziovpo-service.cpp
  ziovpo-common.h
  ziovpo-common.cpp
  service-control_s.c
)
target_compile_definitions(ziovpo-pract2-service PRIVATE UNICODE _UNICODE)
target_link_libraries(ziovpo-pract2-service PRIVATE advapi32 rpcrt4 wtsapi32 userenv)
set_target_properties(ziovpo-pract2-service PROPERTIES CXX_STANDARD 20)
