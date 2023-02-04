if [[ -z ${PACKER_OUTPUT_FOLDER} ]]; then
    echo "ERROR: this script can only be executed if you've previously executed \`source run_packer.sh\`, however it looks like you haven't done so."
    return
fi

boxfile="${PACKER_OUTPUT_FOLDER}/${packer_template%.*}_${packer_builder_selected}.box"
boxname="local/${packer_template%.*}"

name="local/$VM_NAME"
description="$(cat "${packer_template}" | jq -r '.description')"
version="$BOX_VERSION"
url="file://$(readlink -f ${boxfile})"
# TODO: improve/fix the json editing in respect to the array members, so that it can work for more than one provisioner
cat metadata.template.json | jq '.name = $value' --arg value "$name" | jq '.description = $value' --arg value "$description" | jq '.versions[].version = $value' --arg value "$version" | jq '.versions[].providers[].url = $value' --arg value "$url" > metadata.json

vagrant box add "metadata.json" --name "${boxname}"
vagrant box list

