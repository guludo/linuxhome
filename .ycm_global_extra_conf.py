from glob import glob
import os.path

def Settings( **kwargs ):
    r = {}
    for path in glob(os.path.join('*', 'bin', 'activate')):
        python = os.path.join(os.path.dirname(path), 'python')
        if os.access(python, os.X_OK):
            r['interpreter_path'] = python
            break
    return r
