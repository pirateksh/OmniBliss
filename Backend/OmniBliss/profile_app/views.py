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


def dec_to_bin_list_padded(num):
    res = [int(i) for i in list('{0:0b}'.format(num))]
    if len(res) > 9:
        return [0, 0, 0, 0, 0, 0, 0, 0, 0]
    rem = 9 - len(res)
    res.reverse()
    for i in range(rem):
        res.append(0)
    res.reverse()
    return res


def hobbies_parser(hobby_list):
    hobby_1 = (4 * hobby_list[0]) + (2 * hobby_list[1]) + (1 * hobby_list[2])
    hobby_2 = (4 * hobby_list[3]) + (2 * hobby_list[4]) + (1 * hobby_list[5])
    hobby_3 = (4 * hobby_list[6]) + (2 * hobby_list[7]) + (1 * hobby_list[8])
    return hobby_1, hobby_2, hobby_3


def clusterify(age, gender, income, occupation, hobbies):

    hobby_1, hobby_2, hobby_3 = hobbies_parser(dec_to_bin_list_padded(hobbies))
    row = [age, income, occupation, hobby_1, hobby_2, hobby_3]
    if gender == 0:  # Male
        row.append(0)
        row.append(1)
        row.append(1)
    elif gender == 1:  # Female
        row.append(1)
        row.append(0)
        row.append(1)
    elif gender == 2:  # Others
        row.append(1)
        row.append(1)
        row.append(0)

    import pickle
    loaded_model = pickle.load(open("kmeans_user_clustering.sav", 'rb'))
    result = loaded_model.predict([row])
    return result


@api_view(['POST'])
# @permission_classes([IsAuthenticated])
def update(request, **kwargs):
    """
        request params:
        age, gender, annual_salary, occupation, hobbies

    """
    age = int(request.data.get('age'))
    gender = int(request.data.get('request'))
    income = int(request.data.get('annual_salary'))
    occupation = int(request.data.get('occupation'))
    hobbies = int(request.data.get('hobbies'))

    username = kwargs['username']
    user_instance = get_object_or_404(User, username=username)
    id = user_instance.id
    response = {"username": username}
    if username == request.user.username:
        profile_instance = Profile.objects.get(user_id=id)

        # Added by Kshitiz
        cluster = clusterify(age=age, gender=gender, income=income, occupation=occupation, hobbies=hobbies)


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
