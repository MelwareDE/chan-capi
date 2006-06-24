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

if grep -q "AST_STRING_FIELD(name)" $INCLUDEDIR/channel.h; then
	echo "#define CC_AST_HAS_STRINGFIELD_IN_CHANNEL" >>$CONFIGFILE
	echo " * found stringfield in ast_channel"
else
	echo "#undef CC_AST_HAS_STRINGFIELD_IN_CHANNEL" >>$CONFIGFILE
	echo " * no stringfield in ast_channel"
fi

if grep -q "const indicate.*datalen" $INCLUDEDIR/channel.h; then
	echo "#define CC_AST_HAS_INDICATE_DATA" >>$CONFIGFILE
	echo " * found 'indicate' with data"
else
	echo "#undef CC_AST_HAS_INDICATE_DATA" >>$CONFIGFILE
	echo " * no data on 'indicate'"
fi

echo "" >>$CONFIGFILE
echo "#endif /* CHAN_CAPI_CONFIG_H */" >>$CONFIGFILE
echo "" >>$CONFIGFILE

echo "config.h complete."
exit 0

