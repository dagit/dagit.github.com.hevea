#!/bin/bash
PAGES_PATTERN="([0-9]+) of [0-9]+ pages converted in .* seconds"

DOC=${1}
DOC_BASENAME=$(basename ${DOC} .html)

dvisvgm -p 1- -o %f-%p.svg -n "${DOC_BASENAME}.image.dvi" 2>&1 \
            | tee "${DOC_BASENAME}.image.dvisvgm.log"
# These should always be sorted
SVG_IMAGES=($(grep -oE "${DOC_BASENAME}\.image-[0-9]+\.svg" "${DOC_BASENAME}.image.dvisvgm.log"))

# Let's hope these match up with the svgs above...
PNG_IMAGES=($(grep -oE "${DOC_BASENAME}([0-9]+)\.(png|gif)" "${DOC}"))

# Loop over both arrays of image names and do a substitution.
# We assume that there is an equal number of images in both lists
if [ ${#SVG_IMAGES[@]} != ${#PNG_IMAGES[@]} ]
then
  echo "Inequal image lists. Aborting"
  exit -1
fi
for i in $(seq 0 $((${#SVG_IMAGES[@]} - 1)))
do
  sed -e "s/${PNG_IMAGES[$i]}/${SVG_IMAGES[$i]}/g" "${DOC}" > "${DOC}.tmp"
  mv "${DOC}.tmp" "${DOC}"
  # delete the image now that it's no longer needed
  rm -f "${PNG_IMAGES[$i]}"
done
