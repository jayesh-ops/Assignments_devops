import boto3

# Create CloudWatch client
cloudwatch = boto3.client('cloudwatch')

# Create alarm
cloudwatch.put_metric_alarm(
    AlarmName='Web_Server_CPU_Utilization',
    ComparisonOperator='GreaterThanThreshold',
    EvaluationPeriods=1,
    MetricName='CPUUtilization',
    Namespace='AWS/EC2',
    Period=5,
    Statistic='Average',
    Threshold=80.0,
    ActionsEnabled=False,
    AlarmDescription='Alarm when server CPU exceeds 80%',
    Dimensions=[
        {
          'Name': 'billing_set01',
          'Value': 'i-0b226354b9581832a'
        },
    ],
    Unit='Minutes'
)
