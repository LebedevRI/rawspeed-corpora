#!/bin/sh

# MIT License
#
# Copyright (c) 2017 Roman Lebedev
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

set -ex

# WARNING: this script will not work for you, the access is restricted.

cd "$(dirname "$0")"

PROJ_NAME="librawspeed"
SRC_TOP="gs://${PROJ_NAME}-corpus.clusterfuzz-external.appspot.com/libFuzzer/"
ALL_CORPORAS="$(gsutil ls ${SRC_TOP})"

for CORPORA in ${ALL_CORPORAS}; do
  # so each dir is the name of the appropriate fuzzer
  name="${CORPORA##"${SRC_TOP}"}"
  name="${name##"${PROJ_NAME}_"}"
  mkdir -p "${name}"

  gsutil -m rsync "${CORPORA}" "${name}"
done

# used for detection of rootdir
date +%s > timestamp.txt

SFL="filelist.sha1"
rm -f $SFL
find -type f -not -iname "$SFL" -exec shasum -a1 -b "{}" + > "$SFL"
