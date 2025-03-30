#!/bin/sh
gunicorn -w 4 -b 0.0.0.0:8000 main:app &  # Start Gunicorn in the background
python3 main.py  # Start main.py
