. ./test/helper.sh

function setUp()
{
	original_path="$PATH"
	original_gem_home="$GEM_HOME"
	original_gem_path="$GEM_PATH"

	eval "$("$RUBY_ROOT/bin/ruby" - <<EOF
puts "ruby_engine=#{defined?(RUBY_ENGINE) ? RUBY_ENGINE : 'ruby'};"
puts "ruby_version=#{RUBY_VERSION};"
EOF
)"
}

function test_pop()
{
	gem_path --push "$HOME"
	gem_path --pop

	assertEquals "did not remove bin/ from \$PATH" "$PATH" "$original_path"
	assertEquals "did not remove gem dir from \$GEM_PATH" "$GEM_PATH" "$original_gem_path"
	assertEquals "did not reset \$GEM_HOME" "$GEM_HOME" "$original_gem_home"
}

function test_pop_index()
{
	gem_path --push "$HOME"
	gem_path --pop 2

	assertEquals "$GEM_PATH" "$HOME/.gem/$ruby_engine/$ruby_version:${GEM_PATH#*:}"
}

SHUNIT_PARENT=$0 . $SHUNIT2
