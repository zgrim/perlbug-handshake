#! /bin/bash
ORIG_CWD=$PWD
export LD="gcc"
export CC="gcc"

die() {
    printf -- "\nFATAL: %s\n\n" "$*" >&2
    exit -1
}

export STATICPERLRC="$ORIG_CWD/.staticperlrc"
if [ ! -f "$STATICPERLRC" ]; then
    die "run this alongside .staticperlrc"
fi
source "$STATICPERLRC"

# build a static perl with modules and stuff
./staticperl install || die "staticperl 'install' failed"

/bin/rm -f bundle.*
CMD="./staticperl mkperl --incglob '*' --ignore-env --strip pod -vvvvvvvvvvvvvvvvvvvv --usepacklists"
eval $CMD || die "staticperl 'mkperl' failed"

RV=$(./perl -e'$v = $^V =~ s/[^ \d\.]+//rg; print $v')
if [ "$RV" != "$PERL_VERSION" ]; then
    die "perl version mismatch :: [resulted=$RV] vs [wanted=$PERL_VERSION]"
fi

echo "perl $RV" > VERSIONS
mv perl "pvm.$RV"

# extract modules from perllocal.pod
PERLLOCALPOD="$PWD/tmp/perl/lib/perllocal.pod"
[ -f "$PERLLOCALPOD" ] || die "no perllocal.pod at $PERLLOCALPOD"

PERLDOC="$PWD/tmp/perl/bin/perldoc"
[ -x "$PERLDOC" ] || die "no perldoc ?!"
$PERLDOC -TFt "$PERLLOCALPOD" | perl -ane'/module/i && print "$F[-1]"; /"version: (.+?)"/i && print " $1\n\n"' | sort -u | grep -v "^$" &>> VERSIONS

echo built-in versions
cat VERSIONS
echo 

echo now run ./pvm.$RV -MDigest::xxHash -e1

# ex:ft=sh:tw=200:sw=4
