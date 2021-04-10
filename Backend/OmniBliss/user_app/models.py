from django.db import models
from django.contrib.auth.models import AbstractUser

from django.db.models.signals import post_save
# receiver is function that performs some task after receivng a signal
from django.dispatch import receiver
from rest_framework.authtoken.models import Token
from profile_app.models import Profile


class CustomUser(AbstractUser):
    email = models.EmailField(unique=True)


@receiver(post_save,sender=CustomUser) # takes signal:post_save and sender as arguments
def create_auth_token(sender, instance=None, created=False, **kwargs):
    if created:
        print("Hello From Signal")
        Token.objects.create(user=instance)


@receiver(post_save,sender=CustomUser) # takes signal:post_save and sender as arguments
def create_auth_token(sender, instance=None, created=False, **kwargs):
    if created:
        Profile.objects.create(user=instance)