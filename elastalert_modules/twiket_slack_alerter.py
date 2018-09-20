from elastalert.alerts import SlackAlerter
import os

class TwiketSlackAlerter(SlackAlerter):
  required_options = set()

  def __init__(self, rule):
    override_webhook = os.getenv('SLACK_WEBHOOK_URL')
    override_channel = os.getenv('SLACK_CHANNEL')
    if override_webhook and len(override_webhook) > 0:
      rule['slack_webhook_url'] = override_webhook
    if override_channel and len(override_channel) > 0:
      rule['slack_channel_override'] = override_channel
    super(TwiketSlackAlerter, self).__init__(rule)
