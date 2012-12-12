#!/bin/bash
PAGES_PATTERN="([0-9]+) of [0-9]+ pages converted in .* seconds"

DOC=${1}
DOC_BASENAME=$(basename -s .html ${DOC})

NUM_DIGITS=$(dvisvgm -p 1- -o %f-%p.svg -n "${DOC_BASENAME}.image.dvi" 2>&1 \
					  | tee "${DOC_BASENAME}.image.dvisvgm.log" 2>&1                  \
						| grep -E "${PAGES_PATTERN}"                                    \
						| sed -Ee "s/${PAGES_PATTERN}/\1/" | tr -d '\n' | wc -c)
# This strips any leading spaces from the above command
NUM_DIGITS=$(echo -n ${NUM_DIGITS})

IMAGE_NUMBERS=$(grep -E "${DOC_BASENAME}([0-9]+)\.png" "${DOC}" | sed -Ee "s/.*${DOC_BASENAME}([0-9]+)\.png.*/\1/g" | tr '\n' ' ')

for I in ${IMAGE_NUMBERS}
do
  # Need to drop leading 0s
  NUM=$(echo -n ${I} | sed -Ee 's/^0+//g')
  NEW_I=$(printf "%0${NUM_DIGITS}d" ${NUM})
  # invoking sed for each image is potentially very slow...
  sed -Ee "s/${DOC_BASENAME}${I}\.png/${DOC_BASENAME}\.image-${NEW_I}\.svg/g" "${DOC}" > "${DOC}.tmp"
  mv "${DOC}.tmp" "${DOC}"
  # delete the image now that it's no longer needed
  rm -f "${DOC_BASENAME}${I}.png"
done
