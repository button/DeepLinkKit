#!/bin/sh

FOCUS="fit\(|fdescribe\(|fcontext\("
find "${SRCROOT}/Tests" \( -name "*.m" \) -print0 | xargs -0 egrep --with-filename --line-number --only-matching "($FOCUS).*\$" | perl -p -e "s/($FOCUS)/ warning: \$1/"
