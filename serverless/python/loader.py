import logging
import os
import time
from threading import Thread

# Load generator
class Loader(object):

    # Gets the query to run
    def __init__(self, query):
        logging.debug("Initializing")
        self.sql = query.get('sql')
        self.endpoint = query.get('endpoint')
        self.result = None
        self._connection = None

    # Connect to the database
    def _connect(self):
        logging.debug("Connecting to endpoint = %s" % self.endpoint)

    # Execute the query
    def _execute(self):
        logging.debug("Executing query %s" % self.sql)

    # Disconnect
    def _disconnect(self):
        log("Disconnecting from endpoint = %s" % self.endpoint)

    # thread run
    def run(self):
        logging.debug("Starting thread")

# Creates a new thread
def  create_thread(query: dict):
    thread = Loader(query)
    thread.run()
    return thread

# Launch multiple threads
def generate_threads(count, query, delay):

    threads = [None for i in range(0, count-1)]

    while True:

        for i in range(len(threads)):
            logging.info("Thread %s recycled." % i)
            threads[i] = Thread(target=create_thread, args=(query,))
            threads[i].start()

        time.sleep(delay)

def main():
    
    # Setup logger
    logging.basicConfig(level=logging.DEBUG)

    # Get the endpoints from environment variables
    READEREP=os.getenv('READEREP')
    WRITEREP=os.getenv('WRITEREP')

    logging.debug("READEREP=%s" % READEREP)


    query={'sql': 'select', 'cluster-endpoint': 'ep'}
    generate_threads(5, query, 5)

# Launch the main function
if __name__ == "__main__":
    main()