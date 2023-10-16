import json
import logging
from os import name
from bs4.element import ResultSet

from zeep.xsd.types.builtins import Long
from zeep.helpers import serialize_object
from zeep.exceptions import Fault
import requests
import os
import urllib3
from bs4 import BeautifulSoup
from zeep import Client
from requests.auth import HTTPBasicAuth

urllib3.disable_warnings(urllib3.exceptions.InsecureRequestWarning)

log_format = '%(asctime)s - %(name)s - %(levelname)s - %(message)s'
log = logging.getLogger(__name__)

# To override the default severity of logging
log.setLevel('DEBUG')

# Use FileHandler() to log to a file
file_handler = logging.FileHandler("jabberPy.log")
formatter = logging.Formatter(log_format)
file_handler.setFormatter(formatter)

# Don't forget to add the file handler
log.addHandler(file_handler)

BASE_DIR = os.path.dirname(os.path.realpath(__file__))
TEST_DIR = os.path.join(BASE_DIR, "..", "test")
test_conf_file_path = TEST_DIR + '/test.conf'

def parse_test_config():
    with open(test_conf_file_path) as f:
        test_config = json.load(f)
    log.info("Test config: %s", json.dumps(test_config))
    return test_config

