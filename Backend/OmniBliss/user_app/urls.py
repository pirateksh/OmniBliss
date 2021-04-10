from django.urls import path, include
from rest_framework.authtoken.views import obtain_auth_token

from . import views

urlpatterns = [
    path('register/', views.register, name="register"),
    path('login/', obtain_auth_token, name="login"),
    path('<str:username>/', include('profile_app.urls')),
]

