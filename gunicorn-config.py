from gevent import monkey
monkey.patch_all()
import multiprocessing
debug = True
loglevel = 'debug'
bind = '0.0.0.0:80' 
logfile = 'gunicorn-debug.log'
workers = 4
worker_class = 'gevent' 