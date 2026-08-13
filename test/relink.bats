#!/usr/bin/env bats

load helpers

setup() { setup_fixture; }
teardown() { teardown_fixture; }

@test "runs against an empty config and reports nothing to do" {
  run "$RELINK"
  [ "$status" -eq 0 ]
}
