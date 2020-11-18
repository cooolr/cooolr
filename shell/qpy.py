def initeggs():
    import glob, sys, imp, os, os.path
    for item in glob.glob(os.path.dirname(os.path.abspath(__file__))+"/*.egg"):
        if item not in sys.path:
            sys.path.append(item)
#######

initeggs()
try:
    import os
    home = os.getenv('ANDROID_PUBLIC')
    scripts = os.path.join(home,'scripts')
    projects = os.path.join(home,'projects')
    sdcard = os.path.dirname(home)
    tmp = os.getenv('TMP')
    if os.getcwd()=='/': os.chdir(home)
except:
    pass
