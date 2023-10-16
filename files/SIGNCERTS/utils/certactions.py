import json
import requests
import logging, tng
import os
import pexpect
import time

log_format = '%(asctime)s - %(name)s - %(levelname)s - %(message)s'
log = logging.getLogger(__name__)

# To override the default severity of logging
log.setLevel('DEBUG')

# Use FileHandler() to log to a file
file_handler = logging.FileHandler("certactions.log")
formatter = logging.Formatter(log_format)
file_handler.setFormatter(formatter)

# Don't forget to add the file handler
log.addHandler(file_handler)

def genCSR(server, adminUser, adminPasword):


def signCert(server, adminUser, adminPasword):


def uploadCert(server, adminUser, adminPasword):


