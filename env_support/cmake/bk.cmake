# LVGL component registration for BEKEN Armino build system
# Modeled after env_support/cmake/esp.cmake

file(GLOB_RECURSE SOURCES ${LVGL_ROOT_DIR}/src/*.c)

# Exclude ThorVG C++ sources — they need special handling and are typically
# not used on embedded BK targets.
file(GLOB_RECURSE THORVG_CPP_SOURCES ${LVGL_ROOT_DIR}/src/libs/thorvg/*.cpp)
if(THORVG_CPP_SOURCES)
    list(REMOVE_ITEM SOURCES ${THORVG_CPP_SOURCES})
endif()

# Optionally include demos / examples (controlled by Kconfig)
if(CONFIG_LV_BUILD_EXAMPLES)
    file(GLOB_RECURSE EXAMPLE_SOURCES ${LVGL_ROOT_DIR}/examples/*.c)
    set_source_files_properties(${EXAMPLE_SOURCES} COMPILE_FLAGS "-Wno-unused-variable -Wno-format")
endif()

if(CONFIG_LV_BUILD_DEMOS)
    file(GLOB_RECURSE DEMO_SOURCES ${LVGL_ROOT_DIR}/demos/*.c)
endif()

message("lvgl lvgl lvgl")

armino_component_register(
    SRCS ${SOURCES} ${EXAMPLE_SOURCES} ${DEMO_SOURCES}
    INCLUDE_DIRS
        ${LVGL_ROOT_DIR}
        ${LVGL_ROOT_DIR}/src
        ${LVGL_ROOT_DIR}/../
#    PRIV_REQUIRES include
)

# Let LVGL pick up lv_conf.h via LV_CONF_INCLUDE_SIMPLE
target_compile_definitions(${COMPONENT_LIB} PUBLIC "-DLV_CONF_INCLUDE_SIMPLE")

# Optimise LVGL with -O2 (matches the old BK lvgl component behaviour of -O3,
# but -O2 is safer for code-size on constrained flash).
target_compile_options(${COMPONENT_LIB} PRIVATE -O2)
