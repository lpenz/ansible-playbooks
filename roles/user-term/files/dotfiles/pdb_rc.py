
def _pdbrc_init():
    # Save history across sessions
    import readline
    import os
    histfile = os.path.join(os.environ['HOME'], ".pdb-pyhist")
    try:
        readline.read_history_file(histfile)
    except IOError:
        pass
    import atexit
    atexit.register(readline.write_history_file, histfile)
    readline.set_history_length(500)


_pdbrc_init()
del _pdbrc_init
