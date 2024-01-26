#!/bin/bash

set -euo pipefail
shopt -s inherit_errexit

. ./VULTR_APP

out_dir="./dist"

# Used for determining file mode in resulting script snippet
shebang_b64="$(printf %s '#!' | base64 -w 0)"

generate_file_entries()
{
	# Use same directory for both args if only one provided
	local to_add="${1:?}" base_dir="${2:-"${1}"}"

	for file_name in "${to_add}"/*; do
		if [[ -d "${file_name}" ]]; then
			generate_file_entries "${file_name}" "${base_dir}"
			continue
		fi

		# check for empty dirs, or dirs that only have .file contents
		if [[ "${file_name}" =~ ^${to_add}\/\*$ ]]; then
			continue
		fi

		local encoded_content="" file_path="" file_mode=""
		encoded_content="$(base64 -w 0 "${file_name}")"

		if ! file_path="/$(realpath --relative-to="${base_dir}" "${file_name}" 2> /dev/null)"; then
			# the "$to_add" dir is not within the app's rootfs dir, so the file goes to where it was specified
			# via "$base_dir"
			file_path="/${base_dir}/${file_name##*/}"
		fi

		# Check first few b64 characters of file contents and if they match a b64 '#!', let root exec it
		if [[ "${encoded_content:0:4}" =~ ^${shebang_b64}* ]]; then
			file_mode="0744"
		fi

		printf "mkdir -p \"%s\"; base64 -d <<< \"%s\" > \"%s\"; chmod %s \"%s\"\n" \
			"${file_path%/*}" "${encoded_content}" "${file_path}" "${file_mode:-"0644"}" "${file_path}"
	done
}

generate_file_list()
{
	local rootfs_dir="${1:?}" app=""

	app="${rootfs_dir%/*}"
	app="${app##*/}"

	generate_file_entries "./image/rootfs"
	printf '\n'
}

build_app()
{
	local app="${1:?}"
	local build_name="${app}" cloud_config="" install_script_name=""

	cloud_config="${out_dir}/${build_name}.sh"
	printf '%s\n' '#!/bin/bash' > "${cloud_config}"

	generate_file_list "./image//rootfs" >> "${cloud_config}"

	install_script_name="install.sh"
	printf '/root/app_binaries/%s 2>&1\n' "${install_script_name}" >> "${cloud_config}"

	build_result="SUCCESS"
}

mkdir -p "${out_dir}"

app_name="${VULTR_APP_NAME// /}" # strip all spaces
app_name="${app_name@L}"       # make lowercase

build_result="FAILED" # pessimistic building and updated by called func
build_app "${app_name}"

printf "%s: [%s]\n" "${VULTR_APP_NAME}" "${app_name}"
