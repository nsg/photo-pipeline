#!/usr/bin/env python3

import sys
from subprocess import Popen, PIPE, STDOUT

for line in sys.stdin:
    p = Popen(['./consumer.sh', 'process'], stdout=PIPE, stdin=PIPE, stderr=PIPE)
    print(p.communicate(input=line.encode())[0].decode(), end="")
