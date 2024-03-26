message("Loading Dependencies URLs ...")
include(FetchContent)
include(cmake/external/helper_functions.cmake)

file(STRINGS cmake/deps.txt ONNXRUNTIME_DEPS_LIST)
foreach(ONNXRUNTIME_DEP IN LISTS ONNXRUNTIME_DEPS_LIST)
  # Lines start with "#" are comments
  if(NOT ONNXRUNTIME_DEP MATCHES "^#")
    # The first column is name
    list(POP_FRONT ONNXRUNTIME_DEP ONNXRUNTIME_DEP_NAME)
    # The second column is URL
    # The URL below may be a local file path or an HTTPS URL
    list(POP_FRONT ONNXRUNTIME_DEP ONNXRUNTIME_DEP_URL)
    set(DEP_URL_${ONNXRUNTIME_DEP_NAME} ${ONNXRUNTIME_DEP_URL})
    # The third column is SHA1 hash value
    set(DEP_SHA1_${ONNXRUNTIME_DEP_NAME} ${ONNXRUNTIME_DEP})
  endif()
endforeach()

message("Loading Dependencies ...")

if(ENABLE_PYTHON)
  FetchContent_Declare(
    pybind11_project
    URL ${DEP_URL_pybind11}
    URL_HASH SHA1=${DEP_SHA1_pybind11}
    FIND_PACKAGE_ARGS 2.6 NAMES pybind11
  )
  onnxruntime_fetchcontent_makeavailable(pybind11_project)

  if(TARGET pybind11::module)
    set(pybind11_lib pybind11::module)
  else()
    set(pybind11_dep pybind11::pybind11)
  endif()
endif()

FetchContent_Declare(
  googletest
  URL ${DEP_URL_googletest}
  URL_HASH SHA1=${DEP_SHA1_googletest}
  FIND_PACKAGE_ARGS 1.14.0...<2.0.0 NAMES GTest
)

onnxruntime_fetchcontent_makeavailable(googletest)

FetchContent_Declare(
    nlohmann_json
    URL ${DEP_URL_json}
    URL_HASH SHA1=${DEP_SHA1_json}
    FIND_PACKAGE_ARGS 3.10 NAMES nlohmann_json
)
onnxruntime_fetchcontent_makeavailable(nlohmann_json)

FetchContent_Declare(
    httplib
    URL ${DEP_URL_httplib}
    URL_HASH SHA1=${DEP_SHA1_httplib}
    FIND_PACKAGE_ARGS 0.15 NAMES httplib
)
onnxruntime_fetchcontent_makeavailable(httplib)
