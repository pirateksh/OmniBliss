from django.db import models
# from django.contrib.auth.models import User
from django.conf import settings
from phonenumber_field.modelfields import PhoneNumberField
# from django_countries.fields import CountryField

User = settings.AUTH_USER_MODEL
# Create your models here.
Gender_Choices = (
    ('0', 'Male'),
    ('1', 'Female')
)

# Hobbies_Choices = (
#     ('0', 'Playing Video Game'),
#     ('1', 'Reading Book')
# )


class Occupation(models.Model):
    title = models.CharField(max_length=100)


class Profile(models.Model):
    user = models.OneToOneField(User,on_delete=models.CASCADE)
    age = models.PositiveIntegerField(null=True, default=None)
    gender = models.CharField(max_length=1, choices=Gender_Choices, null=True, default=None)
    occupation = models.ForeignKey(Occupation, null=True, on_delete=models.SET_NULL, default=None)
    phone = PhoneNumberField(null=True, blank=False, unique=True, default=None)
    hobbies = models.PositiveIntegerField(null=True, default=None)
    is_updated = models.BooleanField(default=False)
    # country = CountryField()
    """
        Other required:-
            cluster: Foreign Key
            hobbies: separate Table(Exists on Front-end-Side)
    """
    def __str__(self):
        return "{} {}".format(self.user,"Profile")



