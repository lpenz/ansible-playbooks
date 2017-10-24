#!/usr/bin/env python

import string
import logging
import sys
import getopt
import re
import syslog
import pygtk
import gtk
import gobject

pygtk.require('2.0')

USAGE = string.join([
    'Usage: %s [-h] [-l] [-f <file>] [-o <file>]' % sys.argv[0],
    '  Puts clipboard in file or log when it changes.',
    '  -l, --log           Output to syslog, USER NOTICE.',
    '  -m, --max <columns> Max number of chars to diplay per clipboard',
    '  -f <file>, --file   Logs to file.',
    '  -o <file>, --output Output to file.',
    '  -b, --bare          No decoration on info.',
    '  -c, --clipboard     Only clipboard.',
    '  -p, --primary       Only primary clipboard.',
    '  -s, --secondary     Only secondary clipboard.',
], '\n')


def usage():
    print(USAGE)


class Clipboard(object):
    # signal handler called when the clipboard returns text data
    def clipboard_text_received(self, clipboard, text, data):
        if not text:
            return
        text = ' '.join(text.split('\n')).strip()
        text = re.sub(r'\s+', ' ', text)
        text = text[0:self.maxlen]
        if text != self.last:
            if self.log:
                if self.bare:
                    syslog.syslog(syslog.LOG_NOTICE | syslog.LOG_USER, text)
                else:
                    syslog.syslog(syslog.LOG_NOTICE | syslog.LOG_USER,
                                  self.name + ' [' + text + ']')
            if self.fname:
                if self.bare:
                    logging.info(text)
                else:
                    logging.info(self.name + ' [' + text + ']')
            if self.fdout:
                if self.bare:
                    self.fdout.write(text + '\n')
                else:
                    self.fdout.write(self.name + ': ' + text + '\n')
                self.fdout.flush()
            print(self.name + ': ' + text)
            self.last = text
        return

    # get the clipboard text
    def fetch_clipboard_info(self):
        self.clipboard.request_text(self.clipboard_text_received)
        return True

    def __init__(self, type, name, log, fname, fdout, bare, maxlen):
        self.last = ''
        self.name = name
        self.clipboard = gtk.clipboard_get(type)
        self.clipboard.request_text(self.clipboard_text_received)
        self.log = log
        self.fname = fname
        self.fdout = fdout
        self.bare = bare
        self.maxlen = maxlen
        gobject.timeout_add(1500, self.fetch_clipboard_info)
        return


def main():
    fname = False
    log = False
    fdout = False
    chose = False
    chosec = False
    chosep = False
    choses = False
    maxlen = 500
    bare = False
    try:
        opts, args = getopt.getopt(sys.argv[1:],
                                   'hlf:o:bcpsm:',
                                   ['help', 'log', 'file', 'output', 'bare',
                                    'clipboard', 'primary', 'secondary',
                                    'max'])
    except getopt.GetoptError:
        usage()
        sys.exit(2)
    for o, a in opts:
        if o in ('-h', '--help'):
            usage()
            sys.exit(0)
        if o in ('-l', '--log'):
            log = True
        if o in ('-f', '--file'):
            fname = True
            logging.basicConfig(level=logging.INFO,
                                format='%(asctime)s \
                                        %(name)s clipboard: %(message)s',
                                datefmt='%b %d %H:%M:%S',
                                filename=a,
                                filemode='a')
        if o in ('-o', '--output'):
            fdout = open(a, 'a')
        if o in ('-b', '--bare'):
            bare = True
        if o in ('-c', '--clipboard'):
            chose = True
            chosec = True
        if o in ('-p', '--primary'):
            chose = True
            chosep = True
        if o in ('-s', '--secondary'):
            chose = True
            choses = True
        if o in ('-m', '--max'):
            maxlen = int(a)
    cbe = []
    if chosec or not chose:
        cbe.append(Clipboard(gtk.gdk.SELECTION_CLIPBOARD,
                             'clipboard', log, fname, fdout, bare, maxlen))
    if chosep or not chose:
        cbe.append(Clipboard(gtk.gdk.SELECTION_PRIMARY,
                             'primary', log, fname, fdout, bare, maxlen))
    if choses or not chose:
        cbe.append(Clipboard(gtk.gdk.SELECTION_SECONDARY,
                             'secondary', log, fname, fdout, bare, maxlen))
    syslog.openlog('clipboard')
    gtk.main()
    return 0


if __name__ == '__main__':
    main()
