macro(fetch_googletest)

    if (NOT GTEST_FOUND)
        # First see if we can find a gtest that was downloaded and built.
        if (NOT GOOGLETEST_BUILD_ROOT)
            set(GOOGLETEST_BUILD_ROOT ${CMAKE_CURRENT_BINARY_DIR})
        endif()
        if (NOT GTEST_ROOT)
            set(GTEST_ROOT "${GOOGLETEST_BUILD_ROOT}/googletest-install")
        endif()
        message ("* GTEST_ROOT = ${GTEST_ROOT}")
        message ("* GTest_DIR = ${GTest_DIR}")
        message ("* GOOGLETEST_BUILD_ROOT = ${GOOGLETEST_BUILD_ROOT}")
        find_package(GTest)
        message ("* GTEST_INCLUDE_DIRS= ${GTEST_INCLUDE_DIRS}")
        message ("* GTEST_LIBRARIES = ${GTEST_LIBRARIES}")
        # find_package(GTest QUIET)
        # At this point GTEST_FOUND is set to True in Release but False in Debug.
    endif()

    if (NOT GTEST_FOUND)
        #======================================================================
        # Download and unpack googletest at configure time.  Adapted from
        #
        # https://github.com/abseil/googletest/blob/master/googletest/README.md
        #
        # PPT, 22-Nov-2018.

        # Immediately convert CMAKE_MAKE_PROGRAM to forward slashes (if required).
        # Attempting to do so in execute_process fails with string invalid escape
        # sequence parsing errors.  PPT, 22-Nov-2018.
        file(TO_CMAKE_PATH ${CMAKE_MAKE_PROGRAM} CMAKE_MAKE_PROGRAM)

        # Set some options used when compiling googletest.
        set(CMAKE_CXX_STANDARD 11)
        set(CMAKE_CXX_EXTENSIONS OFF)
        set(CMAKE_CXX_STANDARD_REQUIRED ON)
        if (${CMAKE_SYSTEM_NAME} MATCHES "Linux")
            # In gcc 11 there was a new warning (about uninit variable) in googletest.
            # Since we have warnings as errors, this causes build error.
            # Simply disable all warnings in googletest since we won't fix them anyways.
            # We will just update to newer version, if required.
            set(disable_all_warnings_flag -w)

            # set(glibcxx_abi -D_GLIBCXX_USE_CXX11_ABI=$<IF:$<BOOL:${MAYA_LINUX_BUILT_WITH_CXX11_ABI}>,1,0>)
            set(glibcxx_abi -D_GLIBCXX_USE_CXX11_ABI=0)
            message("* glibcxx_abi = ${glibcxx_abi}")
        endif()

        if (GOOGLETEST_SRC_DIR)
            configure_file(cmake/googletest_src.txt.in ${GOOGLETEST_BUILD_ROOT}/googletest-config/CMakeLists.txt)
        else()
            configure_file(cmake/googletest_download.txt.in ${GOOGLETEST_BUILD_ROOT}/googletest-config/CMakeLists.txt)
        endif()

        message(STATUS "========== Installing GoogleTest... ==========")
           execute_process(COMMAND "${CMAKE_COMMAND}" -G "${CMAKE_GENERATOR}" -DCMAKE_MAKE_PROGRAM=${CMAKE_MAKE_PROGRAM} .
        RESULT_VARIABLE result
        WORKING_DIRECTORY ${GOOGLETEST_BUILD_ROOT}/googletest-config )
        if(result)
            message(FATAL_ERROR "CMake step for googletest failed: ${result}")
        endif()

        execute_process(COMMAND "${CMAKE_COMMAND}" --build . --config ${CMAKE_BUILD_TYPE}
        RESULT_VARIABLE result
        WORKING_DIRECTORY ${GOOGLETEST_BUILD_ROOT}/googletest-config )
        if(result)
            message(FATAL_ERROR "Build step for googletest failed: ${result}")
        endif()
        message(STATUS "========== ...  GoogleTest installed. ==========")

        set(GTEST_ROOT "${GOOGLETEST_BUILD_ROOT}/googletest-install" CACHE PATH "GoogleTest installation root")
    endif()

    # FindGTest should get call after GTEST_ROOT is set
    set (GTest_DIR "${GTEST_ROOT}/lib64/cmake/GTest")
    message ("* GTEST_ROOT = ${GTEST_ROOT}")
    message ("* GTest_DIR = ${GTest_DIR}")
    
    # find_package(GTest NO_DEFAULT_PATH)
    
    set (GTEST_INCLUDE_DIRS "${GTEST_ROOT}/include")
    set (GTEST_LIBRARIES 
        "${GTEST_ROOT}/lib64/libgtest.so" 
        "${GTEST_ROOT}/lib64/libgtest_main.so"
    )
    
    set (GTEST_LIBRARY "${GTEST_ROOT}/lib64/libgtest.so")
    
    message ("* GTEST_INCLUDE_DIRS= ${GTEST_INCLUDE_DIRS}")
    message ("* GTEST_LIBRARIES = ${GTEST_LIBRARIES}")

    # https://gitlab.kitware.com/cmake/cmake/issues/17799
    # FindGtest is buggy when dealing with Debug build.
    if (CMAKE_BUILD_TYPE MATCHES Debug AND GTEST_FOUND MATCHES FALSE)
        # FindGTest.cmake is buggy when looking for only debug config (it expects both).
        # So when in debug we set the required gtest vars to the debug libs it would have
        # found in the find_package(GTest) above. Then we find again. This will then
        # properly set all the vars and import targets for just debug.
        set(GTEST_LIBRARY ${GTEST_LIBRARY_DEBUG})
        set(GTEST_MAIN_LIBRARY ${GTEST_MAIN_LIBRARY_DEBUG})
        find_package(GTest QUIET REQUIRED)
    endif()

    # On Windows shared libraries are installed in 'bin' instead of 'lib' directory.
    if(${CMAKE_SYSTEM_NAME} MATCHES "Windows")
        set(GTEST_SHARED_LIB_NAME "gtest.dll")
        if(CMAKE_BUILD_TYPE MATCHES Debug)
            set(GTEST_SHARED_LIB_NAME "gtestd.dll")
        endif()
        install(FILES "${GTEST_ROOT}/bin/${GTEST_SHARED_LIB_NAME}" DESTINATION "${CMAKE_INSTALL_PREFIX}/lib/gtest")
    else()
        message ("* GTEST_LIBRARY = ${GTEST_LIBRARY}")
        message ("* DESTINATION = ${CMAKE_INSTALL_PREFIX}/lib/gtest")
        install(FILES "${GTEST_LIBRARY}" DESTINATION "${CMAKE_INSTALL_PREFIX}/lib/gtest")
    endif()

endmacro()
