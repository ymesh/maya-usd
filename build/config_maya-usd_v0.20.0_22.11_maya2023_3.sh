#
# Config Maya USD master branch
#

MAYAUSD_VER="0.20.0"
USD_VER="22.11"
RMAN_VER="24.4"
MAYA_VER="2023"
#MAYA_MINOR_VER="3"
DEVKIT_VER="2023.2"
MAYA_PYTHON_VERSION="3"

source ./env_python${MAYA_PYTHON_VERSION}/bin/activate

cur_dir=`pwd`
tmp_dir="tmp_mayausd_v${MAYAUSD_VER}_${USD_VER}_${MAYA_VER}_${MAYA_PYTHON_VERSION}"

# cd "${cur_dir}/maya-usd.dev"
# git checkout dev
# cd "${cur_dir}"

if [ ! -d $tmp_dir ]; then
  mkdir $tmp_dir
fi
mkdir -p $tmp_dir
cd $tmp_dir

deploy_root="/home/data/tools"
deploy_dir="${deploy_root}/USD/autodesk/mayausd_v${MAYAUSD_VER}_${USD_VER}_${MAYA_VER}_${MAYA_PYTHON_VERSION}"
#export OpenGL_GL_PREFERENCE=GLVND
#export OpenGL_GL_PREFERENCE=LEGACY#

#export CC=/usr/bin/clang
#export CXX=/usr/bin/clang++

export MAYA_LOCATION="/usr/autodesk/maya${MAYA_VER}"
export MAYA_DEVKIT_LOCATION="/home/data/code/LIBS/Autodesk/Maya/Maya${DEVKIT_VER}"
export QT_LOCATION="${MAYA_DEVKIT_LOCATION}/devkit/cmake/Qt5"
export PXR_USD_LOCATION="${deploy_root}/USD/pixar/USD-v${USD_VER}_rman${RMAN_VER}_ABI_0_py${MAYA_PYTHON_VERSION}"
export MaterialX_DIR="${deploy_root}/MaterialX/MaterialX-v1.38.6_ABI_0"
#export BOOST_ROOT="${MAYA_DEVKIT_LOCATION}/include/boost"
#export BOOST_LIBRARYDIR="${MAYA_LOCATION}/lib"
#
# AL plugin
#
export BOOST_ROOT="${deploy_root}/boost/boost_1_75_0_ABI_0"
export Boost_LIBRARY_DIR="${BOOST_ROOT}/lib"
export BOOST_LIBRARYDIR="${BOOST_ROOT}/lib"

export GTEST_ROOT="${deploy_root}/Google/googletest_1.11.0"

# for solving uic compile errors
# Put libicui18n.so.50, ..., etc. to /usr/local/lib
# export LD_LIBRARY_PATH=/usr/local/lib:${LD_LIBRARY_PATH}

##/cmake/Qt5"

# export QTDIR=${QT_LOCATION}
# export Qt5_DIR=${QT_LOCATION}
# export QT5_ROOT=${QT_LOCATION}

#export QT_PLUGIN_PATH=/usr/lib64/qt5/plugins
export QT_PLUGIN_PATH="${MAYA_LOCATION}/plugins"

export MAYA_DEVKIT_INC="${MAYA_DEVKIT_LOCATION}/include"
export UFE_INCLUDE_ROOT="${MAYA_DEVKIT_LOCATION}/devkit/ufe/include"
export UFE_LIB_ROOT="${MAYA_DEVKIT_LOCATION}/devkit/ufe/lib"
# export UFE_LIB_ROOT="${MAYA_LOCATION}"

echo "* MAYA_DEVKIT_LOCATION = ${MAYA_DEVKIT_LOCATION}"
# export UFE_LIB_ROOT="${MAYA_DEVKIT_LOCATION}/ufe"
# export TBB_ROOT_DIR=${MAYA_DEVKIT_LOCATION} 

# export CC=/usr/bin/clang
# export CXX=/usr/bin/clang++

#export CXXFLAGS="-std=c++14 -D_GLIBCXX_USE_CXX11_ABI=0"
#export CXXFLAGS="-std=c++14"

cmake3 -LA -G "Unix Makefiles" \
-DCMAKE_BUILD_TYPE="Release" \
-DCMAKE_INSTALL_PREFIX=${deploy_dir} \
-DBUILD_MAYAUSD_LIBRARY=ON \
-DBUILD_ADSK_PLUGIN=ON \
-DBUILD_PXR_PLUGIN=OFF \
-DBUILD_AL_PLUGIN=OFF \
-DSKIP_USDMAYA_TESTS=ON \
-DBUILD_RFM_TRANSLATORS=ON \
-DBUILD_STRICT_MODE=OFF \
-DBUILD_TESTS=OFF \
-DCMAKE_WANT_UFE_BUILD=ON \
-DBUILD_SHARED_LIBS=ON \
-DBUILD_WITH_PYTHON_3=ON \
-DBUILD_WITH_PYTHON_3_VERSION="3.9" \
-DMAYA_DEVKIT_LOCATION=${MAYA_DEVKIT_LOCATION} \
-DUFE_INCLUDE_ROOT=${UFE_INCLUDE_ROOT} \
-DUFE_LIB_ROOT=${UFE_LIB_ROOT} \
-DCMAKE_POLICY_DEFAULT_CMP0074=NEW \
-DMAYAUSD_DEFINE_BOOST_DEBUG_PYTHON_FLAG=OFF \
-DQT_LOCATION=${QT_LOCATION} \
-DCMAKE_CXX_FLAGS="-D_GLIBCXX_USE_CXX11_ABI=0" \
-DCMAKE_CXX_STANDARD="14" \
-DBOOST_ROOT=${BOOST_ROOT} \
-DBoost_LIBRARY_DIR=${Boost_LIBRARY_DIR} \
-DBoost_NO_BOOST_CMAKE=ON \
-DGTEST_ROOT=${GTEST_ROOT} \
../..

#-DBUILD_HDMAYA=ON \

# -DCMAKE_WANT_MATERIALX_BUILD=ON \
# -DMaterialX_DIR=${MaterialX_DIR} \
# 
# -DWANT_USD_RELATIVE_PATH=OFF \
# -DSKIP_USDMAYA_TESTS=ON \
# -DOpenGL_GL_PREFERENCE=GLVND \
# -DPXR_ENABLE_PYTHON_SUPPORT=ON \
# -DPXR_MAYA_TBB_BUG_WORKAROUND=ON \
# -DPXR_ENABLE_NAMESPACES=ON \
# -DPXR_USD_LOCATION=${PXR_USD_LOCATION} \
# -DPXR_BUILD_MONOLITHIC=OFF \
# -DPXR_STRICT_BUILD_MODE=OFF \
# -DPXR_VALIDATE_GENERATED_CODE=OFF \
# -DPXR_BUILD_TESTS=OFF \
# -DPXR_ENABLE_GL_SUPPORT=ON \
#-DQt5_DIR=${QT_LOCATION} \
#-DPXR_INSTALL_LOCATION=${deploy_dir} \
#CMAKE_WANT_UFE_BUILD
#-DEMBREE_INCLUDE_DIR=${EMBREE_INCLUDE_DIR} \
#-DEMBREE_LIBRARY=${EMBREE_LIBRARY} \
#-DHOUDINI_INCLUDE_DIRS=${HOUDINI_INCLUDE_DIRS} \
#-DHOUDINI_LIB_DIRS=${HOUDINI_LIB_DIRS} \
#-DPTEX_LOCATION=${PTEX_LOCATION} \
#-DOSL_LOCATION=${OSL_LOCATION} \
#-DMATERIALX_BASE_DIR=${MATERIALX_BASE_DIR} \
#-DCMAKE_C_COMPILER_ID="Clang" \
#-DCMAKE_CXX_COMPILER_ID="Clang" \
#-D_CMAKE_TOOLCHAIN_PREFIX=llvm- \
#-DMAYA_DEVKIT_INC_DIR=${MAYA_DEVKIT_INC_DIR} \

if [ $? -eq 0 ]
then
  echo "* "
  echo "* cmake config completed." 
  echo "* run \"make -C ${tmp_dir}\" (or \"make -C ${tmp_dir} install\") " 
  echo "* "
else
  echo "* "
  echo "* cmake config error!"
  echo "* "
fi

deactivate

# for uic
# export LD_LIBRARY_PATH=${MAYA_LOCATION}/lib:${LD_LIBRARY_PATH}

# !!! Put libicui18n.so.50 to /usr/local/lib & add:
# export LD_LIBRARY_PATH=/usr/local/lib:${LD_LIBRARY_PATH}
# or
# export LD_LIBRARY_PATH=/usr/autodesk/maya2022/lib:${LD_LIBRARY_PATH}
# echo $LD_LIBRARY_PATH