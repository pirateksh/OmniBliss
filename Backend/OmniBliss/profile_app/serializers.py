from django.contrib.auth.models import User
from rest_framework import serializers
from .models import Profile


class ViewProfileSerializer(serializers.ModelSerializer):
    class Meta:
        model = Profile
        fields = ['user', 'age', 'gender', 'occupation', 'annual_salary']


class UpdateProfileSerializer(serializers.ModelSerializer):
    class Meta:
        model = Profile
        fields = ['age', 'hobbies', 'gender', 'occupation', 'annual_salary']

