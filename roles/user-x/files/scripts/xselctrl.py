#!/usr/bin/env python
'''X selection synchronization and control'''

import sys
import getopt
import pygtk
pygtk.require('2.0')
import gtk
import gobject
import dbus
import dbus.service
import dbus.glib

# Usage: #####################################################################

USAGE = '\n'.join([
    'Usage: %s [-g|-s]' % sys.argv[0],
    '  Sincronizes primary and clipboard selections.',
    '    -g, --get: gets secondary clipboard.',
    '    -s, --set: sets secondary clipboard.'
    ])

def usage():
    '''Prints usage information.'''
    print USAGE

# General functions: #########################################################

def txtsumm(txt, size):
    '''Returns summary-text - txt with no newlines and trimmed to size bytes.'''
    return (''.join(txt.split('\n')))[0:size-1]


def servicedbusget():
    '''Gets xselctrl service from DBUS.'''
    bus = dbus.SessionBus()
    return bus.get_object('org.x.selection.xselctrl', '/org/x/selection/xselctrl')

# Specific implementation: ###################################################

class Selection:
    '''Class that deals with selection changes and syncs the others.'''

    def secondary_set(self):
        '''Sets secondary with my self text.'''
        print 'secondary set from %s' % self.name
        self.selection.request_text(self.text_received_secondaryset)

    def text_received_secondaryset(self, _unused1, text, _unused2):
        '''Helper for self.secondary_set.'''
        print '%-9s <- %-9s [%-30s]' % ('secondary', self.name, txtsumm(text, 30))
        self.allselections['secondary'].set_text(text)


    def spread(self):
        '''Spreads self.text to other selections.'''
        print 'spread from %s' % self.name
        self.selection.request_text(self.text_received_spread)

    def text_received_spread(self, _unused1, text, _unused2):
        '''Helper for self.spread.'''
        for sel in self.allselections.itervalues():
            if sel.auto and sel != self:
                print '%-9s <- %-9s [%-30s]' % (sel.name, self.name, txtsumm(text, 30))
                sel.set_text(text)


    def text_received_checkchanged(self, _unused1, text, _unused2):
        '''Signal handler called when the selection returns text data.'''
        if not text or text == '' or text == self.last:
            return
        #print '%-9s changed! [%-30s]->[%-30s]' % (self.name, txtsumm(self.last, 30), txtsumm(text, 30))
        self.text_received_spread(_unused1, text, _unused2)
        self.last = text

    def checkchanged(self):
        '''Requests text from selection to check for changes.'''
        self.selection.request_text(self.text_received_checkchanged)
        return True


    def set_text(self, text):
        '''Sets selection text, to be called by other selections.'''
        self.selection.set_text(text)
        self.last = text


    def __init__(self, selinfo, allselections):
        self.info = selinfo
        self.name = selinfo['name']
        self.type = selinfo['type']
        self.auto = selinfo['auto']
        self.allselections = allselections
        self.last = ''
        self.selection = gtk.clipboard_get(self.type)
        self.selection.request_text(self.text_received_checkchanged)
        if self.auto:
            gobject.timeout_add(1500, self.checkchanged)
        return

# dbus server: ###############################################################

class SelectionDBUSServer(dbus.service.Object):
    '''DBUS server class.'''
    def __init__(self, allselections):
        self.allselections = allselections
        bus_name = dbus.service.BusName('org.x.selection.xselctrl', bus=dbus.SessionBus())
        dbus.service.Object.__init__(self, bus_name, '/org/x/selection/xselctrl')

    @dbus.service.method('org.x.selection.xselctrl')
    def get(self):
        '''Sets all selections with secondary contents.'''
        self.allselections['secondary'].spread()

    @dbus.service.method('org.x.selection.xselctrl')
    def set(self):
        '''Sets secondary with primary selection.'''
        self.allselections['primary'].secondary_set()

# Server main function: ######################################################

def servermain():
    '''Main function of server.'''
    started = True
    try:
        servicedbusget()
    except dbus.exceptions.DBusException:
        started = False
    if started:
        print 'Server already started.'
        usage()
        sys.exit(1)
    selectioninfo = [
            { 'name': 'clipboard', 'type': gtk.gdk.SELECTION_CLIPBOARD , 'auto': True },
            { 'name': 'primary',   'type': gtk.gdk.SELECTION_PRIMARY   , 'auto': True },
            { 'name': 'secondary', 'type': gtk.gdk.SELECTION_SECONDARY , 'auto': False },
            ]
    allselections = {}
    for selinfo in selectioninfo:
        allselections[selinfo['name']] = Selection(selinfo, allselections)
    SelectionDBUSServer(allselections)
    gtk.main()

# Client main function: ######################################################

def clientmain(cmd):
    '''Client main function.'''
    service = servicedbusget()
    func = service.get_dbus_method(cmd, 'org.x.selection.xselctrl')
    func()

# Main function: #############################################################

def main():
    '''Main function.'''
    cmd = False
    try:
        opts, _ = getopt.getopt(sys.argv[1:], 'hgs', ['help', 'get', 'set'])
    except getopt.GetoptError:
        usage()
        sys.exit(2)
    for opt, _ in opts:
        print opt
        if opt in ('-h', '--help'):
            usage()
            sys.exit(0)
        if opt in ('-g', '--get'):
            if cmd:
                usage()
                sys.exit(1)
            cmd = 'get'
        if opt in ('-s', '--set'):
            if cmd:
                usage()
                sys.exit(1)
            cmd = 'set'
    if cmd:
        clientmain(cmd)
    else:
        servermain()
    return 0


if __name__ == '__main__':
    main()

