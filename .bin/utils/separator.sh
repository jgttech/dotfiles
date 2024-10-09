#!/usr/bin/env bash
function separator {
  line=""

  for i in {1..45}
  do
    line+="_"
  done

  printf "$(dim $line)\n"
}
