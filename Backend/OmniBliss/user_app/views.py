from django.contrib.auth import authenticate
from rest_framework.decorators import api_view
from rest_framework.response import Response
from rest_framework.authtoken.models import Token


from .serializers import RegistrationSerializer


@api_view(['POST'])
def register(request):
    """
        request params:
        first_name, last_name, username, email, password, password1
    """
    response = {}
    # if request.data.get('password') is None or request.data.get('first_name') is None or request.data.get('last_name') is None /is None:
    #     response['msg'] = "Incomplete Fields"
    #     return Response(response)

    # if request.data.get('password') != request.data.get('password1'):
    #     response['msg'] = "Password Did Not Match"
    #     return Response(response)

    serializer = RegistrationSerializer(data=request.data)

    if serializer.is_valid():
        print(serializer.data)
        instance = serializer.save()
        response['msg'] = "Successfully Registered"
        response['email'] = instance.email
        response['username'] = instance.username
        token = Token.objects.get(user=instance).key
        response['token'] = token
    else:
        response = serializer.errors
    return Response(response)
