from django.contrib.auth import get_user_model
from django.http import Http404
from rest_framework.authtoken.models import Token
from rest_framework.decorators import api_view, permission_classes
from rest_framework.generics import get_object_or_404
from rest_framework.response import Response
from rest_framework.permissions import IsAuthenticated
User = get_user_model()
from .models import Profile
from .serializers import ViewProfileSerializer, UpdateProfileSerializer


@api_view(['GET'])
@permission_classes([IsAuthenticated])
def view(request, **kwargs):
    username = kwargs['username']
    instance = get_object_or_404(User, username=username)
    id = instance.id
    response = {}
    if username == request.user.username:
        instance = Profile.objects.get(user=id)
        serializer = ViewProfileSerializer(instance)
        return Response(serializer.data)
    else:
        raise Http404


@api_view(['POST'])
# @permission_classes([IsAuthenticated])
def update(request, **kwargs):
    """
        request params:
        age, gender, phone, occupation, hobbies
    """
    username = kwargs['username']
    user_instance = get_object_or_404(User, username=username)
    id = user_instance.id
    response = {"username": username}
    if username == request.user.username:
        profile_instance = Profile.objects.get(user_id=id)
        serializer = UpdateProfileSerializer(profile_instance, data=request.data)
        if serializer.is_valid():
            instance = serializer.save()
            response['msg'] = "Successfully Updated Profile"
            return Response(response)
        else:
            response['err'] = serializer.errors
            return Response(response)
    else:
        raise Http404

    # TODO: Assign Cluster after adding cluster field to Profile Model
