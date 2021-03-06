GAZEBO_RUNTIME_TEST="""
echo '# BEGIN SECTION: test the script'
wget -P /tmp/ https://github.com/osrf/gazebo_models/archive/master.tar.gz
mkdir -p ~/.gazebo/models
tar -xvf /tmp/master.tar.gz -C ~/.gazebo/models --strip 1
rm /tmp/master.tar.gz

TEST_START=\`date +%s\`
timeout --preserve-status 180 gazebo --verbose || true
TEST_END=\`date +%s\`
DIFF=\`echo \"\$TEST_END - \$TEST_START\" | bc\`

if [ \$DIFF -lt 180 ]; then
   echo 'The test took less than 180s. Something bad happened'
   exit 1
fi
echo '# END SECTION'
"""

GAZEBO_MODEL_INSTALLATION="""
wget -q https://github.com/osrf/gazebo_models/archive/master.tar.gz -O /tmp/master.tar.gz
mkdir -p ~/.gazebo/models
tar -xf /tmp/master.tar.gz -C ~/.gazebo/models --strip 1 >/dev/null 2>&1
rm /tmp/master.tar.gz"""

IGN_GAZEBO_RUNTIME_TEST="""
echo '# BEGIN SECTION: test the script'
TEST_START=\`date +%s\`
timeout --preserve-status 180 ign gazebo -v -r camera_sensor.sdf || true
TEST_END=\`date +%s\`
DIFF=\`echo \"\$TEST_END - \$TEST_START\" | bc\`

if [ \$DIFF -lt 180 ]; then
   echo 'The test took less than 180s. Something bad happened'
   exit 1
fi
echo '# END SECTION'
"""
