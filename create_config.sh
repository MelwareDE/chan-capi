#!/bin/sh
#
# create_config.sh
#
# Script to create config.h for compatibility with
# different asterisk versions.
#
# (C) 2005 Cytronics & Melware
# Armin Schindler <armin@melware.de>
#

CONFIGFILE="config.h"
rm -f "$CONFIGFILE"

if [ $# -lt 1 ]; then
	echo >&2 "Missing argument"
	exit 1
fi

INCLUDEDIR="$1/asterisk"

if [ ! -d "$INCLUDEDIR" ]; then
	echo >&2 "Include directory '$INCLUDEDIR' does not exist"
	exit 1
fi

echo "Checking Asterisk version..."

echo "/*" >$CONFIGFILE
echo " * automatically generated by $0 `date`" >>$CONFIGFILE
echo " */" >>$CONFIGFILE
echo >>$CONFIGFILE
echo "#ifndef CHAN_CAPI_CONFIG_H" >>$CONFIGFILE
echo "#define CHAN_CAPI_CONFIG_H" >>$CONFIGFILE
echo >>$CONFIGFILE

if grep -q "struct ast_channel_tech" $INCLUDEDIR/channel.h; then
	echo "#define CC_AST_HAVE_TECH_PVT" >>$CONFIGFILE
	echo " * found 'struct ast_channel_tech'"
else
	echo "#undef CC_AST_HAVE_TECH_PVT" >>$CONFIGFILE
	echo " * no 'struct ast_channel_tech', using old pvt"
fi

if grep -q "ast_bridged_channel" $INCLUDEDIR/channel.h; then
	echo "#define CC_AST_HAS_BRIDGED_CHANNEL" >>$CONFIGFILE
	echo " * found 'ast_bridged_channel'"
else
	echo "#undef CC_AST_HAS_BRIDGED_CHANNEL" >>$CONFIGFILE
	echo " * no 'ast_bridged_channel'"
fi

if grep -q "ast_bridge_result" $INCLUDEDIR/channel.h; then
	echo "#define CC_AST_HAS_BRIDGE_RESULT" >>$CONFIGFILE
	echo " * found 'ast_bridge_result'"
else
	echo "#undef CC_AST_HAS_BRIDGE_RESULT" >>$CONFIGFILE
	echo " * no 'ast_bridge_result'"
fi

if grep -q "struct ast_channel \*\*rc, int timeoutms" $INCLUDEDIR/channel.h; then
	echo "#define CC_AST_BRIDGE_WITH_TIMEOUTMS" >>$CONFIGFILE
	echo " * found bridge with timeoutms"
else
	echo "#undef CC_AST_BRIDGE_WITH_TIMEOUTMS" >>$CONFIGFILE
	echo " * no timeoutms in bridge"
fi

if grep -q "ast_dsp_process*needlock" $INCLUDEDIR/dsp.h; then
	echo "#define CC_AST_DSP_PROCESS_NEEDLOCK" >>$CONFIGFILE
	echo " * ast_dsp_process() needs 'needlock'"
else
	echo "#undef CC_AST_DSP_PROCESS_NEEDLOCK" >>$CONFIGFILE
	echo " * ast_dsp_process() without 'needlock'"
fi

if grep -q "struct ast_callerid" $INCLUDEDIR/channel.h; then
	echo "#define CC_AST_CHANNEL_HAS_CID" >>$CONFIGFILE
	echo " * found 'struct ast_callerid'"
else
	echo "#undef CC_AST_CHANNEL_HAS_CID" >>$CONFIGFILE
	echo " * no 'struct ast_callerid'"
fi

if grep -q "struct timeval delivery" $INCLUDEDIR/frame.h; then
	echo "#define CC_AST_FRAME_HAS_TIMEVAL" >>$CONFIGFILE
	echo " * found 'struct timeval delivery'"
else
	echo "#undef CC_AST_FRAME_HAS_TIMEVAL" >>$CONFIGFILE
	echo " * no 'struct timeval delivery'"
fi

if grep -q "transfercapability" $INCLUDEDIR/channel.h; then
	echo "#define CC_AST_CHANNEL_HAS_TRANSFERCAP" >>$CONFIGFILE
	echo " * found 'transfercapability'"
else
	echo "#undef CC_AST_CHANNEL_HAS_TRANSFERCAP" >>$CONFIGFILE
	echo " * no 'transfercapability'"
fi

if grep -q "ast_config_load" $INCLUDEDIR/config.h; then
	echo " * found 'ast_config_load'"
else
	echo "#define ast_config_load(x) ast_load(x)" >>$CONFIGFILE
	echo "#define ast_config_destroy(x) ast_destroy(x)" >>$CONFIGFILE
	echo " * no 'ast_config_load'"
fi

if grep -q "AST_CONTROL_HOLD" $INCLUDEDIR/frame.h; then
	echo "#define CC_AST_CONTROL_HOLD" >>$CONFIGFILE
	echo " * found 'AST_CONTROL_HOLD'"
else
	echo "#undef CC_AST_CONTROL_HOLD" >>$CONFIGFILE
	echo " * no 'AST_CONTROL_HOLD'"
fi

if [ -f "$INCLUDEDIR/devicestate.h" ]; then
	echo "#undef CC_AST_NO_DEVICESTATE" >>$CONFIGFILE
	echo " * found 'devicestate.h'"
else
	echo "#define CC_AST_NO_DEVICESTATE" >>$CONFIGFILE
	echo " * no 'devicestate.h'"
fi

if [ -f "$INCLUDEDIR/strings.h" ]; then
	echo "#undef CC_AST_NO_STRINGS" >>$CONFIGFILE
	echo " * found 'strings.h'"
else
	echo "#define CC_AST_NO_STRINGS" >>$CONFIGFILE
	echo " * no 'strings.h'"
fi

if grep -q " Type of channel " $INCLUDEDIR/channel.h; then
	echo "#define CC_AST_HAS_TYPE_IN_CHANNEL" >>$CONFIGFILE
	echo " * found 'type' in ast_channel"
else
	echo "#undef CC_AST_HAS_TYPE_IN_CHANNEL" >>$CONFIGFILE
	echo " * no 'type' in ast_channel"
fi

if grep -q "AST_STRING_FIELD(name)" $INCLUDEDIR/channel.h; then
	echo "#define CC_AST_HAS_STRINGFIELD_IN_CHANNEL" >>$CONFIGFILE
	echo " * found stringfield in ast_channel"
else
	echo "#undef CC_AST_HAS_STRINGFIELD_IN_CHANNEL" >>$CONFIGFILE
	echo " * no stringfield in ast_channel"
fi

echo "" >>$CONFIGFILE
echo "#endif /* CHAN_CAPI_CONFIG_H */" >>$CONFIGFILE
echo "" >>$CONFIGFILE

echo "config.h complete."
exit 0

