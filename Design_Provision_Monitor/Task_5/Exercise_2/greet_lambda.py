import os

def lambda_handler(event, context):
    print('## EVENT')
    return "{} from Lambda!".format(os.environ['greeting'])
