#!/bin/bash

PORT=/dev/ # Add correct port
rshell --port $PORT cp ../pico/main.py /pyboard/
rshell --port $PORT repl 'exec(open("/pyboard/main.py").read())'