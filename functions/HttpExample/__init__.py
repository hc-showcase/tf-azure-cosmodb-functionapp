import logging
import azure.functions as func

def main(documents: func.DocumentList) -> str:
    if documents:
        logging.info('First document Id modified: %s', documents[0]['id'])
