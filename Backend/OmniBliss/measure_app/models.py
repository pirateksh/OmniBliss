from django.db import models
from django.conf import settings
from profile_app.models import Cluster, Activity
User = settings.AUTH_USER_MODEL


class Priority(models.Model):
    cluster = models.ForeignKey(Cluster, on_delete=models.CASCADE)
    activity = models.ForeignKey(Activity, on_delete=models.CASCADE)
    priority = models.PositiveBigIntegerField(default=0)