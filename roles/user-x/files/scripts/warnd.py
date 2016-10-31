#!/usr/bin/python
# -*- coding: latin1 -*-

import getopt, sys, string, os, textwrap

Options = {
    'daemon': False,
    'fifo': os.environ['HOME'] + '/warnd_fifo',
    'log': [],
    'time' : 2,
    'size' : 54,
    'wrap' : 0,
    }

State = {
    'currentlog' : 0,
    }

USAGE = string.join([
    'Usage: %s' % sys.argv[0],
    '  Warns the user about something, one-liner.',
    '  -f, --fifo FIFO            Create designed fifo. Default is %s.' % Options['fifo'],
    '  -l, --log LOG1,LOG2,...    Where to log the messages. Userfull with root-tail. Default: no log.',
    ], '\n')

def usage():
    print USAGE

def loga(lines):
    if len(Options['log']) == 0:
        return
    log = Options['log'][State['currentlog']]
    hoje = os.popen("date +%b\\ %e\\ %H:%M:%S", 'r')
    line = hoje.read()[:-1] + ' ' + os.environ['USER'] + ' ' + "".join(lines)
    hoje.close()
    log.write(line + "\n")
    print line
    log.flush()
    State['currentlog'] = (State['currentlog'] + 1) % len(Options['log'])

def doline(lines):
    loga(lines)
    os.system("xkbbell")

def main():
    try:
        opts, args = getopt.getopt(sys.argv[1:], 'hf:l:t:s:w:', ['help', 'fifo', 'log', 'wrap'])
    except getopt.GetoptError:
        usage()
        sys.exit(2)
    for o, a in opts:
        if o in ('-h', '--help'):
            usage()
            sys.exit()
        if o in ('-f', '--fifo'):
            Options['fifo'] = a
        if o in ('-l', '--log'):
            for log in a.split(','):
                Options['log'].append(open(log, 'a'))

    cfg = open('%s/.warnd.cfg' % os.environ['HOME'], 'w+')
    cfg.write(Options['fifo']+'\n')
    cfg.close()

    os.system('mkfifo %s 2>/dev/null; chmod 0660 %s' % (Options['fifo'], Options['fifo']))

    while True:
        lines = []
        fifo = open(Options['fifo'],'r')
        for line in fifo.readlines():
            lines.append(line.strip())
        fifo.close()
        doline(lines)

if __name__ == '__main__':
    main()

