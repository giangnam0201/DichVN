cmake_minimum_required(VERSION 3.14)

set(EPHEMERAL_DIR "${CMAKE_CURRENT_SOURCE_DIR}/ephemeral")

include(${EPHEMERAL_DIR}/generated_config.cmake OPTIONAL)

set(FLUTTER_TARGET "${EPHEMERAL_DIR}/flutter_windows.dll")

add_custom_command(
  OUTPUT ${FLUTTER_TARGET} ${FLUTTER_TARGET}.lib
  COMMAND ${CMAKE_COMMAND} -E echo "Flutter library not found"
)

add_custom_target(flutter_assemble DEPENDS
  "${FLUTTER_TARGET}"
)

add_library(flutter INTERFACE)
target_include_directories(flutter INTERFACE
  "${EPHEMERAL_DIR}"
)
target_link_libraries(flutter INTERFACE "${FLUTTER_TARGET}.lib")
add_dependencies(flutter flutter_assemble)

add_library(flutter_wrapper_app STATIC
  "${EPHEMERAL_DIR}/cpp_client_wrapper/flutter_engine.cc"
  "${EPHEMERAL_DIR}/cpp_client_wrapper/flutter_view_controller.cc"
  "${EPHEMERAL_DIR}/cpp_client_wrapper/standard_codec.cc"
)
apply_standard_settings(flutter_wrapper_app)
target_include_directories(flutter_wrapper_app PUBLIC
  "${EPHEMERAL_DIR}/cpp_client_wrapper/include"
)
target_link_libraries(flutter_wrapper_app PUBLIC flutter)
target_compile_definitions(flutter_wrapper_app PUBLIC FLUTTER_DESKTOP_LIBRARY)
