#!/usr/bin/env python3

# This file is part of the Printrun suite.
#
# Printrun is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# Printrun is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with Printrun.  If not, see <http://www.gnu.org/licenses/>.

import os
import sys
import getopt
import xmlrpc.client
from xmlrpc.client import ServerProxy, Error
from appdirs import user_cache_dir
import socket
import time

try:
    import wx  # NOQA
    if wx.VERSION < (4,):
        raise ImportError()
except:
    print("wxPython >= 4 is not installed. This program requires wxPython >=4 to run.")
    raise

from printrun.pronterface import PronterApp

if __name__ == '__main__':

    from printrun.printcore import __version__ as printcore_version

    os.environ['GDK_BACKEND'] = 'x11'

    usage = "Usage:\n"+\
            "  pronterface [OPTIONS] [FILE]\n\n"+\
            "Options:\n"+\
            "  -h, --help\t\t\tPrint this help message and exit\n"+\
            "  -V, --version\t\t\tPrint program's version number and exit\n"+\
            "  -v, --verbose\t\t\tIncrease verbosity\n"+\
            "  -a, --autoconnect\t\tDon't automatically try to connect to printer on startup\n"+\
            "  -c, --conf, --config=CONFIG_FILE\tLoad this file on startup instead of .pronsolerc; you may chain config files, if so settings auto-save will use the last specified file\n"+\
            "  -e, --execute=COMMAND\t\tExecutes command after configuration/.pronsolerc is loaded; macros/settings from these commands are not autosaved"

    try:
        opts, args = getopt.getopt(sys.argv[1:], "hVvac:e:", ["help", "version", "verbose", "autoconnect", "conf=", "config=", "execute="])
    except getopt.GetoptError as err:
        print(str(err))
        print(usage)
        sys.exit(2)
    for o, a in opts:
        if o in ('-V','--version'):
            print("printrun "+printcore_version)
            sys.exit(0)
        elif o in ('-h', '--help'):
            print(usage)
            sys.exit(0)
    
    # Single instance
    
    cache_dir = os.path.join(user_cache_dir("Printrun"))
    rpclock_file = os.path.join(cache_dir,"rpclock")
    rpcwait_file = os.path.join(cache_dir,"rpcwait")
    rpcwait_timeout = 10
    while(os.path.exists(rpcwait_file) and rpcwait_timeout>0):
        time.sleep(1)
        rpcwait_timeout = rpcwait_timeout - 1
    
    if os.path.exists(rpclock_file): # Check if the lock file is available
        print("rpclock found")
        rpc_port = open(rpclock_file).read()
        rpc_url = "http://localhost:"+ rpc_port
        res = socket.socket(socket.AF_INET, socket.SOCK_STREAM).connect_ex(("localhost",int(rpc_port)))
        if res == 0: 
            with ServerProxy(rpc_url) as proxy:
                gcode_file = sys.argv[1] if len(sys.argv) > 1 else ""
                if os.path.exists(gcode_file):
                    proxy.load_file(gcode_file)
            sys.exit(0)

    # Tell other instances to wait for the first instance
    open(rpcwait_file,"w").write("")
    app = PronterApp(False)
    try:
        app.MainLoop()
    except KeyboardInterrupt:
        pass
    del app
