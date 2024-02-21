import boto3
import logging

#Instantiate logger
logger = logging.getLogger()
logger.setLevel(logging.INFO)

def lambda_handler(event, context):
    logger.info('event: {}'.format(event))
    
    try:
        #Do something here:
        logger.info('This is just a test empty function')

    except Exception as error:
        #Log the Error:
        logger.error(error)

        #Lambda error response:
        return {
            'statusCode': 400,
            'message': 'An error has occurred',
            'moreInfo': {
                'Lambda Request ID': '{}'.format(context.aws_request_id),
                'CloudWatch log stream name': '{}'.format(context.log_stream_name),
                'CloudWatch log group name': '{}'.format(context.log_group_name)
                }
            }
