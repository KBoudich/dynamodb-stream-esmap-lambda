import json
import logging

logger = logging.getLogger()
logger.setLevel(logging.INFO)


def lambda_handler(event, context):
    logging.info(json.dumps(event, indent=2))

    eventObject = {
        "functionName": context.function_name,
        "description": "this function handles updates from dynamodb stream",
        "event": event
    }

    return {
        "statusCode": 200,
        "headers": {
            "Content-Type": "application/json"
        },
        "body": json.dumps(eventObject)
    }