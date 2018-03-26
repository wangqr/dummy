#! /usr/bin/env python3
# -*- coding: utf-8 -*-

import os

included = set()


def parse_file(fn, inc_path):
    global included
    if fn in included and 'PacketMath.h' not in fn:
        return
    included.add(fn)
    dirname = os.path.dirname(fn)
    with open(fn) as fp:
        for x in fp:
            if x.strip().startswith('#'):
                xo = x
                x = x.strip()[1:].strip()
                if x.startswith('include'):
                    if '//' in x:
                        x = x[:x.index('//')]
                    x = x.strip()
                    x = x.split(None, 1)[1]
                    if x[0] == x[-1] == '"':
                        inc = [dirname] + inc_path
                    elif x[0] == '<' and x[-1] == '>':
                        inc = inc_path
                    else:
                        print(xo, end='')
                        continue
                    x = x[1:-1]
                    flag = False
                    for fe in inc:
                        fj = os.path.join(fe, x)
                        if os.path.isfile(fj):
                            parse_file(fj, inc_path)
                            flag = True
                            break
                    if not flag:
                        if xo.startswith('#include "src/'):
                            raise Exception()
                        print(xo, end='')
                else:
                    print(xo, end='')
            else:
                print(x, end='')


def main():
    parse_file(os.path.join(os.getcwd(), 'Eigen/Dense'), [os.getcwd()])


if __name__ == '__main__':
    main()
