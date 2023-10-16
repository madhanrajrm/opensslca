from os import system
from utils import utility
from utils import certactions
import os
import logging

log_format = '%(asctime)s - %(name)s - %(levelname)s - %(message)s'
log = logging.getLogger(__name__)

# To override the default severity of logging
log.setLevel('DEBUG')

# Use FileHandler() to log to a file
file_handler = logging.StreamHandler()
formatter = logging.Formatter(log_format)
file_handler.setFormatter(formatter)

# Don't forget to add the file handler
log.addHandler(file_handler)

def manage_test():
    test_config = utility.parse_test_config()

    for test in test_config['tests']:
        if test == 'genCSR':
            if (certactions.genCSR(test_config['server'], test_config['username'], test_config['password'])) == False:
                log.error("CSR Generation for unit failed")
            else:  
                log.info("CSR Generation successful")
        
	if test == 'signCert':
            if (certactions.signCert(test_config['server'], test_config['username'], test_config['password'])) == False:
                log.error("Sign Certificate using Openssl CA failed")
            else:  
                log.info("Certificate signed successful using OpenSSL CA")
        
	if test == 'uploadCert':
            if (certactions.uploadCert(test_config['server'], test_config['username'], test_config['password'])) == False:
                log.error("Certificate upload has failed")
            else:  
                log.info("Certificate uploaded Successfully")
        

if __name__ == "__main__":
    manage_test()
