#!/bin/bash -x

case ${DISTRO} in
  'xenial')
    ROS_DISTRO=kinetic
    USE_DEFAULT_GAZEBO_VERSION_FOR_ROS=true
    ;;
  'bionic')
    # 9 is the default version in Bionic
    ROS_DISTRO=melodic
    USE_DEFAULT_GAZEBO_VERSION_FOR_ROS=true
    ;;
  *)
    echo "Unsupported DISTRO: ${DISTRO}"
    exit 1
esac

export GPU_SUPPORT_NEEDED=true
# the tarball shipped by vrx is generated by catkin_make and not compatible
# to be reused by catkin tools
export USE_CATKIN_MAKE=true

# Do not use the subprocess_reaper in debbuild. Seems not as needed as in
# testing jobs and seems to be slow at the end of jenkins jobs
export ENABLE_REAPER=false

DOCKER_JOB_NAME="vrx_ci"
. ${SCRIPT_DIR}/lib/boilerplate_prepare.sh
. ${SCRIPT_DIR}/lib/_gazebo_utils.sh
. ${SCRIPT_DIR}/lib/_vrx_lib.bash

export ROS_SETUP_POSTINSTALL_HOOK="""
source ./install/setup.bash || true
${GAZEBO_MODEL_INSTALLATION}

# we can not run smoke test due to problem with gazebo issue
# https://github.com/osrf/gazebo/issues/2607
# Don't add the OSRF repo to workaround on this since it brings new versions of 
# dependencies not avilable in the ros buildfarm
# \${VRX_SMOKE_TEST}
"""

# Generate the first part of the build.sh file for ROS
. ${SCRIPT_DIR}/lib/_ros_setup_buildsh.bash "vrx"

DEPENDENCY_PKGS="wget git ruby libeigen3-dev pkg-config python3 ros-${ROS_DISTRO}-gazebo-plugins ros-${ROS_DISTRO}-gazebo-ros ros-${ROS_DISTRO}-hector-gazebo-plugins ros-${ROS_DISTRO}-joy ros-${ROS_DISTRO}-joy-teleop ros-${ROS_DISTRO}-key-teleop ros-${ROS_DISTRO}-robot-localization ros-${ROS_DISTRO}-robot-state-publisher ros-${ROS_DISTRO}-rviz ros-${ROS_DISTRO}-ros-base ros-${ROS_DISTRO}-teleop-tools ros-${ROS_DISTRO}-teleop-twist-keyboard ros-${ROS_DISTRO}-velodyne-simulator ros-${ROS_DISTRO}-xacro ros-${ROS_DISTRO}-rqt ros-${ROS_DISTRO}-rqt-common-plugins protobuf-compiler"

USE_ROS_REPO=true

. ${SCRIPT_DIR}/lib/docker_generate_dockerfile.bash
. ${SCRIPT_DIR}/lib/docker_run.bash
