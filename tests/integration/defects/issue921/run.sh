#!/usr/bin/env bash

HT_HOME=${INSTALL_DIR:-"/opt/hypertable/current"}
SCRIPT_DIR=`dirname $0`

echo "======================="
echo "Defect #921"
echo "======================="

echo "starting HT w/ Thrift"
$HT_HOME/bin/start-test-servers.sh --clear

echo "preparing the table"
cat ${SCRIPT_DIR}/test.hql | $HT_HOME/bin/ht hypertable \
        --namespace / --no-prompt --test-mode \
        > test.output

#
# javac/java failed on test01 with this:
#
# Exception in thread "main" java.lang.IncompatibleClassChangeError: class
# org.hypertable.thriftgen.ClientService$Client has interface
# org.apache.thrift.TServiceClient as super class
#
# To fix this, manually add the thriftbroker-*.jar as the first jar file
# in the classpath
#
echo "compiling"
CP=$HT_HOME/lib/java/libthrift-0.8.0.jar:$HT_HOME/lib/java/*:$SCRIPT_DIR:.
javac -classpath $CP -d . $SCRIPT_DIR/TestInputOutput.java

echo "running"
java -ea -classpath $CP TestInputOutput >> test.output

diff test.output $SCRIPT_DIR/test.golden
if [ "$?" -ne "0" ]
then
  echo "output differs"
  exit 1
fi

echo "success"
exit 0
