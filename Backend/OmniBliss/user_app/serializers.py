from .models import CustomUser
from rest_framework import serializers


class RegistrationSerializer(serializers.ModelSerializer):
    class Meta:
        model = CustomUser
        fields = ['first_name', 'last_name', 'email', 'username', 'password']

    def save(self):
        instance = CustomUser(
                    first_name = self.validated_data['first_name'],
                    last_name=self.validated_data['last_name'],
                    email = self.validated_data['email'],
                    username = self.validated_data['username'],
                )
        password = instance.set_password(self.validated_data['password'])
        instance.save()
        return instance
