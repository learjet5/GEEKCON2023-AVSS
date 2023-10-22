#!/bin/bash

## Script to patch up diff reated by `repo diff`

if [ -z "$3" ] || [ ! -e "$3" ]; then
    echo "Usages: $0 patch/unpactch workdir &lt;repo_diff_file&gt;";
    exit 0;
fi

cmd=$1
workdir=$2
cd $workdir

rm -fr /tmp/_tmp_splits*
cat $3 | csplit -qf '' -b "/tmp/_tmp_splits.%d.diff" - '/^project.*\/$/' '{*}'

working_dir=`pwd`

for proj_diff in `ls /tmp/_tmp_splits.*.diff`
do
    chg_dir=`cat $proj_diff | grep '^project.*\/$' | cut -d " " -f 2`
    echo "FILE: $proj_diff $chg_dir"
    if [ -e $chg_dir ]; then
        if [ $cmd == "patch" ]; then
            ( cd $chg_dir; cat $proj_diff | grep -v '^project.*\/$' | patch -Np1;);
        fi
        if [ $cmd == "unpatch" ]; then
            ( cd $chg_dir; cat $proj_diff | grep -v '^project.*\/$' | patch -R -Np1;);
        fi
    else
        echo "$0: Project directory $chg_dir don't exists.";
    fi
done
