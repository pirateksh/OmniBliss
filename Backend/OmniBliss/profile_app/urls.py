from django.urls import path
from . import views

urlpatterns = [
    path('', views.view, name="view_profile"),
    path('update/', views.update, name="update_profile"),
]

