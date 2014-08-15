function gem_path()
{
	local version="0.0.1"

	case "$1" in
		-p|--push)
			local ruby_engine ruby_version

			eval "$("$RUBY_ROOT/bin/ruby" - <<EOF
puts "ruby_engine=#{defined?(RUBY_ENGINE) ? RUBY_ENGINE : 'ruby'};"
puts "ruby_version=#{RUBY_VERSION};"
EOF
)"

			GEM_HOME="$2/.gem/$ruby_engine/$ruby_version"
			GEM_PATH="$GEM_HOME:$GEM_PATH"
			PATH="$GEM_HOME/bin:$PATH"
			;;
		-P|--pop)
			PATH=":$PATH:"

			if [[ -z "$2" || "$2" = "1" ]]; then
				GEM_PATH=":$GEM_PATH:"
			else
				GEM_PATH=$(echo "$GEM_PATH" | cut -d ":" -f "-$(($2-1)),$(($2+1))-")
			fi

			if [[ -n "$GEM_HOME" ]]; then
				PATH="${PATH//:$GEM_HOME\/bin:/:}"
				GEM_PATH="${GEM_PATH//:$GEM_HOME:/:}"
			fi

			PATH="${PATH#:}"; PATH="${PATH%:}"
			GEM_PATH="${GEM_PATH#:}"; GEM_PATH="${GEM_PATH%:}"
			GEM_HOME="${GEM_PATH%%:*}"
			;;
		-h|--help)
			cat <<USAGE
usage: gem_path [--push DIR | --pop [INDEX]]

Options:

	-p, --push DIR	Sets \$GEM_HOME and pushes DIR onto \$GEM_PATH
	-P, --pop	[INDEX] Pops the first directory, or INDEX instead if provided, off of \$GEM_PATH and
			resets \$GEM_HOME to the next directory.
	-V, --version		Prints the version
	-h, --help		Prints this message

Examples:

	$ gem_path --push /path/to/.gem

USAGE
			;;
		-V|--version)
			echo "gem_path: $version"
			;;
		"")
			local gem_path="$GEM_PATH:"
			local gem_path_count=1

			until [[ -z "$gem_path" ]]; do
				echo "  $gem_path_count: ${gem_path%%:*}"
			  let "gem_path_count++"
				gem_path="${gem_path#*:}"
			done
			;;
		*)
			printf "gem_path: unknown option: %s\n" "$1" >&2
			;;
	esac
}
