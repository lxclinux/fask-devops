#!/bin/bash -e

gunicorn -c /work/gunicorn-config.py fake_jenkins:app
