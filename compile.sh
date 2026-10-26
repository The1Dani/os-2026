#!/usr/bin/bash
#Usage ". complie.sh"

c() {
  cc -Wall -Wextra -o "$1" "$1.c"
}

